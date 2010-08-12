From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Date: Thu, 12 Aug 2010 09:20:39 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3DBE6239A@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	 <1277046060.5242.18.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
	 <1277063250.5242.25.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CE@cosmail02.lsi.com>
	 <1277066924.5242.41.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3DBCC8483@cosmail02.lsi.com>
 <1280598371.2801.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1280598371.2801.11.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Maharana, Parag" <Parag.Maharana@lsi.com>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
List-Id: linux-scsi@vger.kernel.org

SmFtZXMsDQoNCkp1c3QgbGV0IHlvdSBrbm93IHRoZSBuZXcgcGF0Y2hlcyBhbHJlYWR5IHN1Ym1p
dHRlZCB5ZXN0ZXJkYXkuICBQbGVhc2UgbGV0IG1lIGtub3cgYWZ0ZXIgeW91IHVwZGF0ZWQgdGhv
c2UgcGF0Y2hlcyB0byB0aGUgbWFpbiB0cmVlLg0KDQpSZWdhcmRzLA0KDQpCbyBZYW5nDQoNCi0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKYW1lcyBCb3R0b21sZXkgW21haWx0bzpK
YW1lcy5Cb3R0b21sZXlAc3VzZS5kZV0gDQpTZW50OiBTYXR1cmRheSwgSnVseSAzMSwgMjAxMCAx
OjQ2IFBNDQpUbzogWWFuZywgQm8NCkNjOiBZaW5naGFpIEx1OyBsaW51eC1zY3NpQHZnZXIua2Vy
bmVsLm9yZzsgYWtwbUBvc2RsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgTWFo
YXJhbmEsIFBhcmFnOyBEYWZ0YXJkYXIsIEpheWFudA0KU3ViamVjdDogUkU6IFtQQVRDSCAxLzEy
XSBzY3NpOiBtZWdhcmFpZF9zYXMgLSBPbmxpbmUgQ29udHJvbGxlciBSZXNldCAtIEk6IEVuYWJs
ZSBPbmxpbmUgQ29udHJvbGxlciBSZXNldCBCaXQgaW4gcmVnaXN0ZXIgcmVsYXRlZCBmdW5jdGlv
bnMNCg0KT24gRnJpLCAyMDEwLTA3LTMwIGF0IDEyOjUzIC0wNjAwLCBZYW5nLCBCbyB3cm90ZToN
Cj4gRG8geW91IGtub3cgd2hlbiB0aG9zZSBwYXRjaGVzICgxMiBwYXRjaGVzKSB3aWxsIGJlIHB1
c2hlZCB0byB1cHN0cmVhbT8NCg0KV2VsbCwgaXQgbG9va3MgbGlrZSBJIGxvc3QgdGhlIGJyYW5j
aCBJIHdhcyBmaXhpbmcgYWxsIHRoaXMgdXAgaW4NCnNvbWV3aGVyZS4gIEkgZG9uJ3QgcmVhbGx5
IGhhdmUgdGltZSB0byByZWRvIHRoYXQgd29yaywgc28gY291bGQgeW91DQpzZW5kIHRoZSBzZXJp
ZXMgY29ycmVjdGx5ICh0aGF0J3MgdGhlIDggT0NSIHBhdGNoZXMgdGhhdCBkb24ndA0KaW5kaXZp
ZHVhbGx5IGNvbXBpbGUgYXMgYSBzaW5nbGUgcGF0Y2ggd2l0aCBhIGNvcnJlY3QgY2hhbmdlbG9n
IHBsdXMgdGhlDQpmb3VyIG90aGVycykuDQoNClRoYW5rcywNCg0KSmFtZXMNCg0KDQo=
