import java.util.Arrays;
import java.util.Collections;

String[] phrases;
int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 441; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
                                      //http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1.25; //aka, 1.25 inches square!
int state=-1;
String choosenLetters = "";

//Variables for my silly implementation. You can delete these:
char currentLetter = 'a';

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases
  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(1000, 1000); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 36)); //set the font to arial 36
  noStroke(); //my code doesn't use any strokes.
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  textSize(32);
  background(0); //clear background

  fill(100);
  rect(200, 200, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"

  if (finishTime!=0)
  {
    fill(100);
    rect(200, 200, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"
    fill(255);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(255);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
    state=0;
  }

  if (startTime!=0 & state==0)
  {
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    text("Entered:  " + currentTyped, 70, 140); //draw what the user has entered thus far 
    fill(255, 0, 0);
    rect(800, 00, 200, 200); //drag next button
    fill(255);
    text("NEXT > ", 850, 100); //draw next label

    textAlign(CENTER, CENTER);
    strokeWeight(2);
    stroke(0);
    fill(255);
    rect(200, 200, sizeOfInputArea/3, sizeOfInputArea/4);
    rect(200+sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/4);
    rect(200+2*sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/4);
    rect(200, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    rect(200+sizeOfInputArea/3, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    rect(200+2*sizeOfInputArea/3, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    rect(200, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    rect(200+sizeOfInputArea/3, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    rect(200+2*sizeOfInputArea/3, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    rect(200, 200+3*sizeOfInputArea/4, sizeOfInputArea, sizeOfInputArea/4);
    
    fill(100);
    textSize(32);
    text("Del", 200, 200, sizeOfInputArea/3, sizeOfInputArea/4);
    textSize(42);
    text("abc", 200+sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/4);
    text("def", 200+2*sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/4);
    
    text("ghi", 200, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    text("jkl", 200+sizeOfInputArea/3, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    text("mno", 200+2*sizeOfInputArea/3, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    
    text("pqrs", 200, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    text("tuv", 200+sizeOfInputArea/3, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    text("wxyz", 200+2*sizeOfInputArea/3, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4);
    
    text("Space", 200, 200+3*sizeOfInputArea/4, sizeOfInputArea, sizeOfInputArea/4);
  }
  else if (startTime!=0 & state!=0)
    printChoosenLetters();
}

boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

void printChoosenLetters()
{
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    text("Entered:  " + currentTyped, 70, 140); //draw what the user has entered thus far 
    fill(255, 0, 0);
    rect(800, 00, 200, 200); //drag next button
    fill(255);
    text("NEXT > ", 850, 100); //draw next label
    
    textSize(96);
    textAlign(CENTER, CENTER);
    strokeWeight(2);
    stroke(0);
    for (int i=0;i<choosenLetters.length(); ++i)
    {
      fill(255);
      rect(200+i*sizeOfInputArea/choosenLetters.length(), 200, sizeOfInputArea/choosenLetters.length(), 3*sizeOfInputArea/4);
    
      fill(100);
      text(choosenLetters.substring(i, i+1), 200+i*sizeOfInputArea/choosenLetters.length(), 200, sizeOfInputArea/choosenLetters.length(), 3*sizeOfInputArea/4);
    }
    textSize(56);
    fill(255);
    rect(200, 200+3*sizeOfInputArea/4, sizeOfInputArea, sizeOfInputArea/4);
    fill(100);
    text("Cancel", 200, 200+3*sizeOfInputArea/4, sizeOfInputArea, sizeOfInputArea/4);
}

void mousePressed()
{

    if (didMouseClick(200, 200, sizeOfInputArea/3, sizeOfInputArea/4) & state==0)
    {
      if(currentTyped.length()>0)
      {
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
      }
    }
    else if (didMouseClick(200+sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/4) & state==0)
    {
      state = 1;
      choosenLetters = "abc";
    }    
    else if (didMouseClick(200+2*sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/4) & state==0)
    {
      state = 2;
      choosenLetters = "def";
    }    
    else if (didMouseClick(200, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4) & state==0)
    {
      state = 3;
      choosenLetters = "ghi";
    }    
    else if (didMouseClick(200+sizeOfInputArea/3, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4) & state==0)
    {
      state = 4;
      choosenLetters = "jkl";
    }    
    else if (didMouseClick(200+2*sizeOfInputArea/3, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4) & state==0)
    {
      state = 5;
      choosenLetters = "mno";
    }    
    else if (didMouseClick(200, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4) & state==0)
    {
      state = 6;
      choosenLetters = "pqrs";
    }    
    else if (didMouseClick(200+sizeOfInputArea/3, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4) & state==0)
    {
      state = 7;
      choosenLetters = "tuv";
    }
    else if (didMouseClick(200+2*sizeOfInputArea/3, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4) & state==0)
    {
      state = 8;
      choosenLetters = "wxyz";
    }    
    else if (didMouseClick(200, 200+3*sizeOfInputArea/4, sizeOfInputArea, sizeOfInputArea/4) & state==0)
      currentTyped+=" ";
    else if (didMouseClick(200, 200+3*sizeOfInputArea/4, sizeOfInputArea, sizeOfInputArea/4) & state!=0)
    {
      state = 0;
      choosenLetters = "";
    }
    else if (state!=0 & choosenLetters.length() == 3)
    {
      if(didMouseClick(200, 200, sizeOfInputArea/3, 3*sizeOfInputArea/4))
      {
        state = 0;
        currentTyped+=choosenLetters.substring(0, 1);
      }
      else if(didMouseClick(200+sizeOfInputArea/3, 200, sizeOfInputArea/3, 3*sizeOfInputArea/4))
      {
        state = 0;
        currentTyped+=choosenLetters.substring(1, 2);
      }
      else if(didMouseClick(200+2*sizeOfInputArea/3, 200, sizeOfInputArea/3, 3*sizeOfInputArea/4))
      {
        state = 0;
        currentTyped+=choosenLetters.substring(2, 3);
      }
    }
    else if (state!=0 & choosenLetters.length() == 4)
    {
      if(didMouseClick(200, 200, sizeOfInputArea/4, 3*sizeOfInputArea/4))
      {
        state = 0;
        currentTyped+=choosenLetters.substring(0, 1);
      }
      else if(didMouseClick(200+sizeOfInputArea/4, 200, sizeOfInputArea/4, 3*sizeOfInputArea/4))
      {
        state = 0;
        currentTyped+=choosenLetters.substring(1, 2);
      }
      else if(didMouseClick(200+2*sizeOfInputArea/4, 200, sizeOfInputArea/4, 3*sizeOfInputArea/4))
      {
        state = 0;
        currentTyped+=choosenLetters.substring(2, 3);
      }
      else if(didMouseClick(200+3*sizeOfInputArea/4, 200, sizeOfInputArea/4, 3*sizeOfInputArea/4))
      {
        state = 0;
        currentTyped+=choosenLetters.substring(3, 4);
      }
    }        
  //You are allowed to have a next button outside the 2" area
  if (didMouseClick(800, 00, 200, 200)) //check if click is in next button
  {
    nextTrial(); //if so, advance to next trial
    state=0;
  }
}


void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

    if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.length();
    lettersEnteredTotal+=currentTyped.length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output
    System.out.println("WPM: " + (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f)); //output
    System.out.println("==================");
    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  }
  else
  {
    currTrialNum++; //increment trial number
  }

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
}

//=========SHOULD NOT NEED TO TOUCH THIS AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2)  
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}
