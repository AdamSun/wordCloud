# wordCloud
word cloud in flash as3 and Starling.it can create word cloud by the shape of choosing image

usage:
var wordCloud:WordCloudContainer = new WordCloudContainer();
var imageData:Array = [];
for (var i:int = 0; i < (150 * 150); i++) 
{
  imageData[i] = 0;//0 means the alpha of the pixel is 1.0
}
wordCloud.create(["David", "Mary", "Adam", "Jackson", "Curry"], [0x00ff00, 0xff0000, 0x0000ff], imageData, 300, 300, 32, 8);
spr_main.addChild(wordCloud);
var image:Image = new Image(wordCloud.copyToTexure());
spr_main.addChild(image);
