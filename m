From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Date: Wed, 22 Jan 2014 09:17:18 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D4637FB@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com>
 <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
 <52DAE2BF.7020208@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45FF6C@AcuExch.aculab.com>
 <20140120181442.GA5545@xanatos>
 <063D6719AE5E284EB5DD2968C1650D6D4609BF@AcuExch.aculab.com>
 <52DEEF88.8090709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <52DEEF88.8090709@gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: 'walt' <w41ter@gmail.com>, 'Sarah Sharp' <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogd2FsdA0KPiBPbiAwMS8yMS8yMDE0IDAxOjUxIEFNLCBEYXZpZCBMYWlnaHQgd3JvdGU6
DQo+ID4gRnJvbTogU2FyYWggU2hhcnANCj4gPj4gT24gTW9uLCBKYW4gMjAsIDIwMTQgYXQgMTE6
MjE6MTRBTSArMDAwMCwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+IC4uLg0KPiA+Pj4gQSBndWVz
cy4uLg0KPiA+Pj4NCj4gPj4+IEluIHF1ZXVlX2J1bGtfc2dfdHgoKSB0cnkgY2FsbGluZyB4aGNp
X3YxXzBfdGRfcmVtYWluZGVyKCkgaW5zdGVhZA0KPiA+Pj4gb2YgeGhjaV90ZF9yZW1haW5kZXIo
KS4NCj4gPj4NCj4gRGF2aWQsIEkgdHJpZWQgdGhlIG9uZS1saW5lciBiZWxvdywgd2hpY2ggY2hh
bmdlZCBub3RoaW5nIEFGQUlDUywgYnV0DQo+IHRoZW4gSSdtIG5vdCBzdXJlIGl0J3MgdGhlIGNo
YW5nZSB5b3UgaW50ZW5kZWQ6DQouLi4NCj4gIAkJLyogU2V0IHRoZSBUUkIgbGVuZ3RoLCBURCBz
aXplLCBhbmQgaW50ZXJydXB0ZXIgZmllbGRzLiAqLw0KPiAtCQlpZiAoeGhjaS0+aGNpX3ZlcnNp
b24gPCAweDEwMCkgew0KPiArCQlpZiAoeGhjaS0+aGNpX3ZlcnNpb24gPiAweDEwMCkgew0KPiAg
CQkJcmVtYWluZGVyID0geGhjaV90ZF9yZW1haW5kZXIoDQo+ICAJCQkJCXVyYi0+dHJhbnNmZXJf
YnVmZmVyX2xlbmd0aCAtDQo+ICAJCQkJCXJ1bm5pbmdfdG90YWwpOw0KDQpTbyBteSB3aWxkIGd1
ZXNzIHdhc24ndCByaWdodC4NCkNhbid0IHdpbiB0aGVtIGFsbC4NCg0KCURhdmlkDQoNCg==
