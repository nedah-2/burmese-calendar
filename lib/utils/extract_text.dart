String extractDirection(String input) {
  // Find the index of 'မှာ'
  int startIndex = input.indexOf('မှာ');

  // If 'မှာ' is found and it's not at the end of the string
  if (startIndex != -1 && startIndex + 3 < input.length) {
    // Extract the text after 'မှာ'
    return input.substring(startIndex + 3);
  } else {
    // 'မှာ' not found or it's at the end of the string
    return ''; // Return an empty string or handle accordingly
  }
}
