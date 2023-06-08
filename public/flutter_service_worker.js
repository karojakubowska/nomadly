'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "d2379affd0e71436d92115fdae3f0432",
"index.html": "3943b57c5a1163a1258b8c920446d0ff",
"/": "3943b57c5a1163a1258b8c920446d0ff",
"main.dart.js": "0f7adaeae61876350c7f1617dbe30f60",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "998d7bbd57b22327f306ca0db6dd8ba6",
"assets/AssetManifest.json": "19d59f2f2cfe1723c76ec419467b4ac8",
"assets/NOTICES": "be4484b3e2f613962b4a8daacc415e16",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "57d849d738900cfd590e9adc7e208250",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/easy_localization/i18n/ar-DZ.json": "acc0a8eebb2fcee312764600f7cc41ec",
"assets/packages/easy_localization/i18n/en.json": "5f5fda8715e8bf5116f77f469c5cf493",
"assets/packages/easy_localization/i18n/en-US.json": "5f5fda8715e8bf5116f77f469c5cf493",
"assets/packages/easy_localization/i18n/ar.json": "acc0a8eebb2fcee312764600f7cc41ec",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.smcbin": "de2dfaaa05edba046711b7b3ed2ff35a",
"assets/fonts/MaterialIcons-Regular.otf": "a1f3e9c445ad2c1159e395e9d413e3f6",
"assets/assets/translate/pl-PL.json": "45019d6dd92a04cc2f005662dd348402",
"assets/assets/translate/en-US.json": "ef523b5dae89919ad395ddeedf123dd5",
"assets/assets/images/credit-card%2520(1)%25201.png": "c9f4a3d5fb38abdfd29fc60a3e985a81",
"assets/assets/images/journey.jpg": "fa1338c3b839a3be4cf7905c55771712",
"assets/assets/images/bell-icon-png-16.jpg.png": "8e2fa06db0c170bd60eeaff11abc4fe2",
"assets/assets/images/bell.png": "a1d9bd5790e6ebaf57250422852c200b",
"assets/assets/images/discover.png": "c3a58509fe14ba54b0ca0ff29ee5619d",
"assets/assets/images/sliders.svg": "2eb4314cf7df7b7c369d4c9da06fcf16",
"assets/assets/images/email-2.png": "76e11d07684209c8c25a9b6be0ca846b",
"assets/assets/images/calender.png": "807be0b075e015def2bc6ff00c8fdf21",
"assets/assets/images/house-frame-svgrepo-com.svg": "5b78ead4574ae3b34806823ff56755a4",
"assets/assets/images/check%25201.png": "e8199f3e539bfc8e64b29a4bf4786e40",
"assets/assets/images/credit-card%25201.png": "d21d21416c4cc32d1dc09daf1f7ad4fe",
"assets/assets/images/notification-svgrepo-com.svg": "59acf850f37ba830599492a4add04dc7",
"assets/assets/images/visa.png": "a8b02279da904c1f40e041b20cbaf49c",
"assets/assets/images/home.jpg": "ca798066ab16e6efc967d3756bb60009",
"assets/assets/images/intro.jpg": "b801be42a2bbc5d850237914d713c102",
"assets/assets/images/search-svgrepo-com.svg": "8950c04a2437e071d47f9227f55f9b41",
"assets/assets/images/eiffel-tower-in-paris-with-gorgeous-colors%25201.png": "e04cbf5b052199d0300a274084d75dbe",
"assets/assets/images/beautiful-view-of-a-blue-lake-captured-from-the-inside-of-a-villa%25201.png": "8d6b79a2824c9f6ba486c80811ca4da2",
"assets/assets/images/verve.png": "d9e7f9a5b6987ec61b7c2d0bd7db1271",
"assets/assets/images/intro_photo.png": "84b9a5093b471aa09a99d164d080005d",
"assets/assets/images/card_cvv.png": "bcfdc3cf11036e9c79c95cd02768c6ff",
"assets/assets/images/empty-box.png": "5745feecd7be49293c155eb3dfcd7451",
"assets/assets/images/suitcase-svgrepo-com.svg": "79f95bffe1d7e9eb31ac9b95609ed27e",
"assets/assets/images/jcb.png": "82658437070a16f35238c2f989a00c2a",
"assets/assets/images/location-pin-svgrepo-com.svg": "e00c25ea34fe470eed43cc5277b42a7a",
"assets/assets/images/mail%25201.png": "e77f858406751f794f5edfc424c2bc38",
"assets/assets/images/filter.svg": "70b21887dfbb6c083acf0fc1d9e866db",
"assets/assets/images/dinners_club.png": "24450426cbb1e5b657356b6cca621956",
"assets/assets/images/mastercard.png": "6aecef820a950ef57140f79e07da916a",
"assets/assets/images/a-modern-living-room-style%25202-2.png": "0015c97b2a6b81d3253c6f3977c395ff",
"assets/assets/images/home%25202.png": "1daaaa84c39e432ffb10df0a7eb0bdb5",
"assets/assets/images/american_express.png": "fac1ed63030230003fa52ee8f98aa8dc",
"assets/assets/images/luggage%25201.png": "4b49e495cb6773d85fe20d81e7ad337b",
"assets/assets/icons/travel-2.png": "e9c2a30a6c2f7995e7806f90495aaa53",
"assets/assets/icons/travel-3.png": "bcb51d92a184c077a1ce94ccf6b0ac26",
"assets/assets/icons/travel-7.png": "6ef95e105774c5306d6558a7d543cdfe",
"assets/assets/icons/travel.png": "5c4a0cff47c1745534f19cd59cd29e54",
"assets/assets/icons/travel-6.png": "d3c06ca9b95b7468e4d658621db74fbe",
"assets/assets/icons/travel-4.png": "a47e6ce62146a85c5e830775ef542f19",
"assets/assets/icons/travel-5.png": "d3c06ca9b95b7468e4d658621db74fbe",
"assets/assets/icons/travel-8.png": "945232fe43321b51c96ec41392acdff2",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
