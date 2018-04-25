From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Regression 4.17-rc1: SSD doesn properly resume causing system
 hang (NULL pointer dereference)
Date: Wed, 25 Apr 2018 12:26:25 +0000
Message-ID: <df8a54d242adb7c26ceef57d6a0e7a51232f911c.camel@wdc.com>
References: <59ca6556-11a6-4f77-76e7-d51c7175eb32@molgen.mpg.de>
         <67ffdf0050a04bf3615c3d8a3a90b0c9c2aeb1ad.camel@wdc.com>
         <2cc5f0fb-4caa-9c28-7daa-68993d5cb41a@molgen.mpg.de>
         <14ff1ed06e36a372680872c227b5abe389c753da.camel@wdc.com>
         <a3a7f906-3681-15cc-67af-b96e4ac71b0e@molgen.mpg.de>
         <134955874b401e6764077393c75ab2d4549b940a.camel@wdc.com>
         <6a2162a7-5f48-c107-0b1c-5258089522c5@molgen.mpg.de>
         <19e19bc6b2fef11faf428fe75447b06e56af9ffd.camel@wdc.com>
         <d5e8823e-27bd-dabe-174f-b111a48b440a@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d5e8823e-27bd-dabe-174f-b111a48b440a@molgen.mpg.de>
Content-Language: en-US
Content-ID: <FE91950BECF7584C87337527A29C55C6@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "pmenzel+linux-block@molgen.mpg.de" <pmenzel+linux-block@molgen.mpg.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "regressions@leemhuis.info" <regressions@leemhuis.info>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDE4LTA0LTI1IGF0IDA3OjM3ICswMjAwLCBQYXVsIE1lbnplbCB3cm90ZToNCj4g
QW0gMjQuMDQuMjAxOCB1bSAyMzoxNyBzY2hyaWViIEJhcnQgVmFuIEFzc2NoZToNCj4gPiBPbiBU
dWUsIDIwMTgtMDQtMjQgYXQgMjM6MDQgKzAyMDAsIFBhdWwgTWVuemVsIHdyb3RlOg0KPiA+ID4g
SSBhcHBsaWVkIHlvdXIgY2hhbmdlLCBhbmQgcmVidWlsdCB0aGUgTGludXgga2VybmVsLiBVbmZv
cnR1bmF0ZWx5LCBpdA0KPiA+ID4gbG9va3MgbGlrZSwgaXQgZGlkbuKAmXQgbWFrZSBhIGRpZmZl
cmVuY2UuDQo+ID4gDQo+ID4gSW4gdGhhdCBjYXNlIEkgZG9uJ3Qga25vdyB3aGF0IGlzIGNhdXNp
bmcgdGhlIGZhaWx1cmUuIENhbiB5b3UgcnVuIGEgYmlzZWN0DQo+ID4gdG8gZGV0ZXJtaW5lIHdo
aWNoIGNvbW1pdCBpbnRyb2R1Y2VkIHRoaXMgcmVncmVzc2lvbj8NCj4gDQo+IFdpdGggYHNjc2lf
bW9kLnVzZV9ibGtfbXE9bmAgdGhlIHN5c3RlbSByZXN1bWVzIGZpbmUsIHNvIGZvciB0byBtZSAN
Cj4gdW5rbm93biByZWFzb25zLCB0aGF0IEtjb25maWcgb3B0aW9uIGdldCBzZWxlY3RlZCBpbiBt
eSBMaW51eCBrZXJuZWwgDQo+IGNvbmZpZ3VyYXRpb24uIEkgcmVtZW1iZXIgaGF2aW5nIHNpbWls
YXIgaXNzdWVzIHdoZW4gdGhpcyB3YXMgZW5hYmxlZCBieSANCj4gZGVmYXVsdCBpbiBMaW51eCA0
LjEzLXJjPywgc28gaXQgd2FzIGp1c3QgYSBjb25maWd1cmF0aW9uIHByb2JsZW0gYW5kIA0KPiBu
b3QgYSByZWdyZXNzaW9uLiBVbmZvcnR1bmF0ZWx5LCB0aGUgTGludXggY29uZmlndXJhdGlvbiBm
aWxlcyBhcmUgbm90IA0KPiB1bmRlciB2ZXJzaW9uIGNvbnRyb2wsIHNvIEkgY2Fubm90IGNoZWNr
LCBidXQgaXQgaXMgcHJvYmFibHkgbXkgZmF1bHQuDQo+IA0KPiBTb3JyeSBmb3IgdGhlIG5vaXNl
LCBhbmQgcGxlYXNlIHRlbGwgbWUsIHdoYXQgSSBjYW4gZG8gdG8gZ2V0IHRoZSBvcHRpb24gDQo+
IHdvcmtpbmcgb24gdGhpcyBvbGQgZGV2aWNlLg0KDQpIZWxsbyBQYXVsLA0KDQpEaWQgdGhlIHNh
bWUgc3lzdGVtIGJvb3QgZmluZSB3aXRoIGEgcHJldmlvdXMga2VybmVsIHdpdGggc2NzaS1tcSBl
bmFibGVkPw0KQW55d2F5LCB3ZSB3b3VsZCBsaWtlIHRvIGtub3cgd2hhdCBpcyB0aGUgcm9vdCBj
YXVzZSBzdWNoIHRoYXQgdGhpcyBOVUxMDQpwb2ludGVyIGRlcmVmZXJlbmNlIGNhbiBiZSBmaXhl
ZC4gVGhlcmUgYXJlIG5hbWVseSBwbGFucyB0byByZW1vdmUgdGhlDQpsZWdhY3kgYmxvY2sgbGF5
ZXIgaW4gdGhlIG5vdCB0b28gZGlzdGFudCBmdXR1cmUuDQoNClRoYW5rcywNCg0KQmFydC4=
