[![Build Status](https://travis-ci.org/keithdoggett/tcx_rb.svg?branch=master)](https://travis-ci.org/keithdoggett/tcx_rb)

# TcxRb

TcxRb is a ruby library for parsing Garmin TCX files into sensible Ruby objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tcx_rb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tcx_rb

## Usage

The simplest way to start using TcxRb is to create a workout from a file.

```ruby
workout = TcxRb.workout_from_file('/path/to/file')
# => TcxRb::Workout

workout.max_heart_rate
# => 181

workout.min_altitude
# => -3.17

workout.avg_pace
# => 3.027

workout.activities
# => [TcxRb::Activity]

workout.activities[0].laps
# => [TcxRb::Lap]

workout.activities[0].laps[0].trackpoints.size
# => 3762

workout.activities[0].laps[0].trackpoints[0].lat
# => 39.965614

workout.activities[0].laps[0].trackpoints[0].lon
# => -75.180849
```

### Types

The main classes in TcxRb are `Workout`, `Activity`, `Lap`, and `Trackpoint`.

#### Workout

`Workout` is the highest level object and its only attribute is `activities` which is an array of `Activity` objects.

`Workout` also implements `+` and `-`.

#### Activity

`Activity` is the highest level object in the tcx schema. It has the following attributes:

- `sport` - Sport detailed by the tracker (ex. Running).
- `id` - ID given by the tracker.
- `creator` - Name of the tracker.
- `laps` - Array of `Lap` objects.

#### Lap

`Lap` represents one "session" in the schema. It has a collection of trackpoints and distance associated with it. It has the following attributes:

- `start_time` - Start time of lap (string).
- `total_time` - Total time of the lap (float).
- `distance` - Total distance traveled in meters.
- `calories` - Total calories burned.
- `intensity` - Classification of lap intensity.
- `trigger_method` - Method used to start the lap.
- `trackpoints` - Array of `Trackpoint` objects.

#### Trackpoint

`Trackpoint` reprsents a sample from the tracker. Lowest level object in the hierarchy that contains the data that the other objects use for computations. It has the following attributes:

- `time` - Time the trackpoint was sampled (string).
- `latitude` - Latitude of the trackpoint.
- `longitude` - Longitude of the trackpoint.
- `altitude` - Height from sea level, in meters.
- `distance` - Total distance since the beginning of the workout, in meters.
- `heart_rate` - Heart rate the tracker sampled.
- `lat` - alias for latitude.
- `lon` - alias for longitude.

#### Parser

`Parser` is the class used to parse the tcx file into a `Workout`. A `parser` can be instansiated by passing in tcx string. It exposes the `parse_trackpoints`, `parse_laps`, and `parse_activities` methods which will return an array of hashes of the corresponding object.

Ex:

```ruby
tcx_str = File.read('/path/to/data')
parser = TcxRb::Parser.new(tcx_str)
parser.parse_trackpoints

#  => [{:time=>"2020-02-11T21:44:03.000-05:00", :latitude=>"39.965614", :longitude=>"-75.180849", :altitude=>"8.071420612508698", :distance=>"55.1", :heart_rate=>"146"}]
```

### Methods

Instances of `Workout`, `Activity`, and `Lap` all implement the following methods:

- `max_heart_rate` - Max heart rate of all trackpoints.
- `min_heart_rate` - Min heart rate of all trackpoints.
- `avg_heart_rate` - Avg heart rate of all trackpoints.
- `max_altitude` - Max altitude of all trackpoints.
- `min_altitude` - Min altitude of all trackpoints.
- `avg_altitude` - Avg altitude of all trackpoints.
- `max_pace` - Max pace of all pairs of trackpoints (m/s).
- `min_pace` - Min pace of all pairs of trackpoints (m/s).
- `avg_pace` - Avg pace of all pairs of trackpoitns (m/s).

Additionally, `Workout` and `Activity` implement the following:

- `total_tps` - The sum of the size of trackpoints contained in the child laps.
- `time` - The total "active" time of all the child laps (discounts time spent paused).
- `distance` - Total distance of all the child laps.
- `calories` - Sum of the calories burned in each child lap.

### Examples

Example using `+` and `-` with `Workout`:

```ruby
sat_workout = TcxRb.workout_from_file('saturday.tcx')
sun_workout = TcxRb.workout_from_file('sunday.tcx')

sat_workout.total_distance
# => 5000

sun_workout.total_distance
# => 10000

weekend_workouts = sat_workout + sun_workout
weekend_workouts.total_distance
# => 15000

(weekend_workouts - sat_workout).total_distance
# => 10000
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kdoggett887/tcx_rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
