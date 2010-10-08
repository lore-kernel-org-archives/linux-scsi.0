From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 2/5] scsi: megaraid_sas - support devices update flag
Date: Fri, 8 Oct 2010 07:47:25 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C30100F54C90@cosmail02.lsi.com>
References: <AANLkTim3OKvhov1uCj5g6YgmOzR1rDogLmtJMTkbYq5V@mail.gmail.com>
 <1286490947.23573.3.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:55356 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab0JHNro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2010 09:47:44 -0400
In-Reply-To: <1286490947.23573.3.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, bo yang <boyang1288@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

SmFtZXMsDQoNClRoYW5rcyBmb3IgZ2V0dGluZyB0aGUgb25saW5lIGNvbnRyb2xsZXIgcmVzZXQg
aW4uICBJIGRvd25sb2FkZWQgcGF0Y2ggMi81IGZyb20gIGh0dHA6Ly9tYXJjLmluZm8vP2w9bGlu
dXgtc2NzaSZtPTEyODUyMTEyNzIwMzE5OSZ3PTIgYW5kIEkgY2FuIGFwcGx5IGl0IHdpdGhvdXQg
ZXJyb3JzLg0KDQpDYW4geW91IHRyeSBpdCBhZ2Fpbj8gIG90aGVyd2lzZSBJIG5lZWQgdG8gcmUt
YXR0YWNoIGl0Lg0KDQpUaGFua3MsDQoNCkJvIFlhbmcgICAgDQoNCi0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQpGcm9tOiBKYW1lcyBCb3R0b21sZXkgW21haWx0bzpKYW1lcy5Cb3R0b21sZXlA
c3VzZS5kZV0gDQpTZW50OiBUaHVyc2RheSwgT2N0b2JlciAwNywgMjAxMCA2OjM2IFBNDQpUbzog
Ym8geWFuZw0KQ2M6IFlhbmcsIEJvOyBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsgYWtwbUBv
c2RsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFtQQVRD
SCAyLzVdIHNjc2k6IG1lZ2FyYWlkX3NhcyAtIHN1cHBvcnQgZGV2aWNlcyB1cGRhdGUgZmxhZw0K
DQpPbiBXZWQsIDIwMTAtMDktMjIgYXQgMjI6NTAgLTA0MDAsIGJvIHlhbmcgd3JvdGU6DQo+IERy
aXZlciBhZGRlZCB0aGUgRGV2aWNlIHVwZGF0ZSBmbGFnIHRvIHRlbGwgTFNJIGFwcGxpY2F0aW9u
IGRyaXZlcg0KPiB3aWxsIGRvIHRoZSBkZXZpY2UgVXBkYXRlLiAgTFNJIE1lZ2FSQUlEIFNBUyBh
cHBsaWNhdGlvbiB3aWxsIGNoZWNrDQo+IHRoaXMgZmxhZyB0byBkZWNpZGUgaWYgaXQgaXMgbmVl
ZCB0byB1cGRhdGUgdGhlIERldmljZSBvciBub3QuDQoNCldlbGwsIHRoZSBnb29kIG5ld3MgaXMg
SSd2ZSBnb3QgdGhlIE9ubGluZSBDb250cm9sbGVyIHJlc2V0IHVwZGF0ZS4gVGhlDQpiYWQgbmV3
cyBpcyB0aGF0IHRoaXMgcGF0Y2ggbm93IGZhaWxzIHRvIGFwcGx5OiBsb29rcyBsaWtlIGFuIGF0
dGFjaG1lbnQNCnByb2JsZW0gYWdhaW46DQoNCkFwcGx5aW5nOiBtZWdhcmFpZF9zYXM6IHN1cHBv
cnQgZGV2aWNlcyB1cGRhdGUgZmxhZw0KZmF0YWw6IGNvcnJ1cHQgcGF0Y2ggYXQgbGluZSA3MA0K
UGF0Y2ggZmFpbGVkIGF0IDAwMDEgbWVnYXJhaWRfc2FzOiBzdXBwb3J0IGRldmljZXMgdXBkYXRl
IGZsYWcNCg0KSmFtZXMNCg0KDQo=
