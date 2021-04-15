/*
Author: Sofia Ermida (sofia.ermida@ipma.pt; @ermida_sofia)

This code is free and open. 
By using this code and any data derived with it, 
you agree to cite the following reference 
in any publications derived from them:
Ermida, S.L., Soares, P., Mantas, V., Göttsche, F.-M., Trigo, I.F., 2020. 
    Google Earth Engine open-source code for Land Surface Temperature estimation from the Landsat series.
    Remote Sensing, 12 (9), 1471; https://doi.org/10.3390/rs12091471

Example 1:
  This example shows how to compute Landsat LST from Landsat-8 over Coimbra
  This corresponds to the example images shown in Ermida et al. (2020)
    
*/
// link to the code that computes the Landsat LST
var LandsatLST = require('users/jpgilbert240/test:Modules/Landsat_LST.js')
var batch = require('users/jpgilbert240/test:Modules/batch.js')


// select region of interest, date range, and landsat satellite
//var geometry = ee.Geometry.Rectangle([-8.91, 40.0, -8.3, 40.4]);
var satellite = 'L8';
var date_start = '2020-01-01';
var date_end = '2020-12-31';
var use_ndvi = true;

// get landsat collection with added variables: NDVI, FVC, TPW, EM, LST
//var LandsatColl = LandsatLST.collection(satellite, date_start, date_end, geometry, use_ndvi)
var LandsatColl = LandsatLST.collection(satellite, date_start, date_end, geometry, use_ndvi)
print(LandsatColl);
print(LandsatColl.filterMetadata('CLOUD_COVER','less_than', 5))
// select the first feature
var exImage = LandsatColl.first();

var cmap1 = ['blue', 'cyan', 'green', 'yellow', 'red'];
var cmap2 = ['F2F2F2','EFC2B3','ECB176','E9BD3A','E6E600','63C600','00A600']; 

Map.centerObject(geometry)
//Map.addLayer(exImage.select('TPW'),{min:0.0, max:60.0, palette:cmap1},'TCWV')
//Map.addLayer(exImage.select('TPWpos'),{min:0.0, max:9.0, palette:cmap1},'TCWVpos')
//Map.addLayer(exImage.select('FVC'),{min:0.0, max:1.0, palette:cmap2}, 'FVC')
//Map.addLayer(exImage.select('EM'),{min:0.9, max:1.0, palette:cmap1}, 'Emissivity')
//Map.addLayer(exImage.select('B10'),{min:290, max:320, palette:cmap1}, 'TIR BT')
//Map.addLayer(exImage.select('LST'),{min:290, max:320, palette:cmap1}, 'LST')
//Map.addLayer(exImage.multiply(0.0001),{bands: ['B4', 'B3', 'B2'], min:0, max:0.3}, 'RGB')

// uncomment the code below to export a image band to your drive
/*
Export.image.toDrive({
  image: exImage.select('LST'),
  description: 'LST',
  scale: 30,
  region: geometry,
  fileFormat: 'GeoTIFF',
});
*/

batch.Download.ImageCollection.toDrive(LandsatColl.select('LST').filterMetadata('CLOUD_COVER','less_than', 5), "VQC_2020", {scale:30});
//batch.Download.ImageCollection.toAsset(LandsatColl.select('LST').filterMetadata('CLOUD_COVER','less_than', 5),  {scale:30});