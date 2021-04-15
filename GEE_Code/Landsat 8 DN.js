/**
 * Fichier de test, ne sert a rien rouler mais a faire des tests. LST est le bon fichier
 * 
*/

var clipToCol = function(image){
  return image.clip(geometry);
};

var dataset = ee.ImageCollection('LANDSAT/LC08/C01/T1')
                  .filterDate('2016-01-01', '2016-12-31')
                  .filterBounds(geometry)
                  .filterMetadata('CLOUD_COVER','less_than', 5)
                  .map(clipToCol)
                  //.select('B10')
                  ;
/**var trueColor432 = dataset.select(['B4', 'B3', 'B2']);
var trueColor432Vis = {
  min: 0.0,
  max: 30000.0,
};
*/



/**
Map.addLayer(trueColor432, trueColor432Vis, 'True Color (432)');

*/


var image1 = ee.Image('LANDSAT/LC08/C01/T1/LC08_013027_20160211')
.clip(geometry);


var listOfImages = dataset.toList(dataset.size());

print(listOfImages)

var image_1 = listOfImages.get(0);
print(image_1);
var getCloudScores = function(img){
    //Get the cloud cover
    var value = ee.Image(img).get('CLOUD_COVER');
    return ee.Feature(null, {'score': value})
};


var results = dataset.map(getCloudScores);
print(Chart.feature.byFeature(results));

var value_nuage = ee.Image(image1).get('CLOUD_COVER');
print(value_nuage);

var value_ML_band_10 = ee.Image(image1).get('RADIANCE_MULT_BAND_10')
print(value_ML_band_10)
Export.image.toDrive(
  {
    image : image1,
    region : geometry
    }
    );
    
Export.image.toAsset(
  {
    image : image1,
    description: 'Asset11'
  });
var visParams = {
  bands: ['B10']
};
Map.addLayer(image1, visParams);

