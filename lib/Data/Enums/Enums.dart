//#region Duration

enum DurationUnit { days, months, years }

extension DurationUnitExtension on DurationUnit {
  String get label {
    switch (this) {
      case DurationUnit.days:
        return "Days";
      case DurationUnit.months:
        return "Months";
      case DurationUnit.years:
        return "Years";
    }
  }

  static DurationUnit fromInt(int value) {
    switch (value) {
      case 0:
        return DurationUnit.days;
      case 1:
        return DurationUnit.months;
      case 2:
        return DurationUnit.years;
      default:
        return DurationUnit.days;
    }
  }
}

//#endregion

// #region PostCategory

enum PostCategory { all, tech, career }

extension PostCategoryExtension on PostCategory {
  String get label {
    switch (this) {
      case PostCategory.all:
        return "All";
      case PostCategory.tech:
        return "Tech";
      case PostCategory.career:
        return "Career";
    }
  }

  int get value {
    switch (this) {
      case PostCategory.all:
        return 0;
      case PostCategory.tech:
        return 1;
      case PostCategory.career:
        return 2;
    }
  }

  static PostCategory fromInt(int value) {
    switch (value) {
      case 0:
        return PostCategory.all;
      case 1:
        return PostCategory.tech;
      case 2:
        return PostCategory.career;
      default:
        return PostCategory.all;
    }
  }
}

// #endregion

//#region Language
enum CourseLanguage {
  english("English", "english"),
  hindi("Hindi", "hindi"),
  telugu("Telugu", "telugu");

  final String label; // shown in UI
  final String apiValue;
  const CourseLanguage(this.label, this.apiValue);

  static CourseLanguage? fromLabel(String label) {
    return CourseLanguage.values.firstWhere(
      (e) => e.apiValue.toLowerCase() == label.toLowerCase(),
      orElse: () => CourseLanguage.english,
    );
  }
}

//#endregion
