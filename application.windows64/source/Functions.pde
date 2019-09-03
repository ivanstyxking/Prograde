float smoothing(float start, float end, float change) {
  float dy = end-start;
  if (abs(dy)>0) {
    start+=dy*change;
  }
  return start;
}
