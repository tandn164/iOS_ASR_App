const functions = require("firebase-functions");
const express = require('express');
const speech = require('@google-cloud/speech');

const projectId = 'prime-artwork-314818'
const keyFilename = '../prime-artwork-314818-a77ba9b902dd.json'
const client = new speech.SpeechClient({
    projectId: 'prime-artwork-314818',
    keyFilename: 'prime-artwork-314818-a77ba9b902dd.json',
});

const app = express();
app.get('/speech', async(req, res, next) => {
    try {
        console.log(client.keyFilename);
        const gcsUri = 'gs://cloud-samples-data/speech/brooklyn_bridge.raw';
        const audio = {
        uri: gcsUri,
        };
        const config = {
        encoding: 'LINEAR16',
        sampleRateHertz: 16000,
        languageCode: 'en-US',
        };
        const request = {
        audio: audio,
        config: config,
        };
        const [response] = await client.recognize(request);
        const transcription = response.results
        .map(result => result.alternatives[0].transcript)
        .join('\n');
        const metaObject = {
            code: 0,
        }
        const transcriptionObject = {
            transcript: transcription
        }
        const responseObject = {
            meta: metaObject,
            data: transcriptionObject
        }
        res.send(responseObject)
        // res.send(`${transcription}`)
    } catch (error) {
    }
})

app.get('/timestamp-cached', (request, response) => {
    response.set('Cache-Control', 'public, max-age=300, s-maxage=600');
    response.send(`${Date.now()}`);
})

exports.app = functions.https.onRequest(app);