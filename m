From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 01/13] qla4xxx: cleanup qla4xxx_initialize_ddb_list()
Date: Wed, 23 Mar 2011 08:10:12 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728A521EA1@AVEXMB1.qlogic.org>
References: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1300891458.15899.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:55881 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab1CWPKZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 11:10:25 -0400
In-Reply-To: <1300891458.15899.8.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogSmFtZXMgQm90dG9tbGV5IFttYWls
dG86SmFtZXMuQm90dG9tbGV5QHN1c2UuZGVdDQo+U2VudDogV2VkbmVzZGF5LCBNYXJjaCAyMywg
MjAxMSA4OjE0IFBNDQo+VG86IFZpa2FzIENoYXVkaGFyeQ0KPkNjOiBsaW51eC1zY3NpQHZnZXIu
a2VybmVsLm9yZzsgUmF2aSBBbmFuZDsgTGFsaXQgQ2hhbmRpdmFkZQ0KPlN1YmplY3Q6IFJlOiBb
UEFUQ0ggMDEvMTNdIHFsYTR4eHg6IGNsZWFudXAgcWxhNHh4eF9pbml0aWFsaXplX2RkYl9saXN0
KCkNCj4NCj5PbiBNb24sIDIwMTEtMDMtMjEgYXQgMDM6MzQgLTA3MDAsIHZpa2FzLmNoYXVkaGFy
eUBxbG9naWMuY29tIHdyb3RlOg0KPj4gRnJvbTogVmlrYXMgQ2hhdWRoYXJ5IDx2aWthcy5jaGF1
ZGhhcnlAcWxvZ2ljLmNvbT4NCj4NCj5UaGVyZSdzIG9ubHkgMTIgcGF0Y2hlcyBpbiB0aGlzIHNl
cmllcyAuLi4gbG9va3MgbGlrZSAxMS8xMyBpcyBtaXNzaW5nLg0KPg0KDQpJIGFtIG5vdCBzdXJl
IHdoeSBwYXRjaCAxMS8xMyBkaWQgbm90IGNhbWUgb24gbGludXgtc2NzaSBsaXN0Lg0KSSBhbSBy
ZXNlbmRpbmcgaXQgaW4gbmV4dCBlbWFpbC4NCg0KVGhhbmtzIGEgbG90LA0KVmlrYXMuDQoNCj5K
YW1lcw0KPg0KPg0KDQoNClRoaXMgbWVzc2FnZSBhbmQgYW55IGF0dGFjaGVkIGRvY3VtZW50cyBj
b250YWluIGluZm9ybWF0aW9uIGZyb20gUUxvZ2ljIENvcnBvcmF0aW9uIG9yIGl0cyB3aG9sbHkt
b3duZWQgc3Vic2lkaWFyaWVzIHRoYXQgbWF5IGJlIGNvbmZpZGVudGlhbC4gSWYgeW91IGFyZSBu
b3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgeW91IG1heSBub3QgcmVhZCwgY29weSwgZGlzdHJp
YnV0ZSwgb3IgdXNlIHRoaXMgaW5mb3JtYXRpb24uIElmIHlvdSBoYXZlIHJlY2VpdmVkIHRoaXMg
dHJhbnNtaXNzaW9uIGluIGVycm9yLCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRl
bHkgYnkgcmVwbHkgZS1tYWlsIGFuZCB0aGVuIGRlbGV0ZSB0aGlzIG1lc3NhZ2UuDQo=

