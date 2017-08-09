From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [v4.13-rc BUG] system lockup when running big buffered write(4M)
 to IB SRP via mpath
Date: Wed, 9 Aug 2017 17:10:01 +0000
Message-ID: <1502298599.2356.7.camel@wdc.com>
References: <20170808141715.GB22763@ming.t460p>
         <1502237504.4017.1.camel@redhat.com> <1502245693.6511.3.camel@redhat.com>
         <c072e942-0265-f0ad-561d-0e50d50e3cb1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63188 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752757AbdHIRKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2017 13:10:49 -0400
In-Reply-To: <c072e942-0265-f0ad-561d-0e50d50e3cb1@redhat.com>
Content-Language: en-US
Content-ID: <383872F987413C46BD0A1ACAF1D645EA@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "loberman@redhat.com" <loberman@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>

T24gV2VkLCAyMDE3LTA4LTA5IGF0IDEyOjQzIC0wNDAwLCBMYXVyZW5jZSBPYmVybWFuIHdyb3Rl
Og0KPiBZb3VyIGxhdGVzdCBwYXRjaCBvbiBzdG9jayB1cHN0cmVhbSB3aXRob3V0IE1pbmcncyBs
YXRlc3QgcGF0Y2hlcyBpcyANCj4gYmVoYXZpbmcgZm9yIG1lLg0KPiANCj4gQXMgYWxyZWFkeSBt
ZW50aW9uZWQsIHRoZSByZXF1ZXVlIC0xMSBhbmQgY2xvbmUgZmFpbHVyZSBtZXNzYWdlcyBhcmUg
DQo+IGdvbmUgYW5kIEkgYW0gbm90IGFjdHVhbGx5IHNlZWluZyBhbnkgc29mdCBsb2NrdXBzIG9y
IGhhcmQgbG9ja3Vwcy4NCj4gDQo+IFdoZW4gTWluZyBnZXRzIGJhY2sgSSB3aWxsIHdvcmsgd2l0
aCBoaW0gb24gaGlzIHBhdGNoIHNldCBhbmQgdGhlIGxvY2t1cHMuDQo+IA0KPiBSdW5uaW5nIDEw
IHBhcmFsbGVsIHdyaXRlcyB3aGljaCBlYXNpbHkgdHJpcHMgaW50byBzb2Z0IGxvY2t1cHMgb24g
DQo+IE1pbmcncyBrZXJuZWwgKGV2ZW4gd2l0aCB5b3VyIHBhdGNoKSBoYXMgYmVlbiBzdGFibGUg
aGVyZSBvbiA0LjEzLVJDMyANCj4gd2l0aCB5b3VyIHBhdGNoLg0KPiANCj4gSSB3aWxsIGxlYXZl
IGl0IHJ1bm5pbmcgZm9yIGEgd2hpbGUgbm93IGJ1dCB0aGUgcGF0Y2ggaXMgZ29vZC4NCj4gDQo+
IElmIGl0IHN1cnZpdmVzIDQgaG91cnMgSSB3aWxsIGFkZCBhIFRlc3RlZC1ieSB0byB5b3VyIGxh
dGVzdCBwYXRjaC4NCg0KSGVsbG8gTGF1cmVuY2UsDQoNCkknbSB3b3JraW5nIG9uIGFuIGFkZGl0
aW9uYWwgcGF0Y2ggdGhhdCBzaG91bGQgcmVkdWNlIHVubmVjZXNzYXJ5IHJlcXVldWluZw0KZXZl
biBmdXJ0aGVyLiBJIHdpbGwgbGV0IHlvdSBrbm93IHdoZW4gaXQncyByZWFkeS4NCg0KQWRkaXRp
b25hbGx5LCBwbGVhc2UgdHJpbSBlLW1haWxzIHdoZW4gcmVwbHlpbmcgc3VjaCB0aGF0IGUtbWFp
bHMgZG8gbm90IGdldA0KdG9vIGxvbmcuDQoNClRoYW5rcywNCg0KQmFydC4=
