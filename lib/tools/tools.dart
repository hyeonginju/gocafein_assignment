class Tools {
  static String convertBoxOffice(String boxOffice) {
    int amount =
        int.tryParse(boxOffice.replaceAll(r'$', '').replaceAll(',', '')) ?? 0;
    double million = amount / 10000;

    // 만명 미만인 경우 '약 1만명 이하'로 표시
    if (million < 1) {
      return '1만명 이하';
    }
    double billion = million / 10000;
    // 억이 넘어가는 경우
    if (billion >= 1) {
      return '${billion.toStringAsFixed(1)}억명';
    }

    // 그 외의 경우
    return '${million.toInt()}만 명';
  }

  static String convertRuntime(String runtime) {
    int minutes = int.tryParse(runtime.replaceAll(' min', '')) ?? 0;
    return '$minutes \분';
  }

  static String convertReleased(String released) {
    if (released == "N/A") {
      return '개봉일 정보 없음';
    }
    List<String> parts = released.split(' ');
    int day = int.tryParse(parts[0]) ?? 0;
    String month = parts[1];
    int year = int.tryParse(parts[2]) ?? 0;

    Map<String, String> monthMap = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12'
    };

    String monthNumber = monthMap[month] ?? '01'; // 월을 숫자로 변환
    String dayString = day.toString().padLeft(2, '0'); // 일을 두 자리 숫자로 변환
    String formattedDate = '$year.$monthNumber.$dayString';

    return formattedDate;
  }
}
