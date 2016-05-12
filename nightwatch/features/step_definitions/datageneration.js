/* global rp */
'use strict'
require('sugar-date')

const randomValueFrom = (values, weights) => {
  let choices
  if (!weights) {
    choices = values
  } else {
    choices = Array.prototype.concat.apply([],
      values.map((value, index) => Array.apply(null, new Array(weights[index])).fill(value)))
  }
  return choices[Math.floor(Math.random() * choices.length)]
}

const getNewCid = (function () {
  let id = 0
  return (nonce) => (nonce + id++).toString()
})()

const getMovement = function (centre, gender, id) {
  return {
    'MO In/MO Out': randomValueFrom(['In', 'Out']),
    'Location': centre[gender + '_cid_name'],
    'MO Date': Date.create('now').format('{dd}/{MM}/{yyyy} {hh}:{mm}:{ss}'),
    'MO Type': 'Removal',
    'MO Ref.': id,
    'CID Person ID': id
  }
}

const getEvent = function (centre, gender, id) {
  return randomValueFrom([
    {
      operation: 'check in',
      timestamp: Date.create('now').toISOString(),
      centre: centre.name,
      person_id: parseInt(id),
      cid_id: parseInt(id),
      gender: gender.charAt(0),
      nationality: 'abc'
    },
    {
      operation: 'check out',
      timestamp: Date.create('now').toISOString(),
      centre: centre.name,
      person_id: parseInt(id)
    },
    {
      operation: 'reinstatement',
      timestamp: Date.create('now').toISOString(),
      centre: centre.name,
      person_id: parseInt(id)
    }
  ], [9, 9, 2])
}

const getUpdateEvent = function (centre, gender, id) {
  return {
    timestamp: Date.create('now').toISOString(),
    operation: 'update individual',
    centre: centre.name,
    person_id: parseInt(id),
    cid_id: parseInt(id),
    gender: gender.charAt(0),
    nationality: 'abc'
  }
}

const getReconciliationSet = function (centre, gender, id) {
  const result = {
    events: [],
    movements: []
  }

  const primaryEvent = getEvent(centre, gender, id)
  let movement

  switch (primaryEvent.operation) {
    case 'check in':
      movement = getMovement(centre, gender, id)
      movement['MO In/MO Out'] = 'In'
      result.movements.push(movement)
      break
    case 'check out':
      result.events.push(getUpdateEvent(centre, gender, id))
      movement = getMovement(centre, gender, id)
      movement['MO In/MO Out'] = 'Out'
      result.movements.push(movement)
      break
    case 'reinstatement':
      result.events.push(Object.assign({}, primaryEvent, { operation: 'check out' }))
      break
  }

  result.events.push(primaryEvent)

  return result
}

const getWeightedDestinations = (centres) => Array.prototype.concat.apply(
  [],
  centres.map(centre =>
    Array.apply(null, new Array(parseInt(centre.male_capacity) + parseInt(centre.female_capacity)))
      .fill({
        centre: centre,
        gender: 'male'
      }, 0, parseInt(centre.male_capacity))
      .fill({
        centre: centre,
        gender: 'female'
      }, parseInt(centre.male_capacity), parseInt(centre.male_capacity) + parseInt(centre.female_capacity))
  )
)

module.exports = function () {
  this.Then(/^I generate (\d+) unreconciled movements across the estate$/, function (count) {
    const movements = []
    const destinations = getWeightedDestinations(this.centres)

    for (var i = 0; i < count; i++) {
      const destination = randomValueFrom(destinations)
      const movement = getMovement(destination.centre, destination.gender, getNewCid(20000))
      movements.push(movement)
    }

    this.perform((client, done) =>
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/cid_entry/movement`,
        body: { Output: movements }
      })
        .finally(() => done())
    )
  })

  this.Then(/^I generate (\d+) unreconciled events across the estate$/, function (count) {
    const events = []
    const destinations = getWeightedDestinations(this.centres)

    for (var i = 0; i < count; i++) {
      const destination = randomValueFrom(destinations)
      const cidId = getNewCid(40000)
      const event = getEvent(destination.centre, destination.gender, cidId)
      events.push(event)
      if (event.operation === 'check out') {
        events.push(getUpdateEvent(destination.centre, destination.gender, cidId))
      }
    }

    events.forEach((event) => {
      this.perform((client, done) =>
        rp({
          method: 'POST',
          uri: `${client.globals.backend_url}/irc_entry/event`,
          body: event,
          jar: false
        })
          .finally(() => done())
      )
    })
  })

  this.Then(/^I generate (\d+) reconciliations across the estate$/, function (count) {
    let movements = []
    const destinations = getWeightedDestinations(this.centres)

    for (var i = 0; i < count; i++) {
      const destination = randomValueFrom(destinations)
      const reconciliation = getReconciliationSet(destination.centre, destination.gender, getNewCid(60000))
      Array.prototype.push.apply(movements, reconciliation.movements)

      reconciliation.events.forEach((event) => {
        this.perform((client, done) =>
          rp({
            method: 'POST',
            uri: `${client.globals.backend_url}/irc_entry/event`,
            body: event,
            jar: false
          })
            .finally(() => done())
        )
      })
    }

    this.perform((client, done) =>
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/cid_entry/movement`,
        body: { Output: movements }
      })
        .finally(() => done())
    )
  })
}
