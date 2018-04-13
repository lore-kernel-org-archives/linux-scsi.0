From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi_transport_srp: Fix shost to rport translation
Date: Fri, 13 Apr 2018 12:40:45 +0000
Message-ID: <c01a20b2b9b8f15a6def5e0a8af90977dbf7ed86.camel@wdc.com>
References: <20180412193207.13253-1-bart.vanassche@wdc.com>
         <20180413081107.6b034df9@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180413081107.6b034df9@pentland.suse.de>
Content-Language: en-US
Content-ID: <244BEF7C8F1FB9489C4173FBEA8C70E0@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "jgg@mellanox.com" <jgg@mellanox.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTA0LTEzIGF0IDA4OjExICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IE9uIFRodSwgMTIgQXByIDIwMTggMTM6MzI6MDcgLTA2MDANCj4gIkJhcnQgVmFuIEFzc2No
ZSIgPGJhcnQudmFuYXNzY2hlQHdkYy5jb20+IHdyb3RlOg0KPiA+ICtzdGF0aWMgaW50IGZpbmRf
Y2hpbGRfcnBvcnQoc3RydWN0IGRldmljZSAqZGV2LCB2b2lkICpkYXRhKQ0KPiA+ICt7DQo+ID4g
KwlzdHJ1Y3QgZGV2aWNlICoqY2hpbGQgPSBkYXRhOw0KPiA+ICsNCj4gPiArCWlmIChzY3NpX2lz
X3NycF9ycG9ydChkZXYpKSB7DQo+ID4gKwkJV0FSTl9PTl9PTkNFKCpjaGlsZCk7DQo+ID4gKwkJ
KmNoaWxkID0gZGV2Ow0KPiA+ICsJfQ0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+
IA0KPiBXaHkgbm90IGhhdmUgJ3N0YXRpYyBzdHJ1Y3QgZGV2aWNlICpmaW5kX2NoaWxkX3Jwb3J0
KCkgPw0KDQpIZWxsbyBIYW5uZXMsDQoNClRoZSBmdW5jdGlvbiBkZXZpY2VfZm9yX2VhY2hfY2hp
bGQoKSBleHBlY3RzIHRvIGJlIHBhc3NlZCBhIGludCAoKikoc3RydWN0IGRldmljZSAqLA0Kdm9p
ZCAqKSBwb2ludGVyLiBJcyB0aGVyZSBwZXJoYXBzIGFub3RoZXIgZnVuY3Rpb24gZm9yIGl0ZXJh
dGluZyBvdmVyIGRldmljZSBjaGlsZHJlbg0KdGhhdCBhY2NlcHRzIGEgZnVuY3Rpb24gdGhhdCBy
ZXR1cm5zIGEgcG9pbnRlcj8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg0KDQoNCg0K
