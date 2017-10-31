From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 18:12:27 +0000
Message-ID: <1509473546.12927.5.camel@wdc.com>
References: <20171025100737.GA145097@beast> <yq1d153b9lt.fsf@oracle.com>
         <16733DFA-7339-4F77-9125-E8845C4FCD6F@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <16733DFA-7339-4F77-9125-E8845C4FCD6F@cavium.com>
Content-Language: en-US
Content-ID: <57AB9274636DE44589B7D2978B20A14C@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Himanshu.Madhani@cavium.com" <Himanshu.Madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "qla2xxx-upstream@cavium.com" <qla2xxx-upstream@cavium.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTEwLTMxIGF0IDE4OjAzICswMDAwLCBNYWRoYW5pLCBIaW1hbnNodSB3cm90
ZToNCj4gT24gT2N0IDMxLCAyMDE3LCBhdCA4OjQ5IEFNLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1h
cnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPiB3cm90ZToNCj4gPiA+IEluIHByZXBhcmF0aW9uIGZv
ciB1bmNvbmRpdGlvbmFsbHkgcGFzc2luZyB0aGUgc3RydWN0IHRpbWVyX2xpc3QNCj4gPiA+IHBv
aW50ZXIgdG8gYWxsIHRpbWVyIGNhbGxiYWNrcywgc3dpdGNoIHRvIHVzaW5nIHRoZSBuZXcgdGlt
ZXJfc2V0dXAoKQ0KPiA+ID4gYW5kIGZyb21fdGltZXIoKSB0byBwYXNzIHRoZSB0aW1lciBwb2lu
dGVyIGV4cGxpY2l0bHkuDQo+ID4gDQo+ID4gQ2F2aXVtIGZvbGtzOiBQbGVhc2UgdmVyaWZ5IQ0K
PiANCj4gSeKAmXZlIGNoZWNrZWQgb24gbXkgc2V0dXAgYW5kIGkgYW0gc2VlaW5nIHJlZ3Jlc3Np
b24gd2l0aCB0aGlzIHBhdGNoIGFwcGxpZWQuIA0KPiANCj4gRHJpdmVyIGxvYWQgbG9ja3MgdXAg
dGhlIHN5c3RlbSB3aXRoIHRoaXMgcGF0Y2ggYXBwbGllZC4gDQo+IA0KPiBOQUNLIA0KDQpUaGF0
IGZlZWRiYWNrIGlzIG5vdCB2ZXJ5IGhlbHBmdWwgLi4uDQoNCkFueXdheSwgd2hhdCBrZXJuZWwg
c291cmNlIHRyZWUgZGlkIHlvdSB1c2UgaW4geW91ciB0ZXN0aW5nPyBJIG1heSBiZSBhYmxlIHRv
DQpmcmVlIHVwIHNvbWUgdGltZSB0byBsb29rIGludG8gdGhpcyBteXNlbGYuDQoNCkJhcnQu
