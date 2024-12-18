// exercise_json.dart

const String exerciseJson = '''
{
  "exercise_plan_name" : "Weight Loss Exercise Plan", 
  "start_date": "2024-01-01",
  "end_date": "2024-12-31",
  "current_weight": 70,
  "end_weight": 65,
  "monday": {
      "exercises": [
          {
              "exercise_id": "23432",
              "name": "Deadlift",
              "sets": 3,
              "reps": 12,
              "exercise_type": "Strength",
              "category": "Advanced"
          },
          {
              "exercise_id": "exercise_id_2",
              "name": "Squat",
              "sets": 4,
              "reps": 10,
              "exercise_type": "Strength",
              "category": "Intermediate"
          },
          {
              "exercise_id": "exercise_id_2",
              "name": "Push-ups",
              "sets": 4,
              "reps": 10,
              "exercise_type": "Bodyweight",
              "category": "Beginner"
          },
          {
              "exercise_id": "exercise_id_2",
              "name": "Bench Press",
              "sets": 4,
              "reps": 10,
              "exercise_type": "Strength",
              "category": "Advanced"
          }
      ]
  },
  "tuesday": {
      "exercises": [
          {
              "exercise_id": "exercise_id_3",
              "name": "Bench Press",
              "sets": 3,
              "reps": 10,
              "exercise_type": "Strength",
              "category": "Advanced"
          }
      ]
  },
  "wednesday": {
      "exercises": [
          {
              "exercise_id": "exercise_id_4",
              "name": "Pull-up",
              "sets": 4,
              "reps": 8,
              "exercise_type": "Bodyweight",
              "category": "Intermediate"
          }
      ]
  },
  "thursday": {
      "exercises": [
          {
              "exercise_id": "exercise_id_5",
              "name": "Overhead Press",
              "sets": 3,
              "reps": 10,
              "exercise_type": "Strength",
              "category": "Advanced"
          }
      ]
  },
  "friday": {
      "exercises": [
          {
              "exercise_id": "exercise_id_6",
              "name": "Lunges",
              "sets": 3,
              "reps": 12,
              "exercise_type": "Strength",
              "category": "Beginner"
          }
      ]
  },
  "saturday": {
      "exercises": [
          {
              "exercise_id": "exercise_id_7",
              "name": "Push-ups",
              "sets": 4,
              "reps": 15,
              "exercise_type": "Bodyweight",
              "category": "Beginner"
          }
      ]
  },
  "sunday": {
      "exercises": [
          {
              "exercise_id": "exercise_id_8",
              "name": "Plank",
              "sets": 3,
              "reps": 60,
              "exercise_type": "Core",
              "category": "Intermediate"
          }
      ]
  }
}
''';
