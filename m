From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH 1/1] scsi: ufs: make sure all interrupts are processed
Date: Mon, 5 Feb 2018 12:57:18 +0000
Message-ID: <DM5PR04MB10856D45C7281AC736D328B7FCFE0@DM5PR04MB1085.namprd04.prod.outlook.com>
References: <1517288066-13171-1-git-send-email-asutoshd@codeaurora.org>
 <DM5PR04MB1085C5039CA525D6FB77DBE3FCFB0@DM5PR04MB1085.namprd04.prod.outlook.com>
 <6ca20a27-3c10-bf0e-35e7-542b7ab77356@codeaurora.org>
 <b336fa7b-e79e-95b8-ea21-7b1e2b01677d@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b336fa7b-e79e-95b8-ea21-7b1e2b01677d@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Asutosh Das (asd)" <asutoshd@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

DQoNCj4gPj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+PiBGcm9tOiBsaW51eC1z
Y3NpLW93bmVyQHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LXNjc2ktDQo+ID4+PiBvd25l
ckB2Z2VyLmtlcm5lbC5vcmddIE9uIEJlaGFsZiBPZiBBc3V0b3NoIERhcw0KPiA+Pj4gU2VudDog
VHVlc2RheSwgSmFudWFyeSAzMCwgMjAxOCA2OjU0IEFNDQo+ID4+PiBUbzogc3ViaGFzaGpAY29k
ZWF1cm9yYS5vcmc7IGNhbmdAY29kZWF1cm9yYS5vcmc7DQo+ID4+PiB2aXZlay5nYXV0YW1AY29k
ZWF1cm9yYS5vcmc7IHJuYXlha0Bjb2RlYXVyb3JhLm9yZzsNCj4gPj4+IHZpbmhvbGlrYXR0aUBn
bWFpbC5jb207IGplamJAbGludXgudm5ldC5pYm0uY29tOw0KPiA+Pj4gbWFydGluLnBldGVyc2Vu
QG9yYWNsZS5jb20NCj4gPj4+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsgVmVua2F0
IEdvcGFsYWtyaXNobmFuDQo+ID4+PiA8dmVua2F0Z0Bjb2RlYXVyb3JhLm9yZz47IEFzdXRvc2gg
RGFzIDxhc3V0b3NoZEBjb2RlYXVyb3JhLm9yZz47DQo+ID4+PiBvcGVuIGxpc3QgPGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc+DQo+ID4+PiBTdWJqZWN0OiBbUEFUQ0ggMS8xXSBzY3NpOiB1
ZnM6IG1ha2Ugc3VyZSBhbGwgaW50ZXJydXB0cyBhcmUNCj4gPj4+IHByb2Nlc3NlZA0KPiA+Pj4N
Cj4gPj4+IEZyb206IFZlbmthdCBHb3BhbGFrcmlzaG5hbiA8dmVua2F0Z0Bjb2RlYXVyb3JhLm9y
Zz4NCj4gPj4+DQo+ID4+PiBBcyBtdWx0aXBsZSByZXF1ZXN0cyBhcmUgc3VibWl0dGVkIHRvIHRo
ZSB1ZnMgaG9zdCBjb250cm9sbGVyIGluDQo+ID4+PiBwYXJhbGxlbCB0aGVyZSBjb3VsZCBiZSBp
bnN0YW5jZXMgd2hlcmUgdGhlIGNvbW1hbmQgY29tcGxldGlvbg0KPiA+Pj4gaW50ZXJydXB0IGFy
cml2ZXMgbGF0ZXIgZm9yIGEgcmVxdWVzdCB0aGF0IGlzIGFscmVhZHkgcHJvY2Vzc2VkDQo+ID4+
PiBlYXJsaWVyIGFzIHRoZSBjb3JyZXNwb25kaW5nIGRvb3JiZWxsIHdhcyBjbGVhcmVkIHdoZW4g
aGFuZGxpbmcgdGhlDQo+ID4+PiBwcmV2aW91cyBpbnRlcnJ1cHQuIFJlYWQgdGhlIGludGVycnVw
dCBzdGF0dXMgaW4gYSBsb29wIGFmdGVyDQo+ID4+PiBwcm9jZXNzaW5nIHRoZSByZWNlaXZlZCBp
bnRlcnJ1cHQgdG8gY2F0Y2ggc3VjaCBpbnRlcnJ1cHRzIGFuZA0KPiA+Pj4gaGFuZGxlIGl0Lg0K
PiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IFZlbmthdCBHb3BhbGFrcmlzaG5hbiA8dmVua2F0
Z0Bjb2RlYXVyb3JhLm9yZz4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEFzdXRvc2ggRGFzIDxhc3V0
b3NoZEBjb2RlYXVyb3JhLm9yZz4NClRlc3RlZC1ieTogYXZyaS5hbHRtYW5Ad2RjLmNvbQ0KDQpU
ZXN0ZWQgb24ga2lyaW45NjAgKG1hdGU5KSAgYW5kIG1zbTg5OTggKGh0YzExKSwgYm90aCB3aGVy
ZSBpbnRlcnJ1cHQgYWdncmVnYXRpb24gaXMgbm90IGFsbG93ZWQuDQoNCkFzIGEgc2lkZSBub3Rl
LCBJIG5vdGljZWQgdGhhdCB0aGlzIHBhdGNoIGlzIHBhcnQgb2Ygc2V2ZXJhbCBwYXRjaGVzLCBm
aXhpbmcgc29tZSBxY29tLXN0YWZmLg0KTWF5YmUgeW91IHdhbnQgdG8gcHV0IHRoZW0gYWxsIGlu
IGEgcGF0Y2hzZXQ/DQoNClRoYW5rcywNCkF2cmkNCg==
