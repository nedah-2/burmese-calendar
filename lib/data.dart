import 'package:myanmar_calendar/models/day.dart';
import 'package:myanmar_calendar/models/month.dart';

List<Day> dayList = [
  Day(id: 1, english: "1", burmese: "နတ်တော်လဆုတ် ၁ ရက်"),
  Day(id: 2, english: "2", burmese: "နတ်တော်လဆုတ် ၂ ရက်"),
  Day(id: 3, english: "3", burmese: "နတ်တော်လဆုတ် ၃ ရက်", fortune: true),
  Day(
      id: 4,
      english: "4",
      burmese: "နတ်တော်လဆုတ် ၄ ရက်",
      holiday: "လွတ်လပ်ရေးနေ့",
      fortune: false),
  Day(id: 5, english: "5", burmese: "နတ်တော်လဆုတ် ၅ ရက်", fortune: true),
  Day(id: 6, english: "6", burmese: "နတ်တော်လဆုတ် ၆ ရက်", fortune: false),
  Day(id: 7, english: "7", burmese: "နတ်တော်လဆုတ် ၇ ရက်"),
  Day(id: 8, english: "8", burmese: "နတ်တော်လဆုတ် ၈ ရက်"),
  Day(id: 9, english: "9", burmese: "နတ်တော်လဆုတ် ၉ ရက်"),
  Day(
      id: 10,
      english: "10",
      burmese: "နတ်တော်လကွယ်",
      isFullMoon: false,
      fortune: true),
  Day(
      id: 11,
      english: "11",
      burmese: "ပြာသိုလဆန်း ၁ ရက်",
      holiday: "ကရင်နှစ်သစ်ကူးနေ့",
      fortune: true),
  Day(id: 12, english: "12", burmese: "ပြာသိုလဆန်း ၂ ရက်", fortune: false),
  Day(id: 13, english: "13", burmese: "ပြာသိုလဆန်း ၃ ရက်", fortune: true),
  Day(id: 14, english: "14", burmese: "ပြာသိုလဆန်း ၄ ရက်"),
  Day(id: 15, english: "15", burmese: "ပြာသိုလဆန်း ၅ ရက်"),
  Day(id: 16, english: "16", burmese: "ပြာသိုလဆန်း ၆ ရက်"),
  Day(id: 17, english: "17", burmese: "ပြာသိုလဆန်း ၇ ရက်", fortune: false),
  Day(id: 18, english: "18", burmese: "ပြာသိုလဆန်း ၈ ရက်", fortune: true),
  Day(id: 19, english: "19", burmese: "ပြာသိုလဆန်း ၉ ရက်", fortune: false),
  Day(id: 20, english: "20", burmese: "ပြာသိုလဆန်း ၁၀ ရက်", fortune: true),
  Day(id: 21, english: "21", burmese: "ပြာသိုလဆန်း ၁၁ ရက်"),
  Day(id: 22, english: "22", burmese: "ပြာသိုလဆန်း ၁၂ ရက်"),
  Day(id: 23, english: "23", burmese: "ပြာသိုလဆန်း ၁၃ ရက်"),
  Day(id: 24, english: "24", burmese: "ပြာသိုလဆန်း ၁၄ ရက်", fortune: false),
  Day(
      id: 25,
      english: "25",
      burmese: "ပြာသိုလပြည့်",
      fortune: true,
      isFullMoon: true),
  Day(id: 26, english: "26", burmese: "ပြာသိုလဆုတ် ၁ ရက်", fortune: false),
  Day(id: 27, english: "27", burmese: "ပြာသိုလဆုတ် ၂ ရက်", fortune: true),
  Day(id: 28, english: "28", burmese: "ပြာသိုလဆုတ် ၃ ရက်"),
  Day(id: 29, english: "29", burmese: "ပြာသိုလဆုတ် ၄ ရက်"),
  Day(id: 30, english: "30", burmese: "ပြာသိုလဆုတ် ၅ ရက်"),
  Day(id: 31, english: "31", burmese: "ပြာသိုလဆုတ် ၆ ရက်", fortune: false),
];

// You can add more days if needed

// Sample data for one month
Month month = Month(
  id: 1,
  name: "၁၃၈၅-ခုနှစ် ၊ နတ်တော် - ပြာသို",
  headOne: "နဂါးခေါင်းမြောက်သို့လှည့်",
  headTwo: "နဂါးခေါင်းတောင်သို့လှည့်",
  dayList: dayList, // Add more days here
);
