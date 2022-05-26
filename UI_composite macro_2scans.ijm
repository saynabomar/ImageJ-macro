//works and saves names properly for 2 scans 

//1. creating input and output directories :) //
inputDir= getDirectory("Choose a input folder");
if (inputDir=="")
    exit("No input directory available");
outputDir = inputDir+"Output_Composites"+File.separator;
File.makeDirectory(outputDir);
if (!File.exists(outputDir))
    exit("Unable to create directory");
print("");
print(outputDir);
File.setDefaultDir(inputDir);
print("Your input folder is:" + inputDir + "\nYour output folder is:" + outputDir);



//user input for naming of 2 slides being scanned in at the same time!

//creating dialogue box for user inputs 
yesno = newArray("Yes", "No");
Colours = newArray("Grays", "Red", "Green", "Blue", "Cyan", "Magenta", "Yellow");

Dialog.create("Scan options:");
	Dialog.addMessage("Enter settings:");
	Dialog.addNumber("How many slides have been scanned?", 2);
	Dialog.addRadioButtonGroup("Is the scan a 5x5?", yesno, 1, 2, yesno[0]);
Dialog.show();

no_slides = Dialog.getNumber();
five_by_five = Dialog.getRadioButton();

if (five_by_five == yesno[1]) {
	waitForUser("You need to adjust composite image naming system before using this macro.");
	exit();
}
if (no_slides > 2) {
	waitForUser("You need to use another macro for more slides or adjust this macro (otherwise naming system will not work).");
	exit();
}

Dialog.create("Slide 1 - Options for composite images");
	Dialog.addMessage("Enter settings:");
	Dialog.addString("Tissue number:", "0");
	Dialog.addString("Condition:", "control");
	Dialog.addString("Slide number:", "0");
	Dialog.addString("Channel dye 1:", "DAPI");
	Dialog.addString("Channel dye 2:", "E-cad");
	Dialog.addString("Channel dye 3:", "Vim");
	Dialog.addString("Channel dye 4:", "Krt19");
	Dialog.addMessage("Assign your channel colours:");
	Dialog.addChoice("Channel 1:", Colours, Colours[0]);
	Dialog.addChoice("Channel 2:", Colours, Colours[2]);
	Dialog.addChoice("Channel 3:", Colours, Colours[1]);
	Dialog.addChoice("Channel 4:", Colours, Colours[3]);
Dialog.show();

tissue_no_i1= Dialog.getString();
condition_i1= Dialog.getString();
slide_no_i1= Dialog.getString();
dye1_i1=Dialog.getString();
dye2_i1=Dialog.getString();
dye3_i1=Dialog.getString();
dye4_i1=Dialog.getString();
channel_colour1_i1=Dialog.getChoice();
channel_colour2_i1=Dialog.getChoice();
channel_colour3_i1=Dialog.getChoice();
channel_colour4_i1=Dialog.getChoice();



print("Your images for slide 1 will be labelled as follows: Tissue " + tissue_no_i1 + "_" + slide_no_i1 + " "+ condition_i1 + " "+ dye1_i1 + " "+ dye2_i1 + " "+ dye3_i1 + " "+ dye4_i1 + " Image #: ...");
print(dye1_i1+ " will have a channel colour of: " +channel_colour1_i1);
print(dye2_i1+ " will have a channel colour of: " +channel_colour2_i1);
print(dye3_i1+ " will have a channel colour of: " +channel_colour3_i1);
print(dye4_i1+ " will have a channel colour of: " +channel_colour4_i1);
waitForUser("Check this is correct before continuing. If not, abort macro.");

if (no_slides == 2) {

Dialog.create("Slide 2 - Options for composite images");
	Dialog.addMessage("Enter settings:");
	Dialog.addString("Tissue number:", "0");
	Dialog.addString("Condition:", "control");
	Dialog.addString("Slide number:", "0");
	Dialog.addString("Channel dye 1:", "DAPI");
	Dialog.addString("Channel dye 2:", "E-cad");
	Dialog.addString("Channel dye 3:", "Vim");
	Dialog.addString("Channel dye 4:", "Krt19");
	Dialog.addMessage("Assign your channel colours:");
	Dialog.addChoice("Channel 1:", Colours, Colours[0]);
	Dialog.addChoice("Channel 2:", Colours, Colours[2]);
	Dialog.addChoice("Channel 3:", Colours, Colours[1]);
	Dialog.addChoice("Channel 4:", Colours, Colours[3]);
Dialog.show();

tissue_no_i2= Dialog.getString();
condition_i2= Dialog.getString();
slide_no_i2= Dialog.getString();
dye1_i2=Dialog.getString();
dye2_i2=Dialog.getString();
dye3_i2=Dialog.getString();
dye4_i2=Dialog.getString();
channel_colour1_i2=Dialog.getChoice();
channel_colour2_i2=Dialog.getChoice();
channel_colour3_i2=Dialog.getChoice();
channel_colour4_i2=Dialog.getChoice();



print("Your images for slide 2 will be labelled as follows: Tissue " + tissue_no_i2 + "_" + slide_no_i2 + " "+ condition_i2 + " "+ dye1_i2 + " "+ dye2_i2 + " "+ dye3_i2 + " "+ dye4_i2 + " Image #: ...");
print(dye1_i2+ " will have a channel colour of: " +channel_colour1_i2);
print(dye2_i2+ " will have a channel colour of: " +channel_colour2_i2);
print(dye3_i2+ " will have a channel colour of: " +channel_colour3_i2);
print(dye4_i2+ " will have a channel colour of: " +channel_colour4_i2);
waitForUser("Check this is correct before continuing. If not, abort macro.");

}



//open("C:/Users/sayna/OneDrive/Desktop/ScanR/Tissue240-241 glas7 ECad Vim Krt19 more intense krt19_001/experiment_descriptor.xml");
// Uses the Bio-Formats macro extensions to open a file as a hyperstack.


requires("1.41c");

path = File.openDialog("Select a File");
name = File.getName(path);

run("Bio-Formats Macro Extensions");
Ext.setId(path);
Ext.getSeriesCount(seriesCount);

if (seriesCount == 25 || seriesCount == 50 || seriesCount == 75 || seriesCount == 100) {

for (s=0; s < 50; s++) {
	Ext.setSeries(s);
	Ext.getSeries(current);
	Ext.getSizeX(sizeX);
	Ext.getSizeY(sizeY);
	Ext.getSizeC(sizeC);
	Ext.getSizeZ(sizeZ);
	Ext.getSizeT(sizeT);
	Ext.getImageCount(n);
 	print(name + s + ":", sizeX, sizeY, sizeC, sizeZ, sizeT);
	setBatchMode(true);
for (i=0; i<n; i++) {
  showProgress(i, n);
  Ext.openImage("plane "+i, i);
  if (i==0)
    stack = getImageID;
  else {
    run("Copy");
    close;
    selectImage(stack);
    run("Add Slice");
    run("Paste");
  }
}
rename(name);
if (nSlices>1) {
  Stack.setDimensions(sizeC, sizeZ, sizeT);
  if (sizeC>1) {
    if (sizeC==4&&sizeC==nSlices)
      mode = "Composite";
    else
      mode = "Color";
    run("Make Composite", "display="+mode);

  }
  setOption("OpenAsHyperStack", true);
}

	
	//run("Channels Tool...");
	Stack.setSlice(2);
	run(channel_colour1_i1);
	Stack.setChannel(2);
	run(channel_colour2_i1);
	Stack.setChannel(3);
	run(channel_colour3_i1);
	Stack.setChannel(4);
	run(channel_colour4_i1);
	Stack.setChannel(1);
	

//setting brightness + contrast of all slices
	//run("Brightness/Contrast...");
	run("Enhance Contrast", "saturated=0.35");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.35");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.35");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.35");
	setMinAndMax(146, 1154);
	image_number= s+1;
	Stack.setDisplayMode("composite");
	saveAs("tiff", outputDir + "Tissue " + tissue_no_i1 + "_" + slide_no_i1 + " "+ condition_i1 + " "+ dye1_i1 + " "+ dye2_i1 + " "+ dye3_i1 + " "+ dye4_i1 + "Image " + image_number);
	//saveAs("tiff", outputDir + "Tissue " + tissue_no_i2 + "_" + slide_no_i2 + " "+ condition_i2 + " "+ dye1_i2 + " "+ dye2_i2 + " "+ dye3_i2 + " "+ dye4_i2 + "Image " + image_number);
	run("Close");
	}
}

if (seriesCount == 75 || seriesCount == 100) {
	
for (s=50; s < seriesCount; s++) {
	Ext.setSeries(s);
	Ext.getSeries(current);
	Ext.getSizeX(sizeX);
	Ext.getSizeY(sizeY);
	Ext.getSizeC(sizeC);
	Ext.getSizeZ(sizeZ);
	Ext.getSizeT(sizeT);
	Ext.getImageCount(n);
 	print(name + s + ":", sizeX, sizeY, sizeC, sizeZ, sizeT);
	setBatchMode(true);
for (i=0; i<n; i++) {
  showProgress(i, n);
  Ext.openImage("plane "+i, i);
  if (i==0)
    stack = getImageID;
  else {
    run("Copy");
    close;
    selectImage(stack);
    run("Add Slice");
    run("Paste");
  }
}
rename(name);
if (nSlices>1) {
  Stack.setDimensions(sizeC, sizeZ, sizeT);
  if (sizeC>1) {
    if (sizeC==4&&sizeC==nSlices)
      mode = "Composite";
    else
      mode = "Color";
    run("Make Composite", "display="+mode);

  }
  setOption("OpenAsHyperStack", true);
}

	
	//run("Channels Tool...");
	Stack.setSlice(2);
	run(channel_colour1_i2);
	Stack.setChannel(2);
	run(channel_colour2_i2);
	Stack.setChannel(3);
	run(channel_colour3_i2);
	Stack.setChannel(4);
	run(channel_colour4_i2);
	Stack.setChannel(1);
	

//setting brightness + contrast of all slices
	//run("Brightness/Contrast...");
	run("Enhance Contrast", "saturated=0.35");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.35");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.35");
	run("Next Slice [>]");
	run("Enhance Contrast", "saturated=0.35");
	setMinAndMax(146, 1154);
	image_number= s+1;
	Stack.setDisplayMode("composite");
	saveAs("tiff", outputDir + "Tissue " + tissue_no_i2 + "_" + slide_no_i2 + " "+ condition_i2 + " "+ dye1_i2 + " "+ dye2_i2 + " "+ dye3_i2 + " "+ dye4_i2 + "Image " + image_number);
	run("Close");
	}
}

print("All done.");



