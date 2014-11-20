# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
	Room.create(
		[{name: 'Hörsaal 1', size: 200},
		{name: 'Hörsaal 2', size: 100},
		{name: 'Hörsaal 3', size: 100},
		{name: 'Pool Raum', size: 10},
		{name: '3D Pool Raum', size: 40},
		{name: 'Seminarraum', size: 30}])

	User.create(
		[{email: 'Max.Mustermann@example.com'},
		{email: 'Helmut.Müller@example.com'},
		{email: 'Werner.Schulze@example.com'},
		{email: 'Angelika.Schuhmann@example.com'},
		{email: 'Sabine.Meier@example.com'}])

	Event.create(
		[{name: 'Mathe',
		description: 'Vorlesung',
		participant_count: 20,
		start_date: '2014-11-19',
		end_date: '2014-11-19', 
		start_time: '11:00:00',
		end_time: '12:30:00',
		user_id: 1},
		{name: 'PT',
		description: 'Vorlesung',
		participant_count: 20,
		start_date: '2014-11-19',
		end_date: '2014-11-19', 
		start_time: '13:30:00',
		end_time: '15:00:00',
		user_id: 2},
		{name: 'POIS',
		description: 'Vorlesung',
		participant_count: 20,
		start_date: '2014-11-20',
		end_date: '2014-11-20', 
		start_time: '11:00:00',
		end_time: '12:30:00',
		user_id: 3},
		{name: 'ISEC',
		description: 'Vorlesung',
		participant_count: 20,		
		start_date: '2014-11-20',
		end_date: '2014-11-20', 
		start_time: '13:30:00',
		end_time: '15:00:00',
		user_id: 4}])

	Booking.create([
		{name: 'Vorlesung 1',
		description: 'Description abc',
		start: '2014-11-19 11:00:00 UTC',
		end: '2014-11-19 12:30:00 UTC',
		event_id: 1,
		room_id: 1},
		{name: 'Vorlesung 2',
		description: 'Description def',
		start: '2014-11-19 11:00:00 UTC',
		end: '2014-11-19 12:30:00 UTC',
		event_id: 2,
		room_id: 2},
		{name: 'Vorlesung 2a',
		description: 'Description def',
		start: '2014-11-19 13:30:00 UTC',
		end: '2014-11-19 14:30:00 UTC',
		event_id: 2,
		room_id: 2},
		{name: 'Vorlesung 3',
		description: 'Description hij',
		start: '2014-11-20 11:00:00 UTC',
		end: '2014-11-20 12:30:00 UTC',
		event_id: 3,
		room_id: 3},
		{name: 'Vorlesung 4',
		description: 'Description kjl',
		start: '2014-11-20 11:00:00 UTC',
		end: '2014-11-20 12:30:00 UTC',
		event_id: 4,
		room_id: 4},
		{name: 'Vorlesung 5',
		description: 'Description mno',
		start: '2014-11-20 13:30:00 UTC',
		end: '2014-11-20 15:00:00 UTC',
		event_id: 1,
		room_id: 1},
		{name: 'Vorlesung 6',
		description: 'Description pqr',
		start: '2014-11-20 13:30:00 UTC',
		end: '2014-11-20 15:00:00 UTC',
		event_id: 2,
		room_id: 2},
		{name: 'Vorlesung 7',
		description: 'Description stu',
		start: '2014-11-19 8:00:00 UTC',
		end: '2014-11-19 9:00:00 UTC',
		event_id: 3,
		room_id: 3},
		{name: 'Vorlesung 7a',
		description: 'Description stu',
		start: '2014-11-19 13:30:00 UTC',
		end: '2014-11-19 15:00:00 UTC',
		event_id: 3,
		room_id: 3},
		{name: 'Vorlesung 8',
		description: 'Description vwx',
		start: '2014-11-19 13:30:00 UTC',
		end: '2014-11-19 15:00:00 UTC',
		event_id: 4,
		room_id: 4}])