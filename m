From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH RESEND^2] sd: fix infinite kernel/udev loop on
 non-removable Medium Not Present
Date: Mon, 29 Apr 2013 23:14:47 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950E011DA@G9W0745.americas.hpqcorp.net>
References: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
	 <1366997459.16829.4.camel@dabdike>
 <1367268334.1653.47.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:12501 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307Ab3D2XP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Apr 2013 19:15:58 -0400
In-Reply-To: <1367268334.1653.47.camel@iscandar.digidescorp.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Steven J. Magnani" <steve@digidescorp.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtc2NzaS1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgW21haWx0bzpsaW51eC1zY3NpLQ0KPiBvd25lckB2Z2VyLmtlcm5l
bC5vcmddIE9uIEJlaGFsZiBPZiBTdGV2ZW4gSi4gTWFnbmFuaQ0KPiBTZW50OiBNb25kYXksIDI5
IEFwcmlsLCAyMDEzIDM6NDYgUE0NCj4gVG86IEphbWVzIEJvdHRvbWxleQ0KPiBDYzogVGVqdW4g
SGVvOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zY3NpQHZnZXIua2VybmVs
Lm9yZzsNCj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFJF
U0VORF4yXSBzZDogZml4IGluZmluaXRlIGtlcm5lbC91ZGV2IGxvb3Agb24gbm9uLQ0KPiByZW1v
dmFibGUgTWVkaXVtIE5vdCBQcmVzZW50DQo+IA0KPiBPbiBGcmksIDIwMTMtMDQtMjYgYXQgMTE6
MzkgLTA1MDAsIFN0ZXZlbiBKLiBNYWduYW5pIHdyb3RlOg0KDQo+IFRoZSBzY2VuYXJpbyBpcyBn
ZW5lcmFsbHkgb25lIG9mIHRoZXNlIHR3byB1bmNvbW1vbiB1c2UgY2FzZXM6DQo+IA0KPiAxLiBU
aGUgZGV2aWNlIGhhcyBjb21lIHVwIGluICJmYWlsc2FmZSBtb2RlIiBiZWNhdXNlIHRoZSB1c2Vy
IGRhbWFnZWQNCj4gdGhlIG5vcm1hbCAib3BlcmF0aW9uYWwiIG1pY3JvY29kZSBieSB5YW5raW5n
IHBvd2VyIGR1cmluZyBhbg0KPiBvcGVyYXRpb25hbCBtaWNyb2NvZGUgdXBkYXRlLiBGYWlsc2Fm
ZSBtb2RlIGFsbG93cyBmb3IgbWljcm9jb2RlIHVwZGF0ZSwNCj4gYW5kIG5vdCBtdWNoIGVsc2Uu
DQoNCkl0IG1heSBub3QgaGVscCBzaGlwcGluZyBkZXZpY2VzLCBidXQgd291bGQgYSBuZXcgc2Vu
c2Uga2V5L2FkZGl0aW9uYWwgc2Vuc2UgY29kZSANCmNvbWJpbmF0aW9uIGJlIGhlbHBmdWwgZm9y
IGRldmljZXMgaW4gc3VjaCBhIHN0YXRlPw0KDQpOT1QgUkVBRFkvTE9HSUNBTCBVTklUIE5PVCBS
RUFEWSwgRE9XTkxPQUQgTUlDUk9DT0RFIFJFUVVJUkVEDQoNCg==
