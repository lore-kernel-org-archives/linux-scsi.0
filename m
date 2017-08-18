From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [BUG][bisected 270065e] linux-next fails to boot on powerpc
Date: Fri, 18 Aug 2017 21:41:13 +0000
Message-ID: <1503092473.2622.17.camel@wdc.com>
References: <1502902815.3305.22.camel@abdul.in.ibm.com>
         <1502904072.2421.3.camel@wdc.com>
         <2f686064-3e32-df8d-134f-962b5181da9d@linux.vnet.ibm.com>
         <1502985161.2615.8.camel@wdc.com>
         <71fb9c1b-9f3f-acdc-8bb5-aa1240aea763@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <71fb9c1b-9f3f-acdc-8bb5-aa1240aea763@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <68887D7DDBE50145B91F1308358F04AA@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE3LTA4LTE4IGF0IDE2OjA0IC0wNTAwLCBCcmlhbiBLaW5nIHdyb3RlOg0KPiBJ
IHRoaW5rIEkgaGF2ZSBhbiB1bmRlcnN0YW5kaW5nIHdoYXQgaXMgZ29pbmcgb24gYW5kIHdoeSBC
YXJ0J3MgcGF0Y2ggaXMgY2F1c2luZyBwcm9ibGVtcyBmb3IgaXByLg0KPiBJIGNhbiB3b3JrIGFy
b3VuZCB0aGUgYm9vdCBoYW5nIGluIGlwciwgYnV0IHVsdGltYXRlbHkgSSB0aGluayB3ZSBuZWVk
IHRvIGZpZ3VyZSBvdXQgYSBmaXgNCj4gaW4gc2NzaSAvIGJsb2NrLiBJIGFkZGVkIHNvbWUgdHJh
Y2luZyBhbmQgY29uZmlybWVkIGl0cyBub3QgYSBtYXR0ZXIgb2YgY29tbWFuZHMgZ2V0dGluZyBz
dHVjaw0KPiBpbiBpcHIuIFRoZSBpc3N1ZSBpcyB3ZSBhcmUgcmV0cnlpbmcgZmFpbGVkIGNvbW1h
bmRzIHVudGlsIHdlIGZpbmFsbHkgcnVuIG91dCBvZiB0aW1lLiBUaGlzIGlzDQo+IHdoYXQgSSBz
ZWU6DQo+IA0KPiAxLiBzZF9yZXZhbGlkYXRlX2Rpc2sgY2FsbHMgc2NzaV9yZXBvcnRfb3Bjb2Rl
DQo+IDIuIGlwciBSQUlEIGFycmF5cyBkb24ndCBzdXBwb3J0IE1BSU5URU5BTkNFX0lOIC8gTUlf
UkVQT1JUX1NVUFBPUlRFRF9PUEVSQVRJT05fQ09ERVMNCj4gMy4gaXByIHJldHVybnMgdGhlIGNv
bW1hbmQgd2l0aCBESURfRVJST1INCj4gNC4gc2NzaV9kZWNpZGVfZGlzcG9zaXRpb24gZ29lcyB0
byBtYXliZV9yZXRyeSwgaW5jcmVtZW50cyBzY21kLT5yZXRyaWVzLCBhbmQgcmV0dXJucyBORUVE
U19SRVRSWQ0KPiA1LiBzY3NpX3NvZnRpcnFfZG9uZSBjYWxscyBzY3NpX3F1ZXVlX2luc2VydCB0
byByZXF1ZXVlIHRoZSBjb21tYW5kLCB3aGljaCBjYWxscyBzY3NpX21xX3JlcXVldWVfY21kDQo+
IDYuIFdpdGggQmFydCdzIGNoYW5nZSwgd2UgdGhlbiBjbGVhciBSUUZfRE9OVFBSRVAgaW4gdGhp
cyBwYXRoLCB3aGlsZSBwcmlvciB3ZSBkaWQgbm90DQo+IDcuIFRoaXMgcmVzdWx0cyBpbiB0aGUg
Y29tbWFuZCBnZXR0aW5nIHNjbWQtPnJldHJpZXMgemVyb2VkIG91dCB3aGVuIGl0IGdldHMgcmUt
cXVldWVkLA0KPiAgICBzaW5jZSB3ZSBnbyB0aHJvdWdoIHByZXAgYWdhaW4gYW5kIHdlIGxvc2Ug
b3VyIHJldHJ5IGNvdW50ZXIsIHJlc3VsdGluZyBpbiBsb3RzIGFuZCBsb3RzIG9mIHJldHJpZXMu
DQo+IDguIFNpbmNlIHRoZSBkZWZhdWx0IGNvbW1hbmQgdGltZW91dCBmb3IgYW4gaXByIFJBSUQg
YXJyYXkgaXMgMTIwIHNlY29uZHMsIHRoZXNlIHJldHJpZXMgZ28gb24gZm9yDQo+ICAgIHF1aXRl
IGEgbG9uZyB0aW1lLi4uDQo+IDkuIEZpbmFsbHksIHRoZSBjb21tYW5kIGhhcyBiZWVuIHJldHJp
ZWQgc28gbG9uZyB3ZSB0cmlwIG92ZXIgdGhlIG92ZXJhbGwgcmV0cnkgdGltZXINCj4gICAgaW4g
c2NzaV9zb2Z0aXJxX2RvbmUgYW5kIHdlIHRpbWVvdXQgdGhlIGNvbW1hbmQuDQo+IA0KPiBJJ2xs
IGZvbGxvdyB1cCB3aXRoIGEgcGF0Y2ggdG8gaXByIHRvIHdvcmthcm91bmQgdGhlIGhhbmcsIGJ1
dCBJIHRoaW5rIHdlIG5lZWQgdG8gc29tZWhvdyBwcmVzZXJ2ZQ0KPiB0aGUgcmV0cnkgY291bnRl
ciBpbiB0aGUgc2NzaSBjb21tYW5kLCBhcyB0aGlzIHdpbGwgbGlrZWx5IGNhdXNlIGlzc3VlcyB3
aXRoIG90aGVyIGRyaXZlcnMuIA0KDQpIZWxsbyBCcmlhbiwNCg0KVGhhbmtzIGZvciB0aGUgZGV0
YWlsZWQgYW5hbHlzaXMuIFRoaXMgaXMgdmVyeSBoZWxwZnVsLiBIYXZlIHlvdSBjb25zaWRlcmVk
DQp0byBjaGFuZ2UgdGhlIGlwciBkcml2ZXIgc3VjaCB0aGF0IGl0IHRlcm1pbmF0ZXMgUkVQT1JU
IFNVUFBPUlRFRCBPUEVSQVRJT04NCkNPREVTIGNvbW1hbmRzIHdpdGggdGhlIGFwcHJvcHJpYXRl
IGNoZWNrIGNvbmRpdGlvbiBjb2RlIGluc3RlYWQgb2YgRElEX0VSUk9SPw0KDQpUaGFua3MsDQoN
CkJhcnQu
