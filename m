From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH resend 3/6] cdrom: wait for tray to close
Date: Mon, 29 Jan 2018 17:05:47 +0000
Message-ID: <1517245546.2687.17.camel@wdc.com>
References: <cover.1516985620.git.msuchanek@suse.de>
         <03915a2e64f50ec04ea6d8e6f80e36ecf16e4f0f.1516985620.git.msuchanek@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <03915a2e64f50ec04ea6d8e6f80e36ecf16e4f0f.1516985620.git.msuchanek@suse.de>
Content-Language: en-US
Content-ID: <9C94C4CE03D87F47BCAE9BFCC77DA81C@namprd04.prod.outlook.com>
Sender: linux-ide-owner@vger.kernel.org
To: "corbet@lwn.net" <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "msuchanek@suse.de" <msuchanek@suse.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>, "pombredanne@nexb.com" <pombredanne@nexb.com>, "bp@alien8.de" <bp@alien8.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>, davem@davemlof
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTAxLTI2IGF0IDE3OjU4ICswMTAwLCBNaWNoYWwgU3VjaGFuZWsgd3JvdGU6
DQo+ICtzdGF0aWMgaW50IGNkcm9tX3RyYXlfY2xvc2Uoc3RydWN0IGNkcm9tX2RldmljZV9pbmZv
ICpjZGkpDQo+ICt7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCXJldCA9IGNkaS0+b3BzLT50cmF5
X21vdmUoY2RpLCAwKTsNCj4gKwlpZiAocmV0IHx8ICFjZGktPm9wcy0+ZHJpdmVfc3RhdHVzKQ0K
PiArCQlyZXR1cm4gcmV0Ow0KPiArDQo+ICsJcmV0dXJuIHBvbGxfZXZlbnRfaW50ZXJydXB0aWJs
ZShDRFNfVFJBWV9PUEVOICE9DQo+ICsJCQljZGktPm9wcy0+ZHJpdmVfc3RhdHVzKGNkaSwgQ0RT
TF9DVVJSRU5UKSwgNTAwKTsNCj4gK30NCj4gKw0KPiAgc3RhdGljDQo+ICBpbnQgb3Blbl9mb3Jf
Y29tbW9uKHN0cnVjdCBjZHJvbV9kZXZpY2VfaW5mbyAqY2RpLCB0cmFja3R5cGUgKnRyYWNrcykN
Cj4gIHsNCj4gQEAgLTEwNDgsNyArMTA2Miw5IEBAIGludCBvcGVuX2Zvcl9jb21tb24oc3RydWN0
IGNkcm9tX2RldmljZV9pbmZvICpjZGksIHRyYWNrdHlwZSAqdHJhY2tzKQ0KPiAgCQkJaWYgKENE
Uk9NX0NBTihDRENfQ0xPU0VfVFJBWSkgJiYNCj4gIAkJCSAgICBjZGktPm9wdGlvbnMgJiBDRE9f
QVVUT19DTE9TRSkgew0KPiAgCQkJCWNkX2RiZyhDRF9PUEVOLCAidHJ5aW5nIHRvIGNsb3NlIHRo
ZSB0cmF5XG4iKTsNCj4gLQkJCQlyZXQgPSBjZG8tPnRyYXlfbW92ZShjZGksIDApOw0KPiArCQkJ
CXJldCA9IGNkcm9tX3RyYXlfY2xvc2UoY2RpKTsNCj4gKwkJCQlpZiAocmV0ID09IC1FUkVTVEFS
VFNZUykNCj4gKwkJCQkJcmV0dXJuIHJldDsNCj4gIAkJCQlpZiAocmV0KSB7DQo+ICAJCQkJCWNk
X2RiZyhDRF9PUEVOLCAiYnVtbWVyLiB0cmllZCB0byBjbG9zZSB0aGUgdHJheSBidXQgZmFpbGVk
LlxuIik7DQo+ICAJCQkJCS8qIElnbm9yZSB0aGUgZXJyb3IgZnJvbSB0aGUgbG93DQo+IEBAIC0y
MzEyLDcgKzIzMjgsOCBAQCBzdGF0aWMgaW50IGNkcm9tX2lvY3RsX2Nsb3NldHJheShzdHJ1Y3Qg
Y2Ryb21fZGV2aWNlX2luZm8gKmNkaSkNCj4gIA0KPiAgCWlmICghQ0RST01fQ0FOKENEQ19DTE9T
RV9UUkFZKSkNCj4gIAkJcmV0dXJuIC1FTk9TWVM7DQo+IC0JcmV0dXJuIGNkaS0+b3BzLT50cmF5
X21vdmUoY2RpLCAwKTsNCj4gKw0KPiArCXJldHVybiBjZHJvbV90cmF5X2Nsb3NlKGNkaSk7DQo+
ICB9DQoNClNvIHRoaXMgcGF0Y2ggY2hhbmdlcyBjb2RlIHRoYXQgZG9lcyBub3Qgd2FpdCBpbnRv
IGNvZGUgdGhhdCBwb3RlbnRpYWxseSB3YWl0cw0KZm9yZXZlcj8gU29ycnkgYnV0IEkgZG9uJ3Qg
dGhpbmsgdGhhdCdzIGlkZWFsLiBQbGVhc2UgbWFrZSBzdXJlIHRoYXQgYWZ0ZXIgYQ0KY2VydGFp
biB0aW1lIChhIGZldyBzZWNvbmRzPykgdGhlIGxvb3AgZmluaXNoZXMuDQoNClRoYW5rcywNCg0K
QmFydC4=
