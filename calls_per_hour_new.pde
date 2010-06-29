// Ein Zähler für jede Stunde
int[]hourCounter = new int[24];
// Ein Zähler für jeden Anruftyp
int[]callsCounter = new int[2];
// Startwinkel für das Kuchendiagramm
float start = 90;
// Schrift für die Überschrift und Diagrammbeschriftung
PFont font, hl;

String stundes;
String[]lines;

void setup() {
  size(600, 400);
  background(255);
  smooth();
  
  // Daten laden und Anzeigen
  loadData();
  drawBarGraph(width / 2 - 200, height - 50, 400, 200, hourCounter);
  drawSimplePie(width / 2 - 65, 175, 200, callsCounter);
  
  // Schrift für die Überschrift
  hl = createFont("Agency FB Fett", 45);
  textFont(hl);
  fill(0);
  textAlign(CENTER, CENTER);
  text("MEINE TELEFONBENUTZUNG", width / 2, 30);
}

void draw() {
  // brauchen wir wegen der keyPressed Funktionalität
}

// Funktion zum ausgeben der Daten in der Form eines Balkendiagramms
void drawBarGraph(float dx, float dy, float dWidth, float dHeight, int[]dData) {
  float barWidth = dWidth / dData.length;
  stroke(255);
  font = createFont("Arial", 12);
  textFont(font);
  
  for(int i = 0; i < dData.length; i++) {
    float value = map(dData[i], 0, max(dData), 0, dHeight);
    float gruen = map(dData[i], 0, max(dData), 0, 255);
    
    fill(0, 255 - gruen, 255);
    rect(i * barWidth + dx, dy, barWidth, -value);
    
    fill(0);
    textAlign(CENTER, BOTTOM);
    text(dData[i], (i * barWidth + dx) + (barWidth / 2), dy + -value);
    
    textAlign(CENTER, TOP);
    text(i, (i * barWidth + dx) + (barWidth / 2), dy + 3);
  }
  text("Nach Stunden des Tages", width / 2, dy + 16);
}

void drawSimplePie(float dx, float dy, float dDiameter, int[]dData) {
  for(int i = 0; i < dData.length; i++) {
    float value = dData[i] / sum(dData) * 360;
    float gruen = dData[i] / sum(dData) * 255;
    
    fill(255, gruen, 0);
    arc(dx, dy, dDiameter, dDiameter, radians(start), radians(start + value));
    
    float textPunkt = value / 2 + start;
    if(textPunkt > 45 && textPunkt < 270) {
      textAlign(CENTER, RIGHT);
    } else {
      textAlign(CENTER, LEFT);
    }
    
    float textX = dx + cos(radians(textPunkt)) * dDiameter / 4;
    float textY = dy + sin(radians(textPunkt)) * dDiameter / 4;
    
    fill(0);
    font = createFont("Arial", 23);
    textFont(font);
    if(i == 0) text("called\r\n" + round(value / 3.6) + "%", textX, textY);
    if(i == 1) text("buzzed\r\n" + round(value / 3.6) + "%", textX, textY);
    
    start = start + value;
  }
}

void loadData() {
  // CSV-Datei zeilenweise laden
  String[]lines = loadStrings("telefon.csv");
  //data = new data[lines.length];
  
  for(int i = 0; i < lines.length; i++) {
    String[]pieces = split(lines[i], ';');
    // Jede Stunde des Tages abgehen und mit Uhrzeit des Datensatzes vergleichen
    for(int stunde = 0; stunde < hourCounter.length; stunde++) {
      
      // Wenn stunde kleiner als 10 ist müssen wir eine 0 davor setzten
      // in stundes ist nun die Stringform von stunde zu finden
      if(stunde < 10) {
        stundes = '0' + Integer.toString(stunde);
      } else {
        stundes = Integer.toString(stunde);
      }
      
      // Wenn stundes der Stunde des Datensatzes entspricht
      // das jeweilige Feld in hourCounter erhöhen
      if(pieces[0].substring(0, 2).equals(stundes)) hourCounter[stunde]++;
      
      // Wenn die Aktion called oder buzzed entspricht
      // das jeweilige Feld in callsCounter erhöhen
      if(pieces[1].equals("called")) callsCounter[0]++;
      if(pieces[1].equals("buzzed")) callsCounter[1]++;
    }
  }
}

float sum(int[]dData) {
  float summe = 0;
  for(int i = 0; i < dData.length; i++) {
    summe += dData[i];
  }
  return summe;
}

// Bild speichern wenn s gedrückt wurde
void keyPressed() {
  if(key == 's') save("telefonbenutzung.png");
}
