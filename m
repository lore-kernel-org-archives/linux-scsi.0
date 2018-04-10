From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC PATCH] mpt3sas: mpt3sas_scsih_enclosure_find_by_handle can
 be static
Date: Tue, 10 Apr 2018 12:46:11 +0000
Message-ID: <eb2d41d99bbbed5a124930c374baddc8af4d19d7.camel@wdc.com>
References: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
         <20180320210652.GA40906@xian>
         <289588bbff4dc0d35e519d0c4d4282da78cc6121.camel@wdc.com>
         <yq1370jj278.fsf@oracle.com>
         <8be1199e-01bd-6fb3-7da5-4a488442331e@uls.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <8be1199e-01bd-6fb3-7da5-4a488442331e@uls.co.za>
Content-Language: en-US
Content-ID: <BE4A3ED91A6A72478B40CBD6AAA6E529@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jaco@uls.co.za" <jaco@uls.co.za>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "kbuild-all@01.org" <kbuild-all@01.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "lkp@intel.com" <lkp@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE4LTA0LTEwIGF0IDA5OjE1ICswMjAwLCBKYWNvIEtyb29uIHdyb3RlOg0KPiBJ
J3ZlIG5vdCBzZWVuIGFkZGl0aW9uYWwgZmVlZGJhY2sgb24gdGhpcyAoSSBtYXkgc2ltcGx5IG5v
dCBiZSBDQ2VkKS4NCj4gDQo+IEkndmUgYXBwbGllZCB0aGUgcGF0Y2ggdG8gb25lIG9mIG91ciBo
b3N0cyB3aGVyZSB3ZSd2ZSBoYWQgZW5kbGVzcyBJTw0KPiBsb2NrdXBzICh3aXRoIE1RIGVuYWJs
ZWQgdGhlIGhvc3QgZGllZCB3aXRoaW4gYSBkYXkgb3IgdHdvLCBzb21ldGltZXMNCj4gc3ViIG9u
ZSBob3VyLCB3aXRob3V0IGl0IHR5cGljYWxseSByYW4gZm9yIGFib3V0IHR3byB3ZWVrcykuICBX
aXRoIHRoaXMNCj4gcGF0Y2ggKG9uIHRvcCBvZiA0LjE2KSB3ZSdyZSBub3cgYXQgZm91ciBkYXlz
IGFuZCAxNyBob3Vycywgd2l0aCBJTw0KPiBzdGlsbCBnb2luZyBzdHJvbmcgKGluY2x1ZGluZyBh
IG1kYWRtIHJlc2hhcGUgdG8gYWRkIGEgZGlzaywgYXMgd2VsbCBhcw0KPiBhIHJlYnVpbGQgb24g
YSBkcml2ZSB0aGF0IGZhaWxlZCAtIGNvbmN1cnJlbnRseSBvbiB0d28gZGlmZmVyZW50IGFycmF5
cywNCj4gc2FtZSBjb250cm9sbGVyKS4gIFZlcnkgc3ViamVjdGl2ZSwgYnV0IHRoZSBob3N0IGFs
c28gZmVlbHMgbW9yZQ0KPiByZXNwb25zaXZlIHVuZGVyIGhlYXZ5IElPIGxvYWQuDQo+IA0KPiBX
aGF0IGNhbiBJIGRvIGZyb20gbXkgc2lkZSAoSSd2ZSBnb3Qgc29tZSBkZXZlbG9wbWVudCBleHBl
cmllbmNlKSB0bw0KPiBoZWxwIHB1c2ggdGhpcyBwYXRjaCBmb3J3YXJkPw0KDQpIZWxsbyBKYWNv
LA0KDQpJZiB5b3Ugd2FudCB0byBmb2xsb3cgbXB0M3NhcyBkZXZlbG9wbWVudCBwbGVhc2UgY29u
c2lkZXIgdG8gc3Vic2NyaWJlIHRvIHRoZQ0KbGludXgtc2NzaSBtYWlsaW5nIGxpc3QuIFJlY2Vu
dGx5IEJyb2FkY29tIHBvc3RlZCBhIG5ldyBtcHQzc2FzIHBhdGNoIHNlcmllcy4NClNlZSBhbHNv
IGh0dHBzOi8vd3d3Lm1haWwtYXJjaGl2ZS5jb20vbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcv
bXNnNzI4MjMuaHRtbC4NCg0KQmFydC4NCg0KDQoNCg==
