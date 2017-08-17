From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: smp-induced oops/NULL pointer dereference in mpt3sas, from kernel
 >= 4.11
Date: Thu, 17 Aug 2017 16:02:00 +0000
Message-ID: <1502985717.2615.11.camel@wdc.com>
References: <155d5b2c7af4ae0cc6162baf6a52ef5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155d5b2c7af4ae0cc6162baf6a52ef5b@mail.gmail.com>
Content-Language: en-US
Content-ID: <2D8D73D94E07FB46AC2D085188B39288@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE3LTA4LTE3IGF0IDE1OjE4ICswNTMwLCBDaGFpdHJhIEJhc2FwcGEgd3JvdGU6
DQo+IFdlIGFuYWx5emVkIHRoaXMgaXNzdWUgYW5kIGNvdWxkIGZpZ3VyZSBvdXQgaXQgaXMgbm90
IGJlY2F1c2Ugb2YgZHJpdmVyLA0KPiBpdHMgYmVjYXVzZSB0aGUgInNlbnNlIiBmaWVsZCBvZiB0
aGUgJ3N0cnVjdCBzY3NpX3JlcXVlc3QnIGlzIG5vdCBiZWluZw0KPiBwb3B1bGF0ZWQgcHJvcGVy
bHkgZnJvbSB0aGUgdXBwZXIgbGF5ZXIuDQo+IEFuZCB0aGlzICJzZW5zZSIgbWVtYmVyIGlzIGJl
aW5nIHJlZmVyZW5jZWQgaW4gb3VyIGRyaXZlciBjb2RlIGZvciBrZXJuZWwNCj4gdmVyc2lvbnMg
Pj0gNC4xMSBhcyBzaG93biBiZWxvdyBpbiB0aGUgc25pcHBldDoNCj4gV2hlcmVhcyBhcyBmb3Ig
PCA0LjExIGtlcm5lbCB2ZXJzaW9uIHRoaXMgInNlbnNlIiBtZW1iZXIgd2FzIHJlZmVyZW5jZWQN
Cj4gdmlhICdzdHJ1Y3QgcmVxdWVzdCcNCj4gDQo+IA0KPiBzdGF0aWMgaW50DQo+IF90cmFuc3Bv
cnRfc21wX2hhbmRsZXIgKC4uLi4uKSB7DQo+IC4uLi4uDQo+IC4uLi4uDQo+ID4gPiBtZW1jcHko
c2NzaV9yZXEocmVxKS0+c2Vuc2UsIG1waV9yZXBseSwgc2l6ZW9mKCptcGlfcmVwbHkpKTsNCj4g
DQo+IC4uLi4uDQo+IC4uLi4uDQo+IH0NCj4gDQo+IEFuZCBoZW5jZSB0aGUgTlVMTCBwb2ludGVy
IGRlcmVmZXJlbmNlIGNhbGwgdHJhY2UgaXMgc2VlbiBmb3IgdGhlIGFib3ZlDQo+IGNodW5rIG9m
IG1wdDNzYXMuIFRoaXMgbmVlZHMgdG8gYmUgYWRkcmVzc2VkIGZyb20gdXBwZXIgbGF5ZXIsIHNv
IHBsZWFzZQ0KPiBoZWxwIHVzIGluIGdldHRpbmcgdGhpcyByZXNvbHZlZC4NCg0KSGVsbG8gQ2hh
aXRyYSwNCg0KSGF2ZSB5b3Ugbm90aWNlZCB0aGUgZm9sbG93aW5nIGUtbWFpbCB0aHJlYWQ6ICJb
UkZDIFBBVENIIDAvNl0gYnNnOiBmaXgNCnJlZ3Jlc3Npb24gcmVzdWx0aW5nIGluIHBhbmljcyB3
aGVuIHNlbmRpbmcgY29tbWFuZHMgdmlhIEJTRyBhbmQgc29tZQ0Kc2FuaXR5IGNsZWFudXBzIiAo
aHR0cDovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC1zY3NpL21zZzExMTcyNC5odG1sKT8N
Cg0KQmFydC4=
