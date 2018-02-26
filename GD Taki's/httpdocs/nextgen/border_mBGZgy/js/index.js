var repetition = document.getElementById("repetition");
repetition.addEventListener("change", function (evt) {
  document.getElementById("borderImageRepetition").style.borderImageRepeat = evt.target.value;
});