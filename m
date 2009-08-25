From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 0/3] scsi_dh_rdac: Adding more debug options for scsi
 rdac handler
Date: Tue, 25 Aug 2009 07:59:39 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474BFD9EB@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF474BFD90A@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:39298 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZHYN7o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2009 09:59:44 -0400
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474BFD90A@cosmail01.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, device-mapper development <dm-devel@redhat.com>

Q29ycmVjdGluZyB0aGUgdHlwby4uIFRoaXMgY29kZSBoYXMgYmVlbiB0ZXN0ZWQgb24gMi42LjMx
LXJjNS4NCg0KVGhhbmtzDQpCYWJ1IE1vZ2VyIA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQo+IEZyb206IGxpbnV4LXNjc2ktb3duZXJAdmdlci5rZXJuZWwub3JnIFttYWlsdG86bGlu
dXgtc2NzaS0NCj4gb3duZXJAdmdlci5rZXJuZWwub3JnXSBPbiBCZWhhbGYgT2YgTW9nZXIsIEJh
YnUNCj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMjQsIDIwMDkgNzowOSBQTQ0KPiBUbzogTGludXgg
U0NTSSBNYWlsaW5nIGxpc3QNCj4gQ2M6IENoYXVoYW4sIFZpamF5OyBDaGFuZHJhIFNlZXRoYXJh
bWFuOyBTdGFua2V5LCBSb2JlcnQ7IGRldmljZS1tYXBwZXINCj4gZGV2ZWxvcG1lbnQNCj4gU3Vi
amVjdDogW1BBVENIIDAvM10gc2NzaV9kaF9yZGFjOiBBZGRpbmcgbW9yZSBkZWJ1ZyBvcHRpb25z
IGZvciBzY3NpDQo+IHJkYWMgaGFuZGxlcg0KPiANCj4gSGkgQWxsLA0KPiBUaGVzZSBwYXRjaGVz
IGFkZCBtb3JlIGRlYnVnZ2luZyBvcHRpb25zIHRvIHNjc2kgcmRhYyBkZXZpY2UgaGFuZGxlci4N
Cj4gVGhpcyBjYW4gY29uc2lkZXJhYmx5IHJlZHVjZSB0aGUgdGltZSB0YWtlbiB0byBkZWJ1ZyBp
c3N1ZXMgaW4gYmlnDQo+IGNvbmZpZ3VyYXRpb25zIGFuZCBhbHNvIHZlcnkgaGVscGZ1bCBpbiBh
ZGRyZXNzaW5nIHRoZSBzdXBwb3J0IGlzc3Vlcy4NCj4gSGVyZSBhcmUgdGhlIHN1bW1hcnkgb2Yg
Y2hhbmdlcy4NCj4gIC0gQWRkZWQgYSBiaXQgbWFzayAibW9kdWxlIHBhcmFtZXRlciIgcmRhY19s
b2dnaW5nIHdpdGggMiBiaXRzIGZvcg0KPiAgICBlYWNoIHR5cGUgb2YgbG9nZ2luZy4NCj4gIC0g
Y3VycmVudGx5IGRlZmluZWQgb25seSB0d28gdHlwZXMgb2YgbG9nZ2luZyhmYWlsb3ZlciBhbmQg
c2Vuc2UNCj4gbG9nZ2luZykuDQo+ICAgIENhbiBiZSBlbmhhbmNlZCBsYXRlciBpZiByZXF1aXJl
ZC4NCj4gIC0gQnkgZGVmYXVsdCBvbmx5IGZhaWxvdmVyIGxvZ2dpbmcgaXMgZW5hYmxlZCB3aGlj
aCBpcyBlcXVpdmFsZW50IG9mDQo+ICAgIGN1cnJlbnQgbG9nZ2luZy4NCj4gDQo+ICBUaGFua3Mg
dG8gQ2hhbmRyYSBTZWV0aGFyYW1hbiwgVmlqYXkgQ2hhdWhhbiBhbmQgQm9iIFN0YW5rZXkgZm9y
IHRoZWlyDQo+IHVzZWZ1bCBjb21tZW50cy4NCj4gIFRoaXMgY29kZSBoYXMgYmVlbiB0ZXN0ZWQg
b24gMi42LjI3LXJjNS4NCj4gDQo+IC1UaGFua3MNCj4gQmFidSBNb2dlcg0KPiANCj4gTu+/ve+/
ve+/ve+/ve+/vXLvv73vv71577+977+977+9Yu+/vVjvv73vv73Hp3bvv71e77+9Kd66ey5u77+9
K++/ve+/ve+/ve+/vXvvv73vv73vv70i77+9e2F577+9HcqH2pnvv70sag3vv73vv71m77+977+9
77+9aO+/ve+/ve+/vXrvv70e77+9d++/ve+/ve+/vQ0KPiANCj4g77+977+977+9ajordu+/ve+/
ve+/vXfvv71q77+9be+/ve+/ve+/ve+/vQ3vv73vv73vv73vv716Wivvv73vv73vv73vv73vv73d
omoi77+977+9Ie+/vWkNCg==
