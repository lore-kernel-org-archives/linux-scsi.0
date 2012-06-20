From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [scsi:pending 3/3] drivers/scsi/aacraid/src.c:425:2: warning:
 right shift count >= width of type
Date: Wed, 20 Jun 2012 18:02:42 +0000
Message-ID: <1340215362.13180.12.camel@dabdike.int.hansenpartnership.com>
References: <20120620171239.GB5512@localhost>
	 <9F0D52A8-D4E0-40C9-8619-6802A1378C16@ubuntu.com>
	 <69598C04-83AA-4F1F-AFB5-666838371CEF@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:40014 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab2FTSCp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jun 2012 14:02:45 -0400
In-Reply-To: <69598C04-83AA-4F1F-AFB5-666838371CEF@gmail.com>
Content-Language: en-US
Content-ID: <181F445FBD5AF343BF47E6103C703B31@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <benmcollins13@gmail.com>
Cc: "wfg@linux.intel.com" <wfg@linux.intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gV2VkLCAyMDEyLTA2LTIwIGF0IDEyOjUyIC0wNTAwLCBCZW4gQ29sbGlucyB3cm90ZToNCj4g
T24gSnVuIDIwLCAyMDEyLCBhdCAxMjo0NCBQTSwgQmVuIENvbGxpbnMgd3JvdGU6DQo+IA0KPiA+
IE9uIEp1biAyMCwgMjAxMiwgYXQgMTI6MTIgUE0sIHdmZ0BsaW51eC5pbnRlbC5jb20gd3JvdGU6
DQo+ID4gDQo+ID4+IEhpIEJlbiwNCj4gPj4gDQo+ID4+IFRoZXJlIGFyZSBuZXcgY29tcGlsZSB3
YXJuaW5ncyBzaG93IHVwIGluDQo+ID4+IA0KPiA+PiB0cmVlOiAgIGdpdDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9qZWpiL3Njc2kuZ2l0IHBlbmRpbmcNCj4gPj4g
aGVhZDogICBlNzY2ZGI0MmY0NWM3Njg1ZmNlNWMwZDQ4YmE3NGVhYTk3ZTZkNzE1DQo+ID4+IGNv
bW1pdDogZTc2NmRiNDJmNDVjNzY4NWZjZTVjMGQ0OGJhNzRlYWE5N2U2ZDcxNSBbMy8zXSBbU0NT
SV0gYWFjcmFpZDogRml4IGVuZGlhbiBpc3N1ZXMgaW4gY29yZSBhbmQgU1JDIHBvcnRpb25zIG9m
IGRyaXZlcg0KPiA+PiANCj4gPj4gQWxsIHdhcm5pbmdzOg0KPiA+PiANCj4gPj4gZHJpdmVycy9z
Y3NpL2FhY3JhaWQvc3JjLmM6IEluIGZ1bmN0aW9uICdhYWNfc3JjX2RlbGl2ZXJfbWVzc2FnZSc6
DQo+ID4+IGRyaXZlcnMvc2NzaS9hYWNyYWlkL3NyYy5jOjQyNToyOiB3YXJuaW5nOiByaWdodCBz
aGlmdCBjb3VudCA+PSB3aWR0aCBvZiB0eXBlIFtlbmFibGVkIGJ5IGRlZmF1bHRdDQo+ID4gDQo+
ID4gSHJtbSwgcHJldHR5IGlubm9jdW91cywgYnV0IEkgZ3Vlc3MgaXQgY291bGQgYmUgcmV3cml0
dGVuIGFzOg0KPiA+IA0KPiA+ICNpZiBCSVRTX1BFUl9MT05HID4gMzINCj4gPiAgICAgICAgIHNy
Y193cml0ZWwoZGV2LCBNVW5pdC5JUV9ILCAoYWRkcmVzcyA+PiAzMikgJiAweGZmZmZmZmZmKTsN
Cj4gPiAjZWxzZQ0KPiA+ICAgICAgICAgc3JjX3dyaXRlbChkZXYsIE1Vbml0LklRX0gsIDApOw0K
PiA+ICNlbmRpZg0KPiANCj4gQWN0dWFsbHksIHRoaXMgaXMgd3JvbmcgdG9vLCBzaW5jZSBpdCdz
IGEgZG1hX2FkZHJfdCwgbm90IGFuIHVuc2lnbmVkIGxvbmcsIHNvOg0KPiANCj4gI2lmZGVmIENP
TkZJR19BUkNIX0RNQV9BRERSX1RfNjRCSVQNCj4gICAgICAgICBzcmNfd3JpdGVsKGRldiwgTVVu
aXQuSVFfSCwgKGFkZHJlc3MgPj4gMzIpICYgMHhmZmZmZmZmZik7DQo+ICNlbHNlDQo+ICAgICAg
ICAgc3JjX3dyaXRlbChkZXYsIE1Vbml0LklRX0gsIDApOw0KPiAjZW5kaWYNCg0KSGVoLCB0aHJl
ZSBzdHJpa2VzIGFuZCB5b3UncmUgb3V0LiAgVG8gZm9yZXN0YWxsIHRoaXMsIHRoZSBhY3R1YWwg
YW5zd2VyDQppcw0KDQpzcmNfd3JpdGVsKGRldiwgTVVuaXQuSVFfSCwgdXBwZXJfMzJfYml0cyhh
ZGRyZXNzKSk7DQoNCkphbWVzDQoNCg==
