From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v6 9/9] snic:Add Makefile, patch Kconfig, MAINTAINERS
Date: Thu, 28 May 2015 09:49:08 +0000
Message-ID: <D18CE1AF.26822%nmusini@cisco.com>
References: <1432711182-17530-1-git-send-email-nmusini@cisco.com>
 <1432711182-17530-10-git-send-email-nmusini@cisco.com>
 <55658BAC.5000009@plexistor.com> <D18B9001.266AC%nmusini@cisco.com>
 <5565A997.9070604@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="euc-kr"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-7.cisco.com ([173.37.142.94]:18128 "EHLO
	alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbE1JtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2015 05:49:10 -0400
In-Reply-To: <5565A997.9070604@plexistor.com>
Content-Language: en-US
Content-ID: <254F56B81BDECB47B554CEFF567185D9@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

SGkgQm9heiwgDQoNCiAgICBTdXJlLCBJIHdpbGwgaW5jb3Jwb3JhdGUgdGhlIGNvbW1lbnRzIGFu
ZCBzdWdnZXN0aW9ucyBpbiBuZXh0IHBhdGNoDQpzdWJtaXR0YWwuDQoNClRoYW5rcw0KTmFyc2lt
aHVsdQ0KDQpPbiAyNy8wNS8xNSA0OjU1IHBtLCAiQm9heiBIYXJyb3NoIiA8Ym9hekBwbGV4aXN0
b3IuY29tPiB3cm90ZToNCg0KPk9uIDA1LzI3LzIwMTUgMDE6MDIgUE0sIE5hcnNpbWh1bHUgTXVz
aW5pIChubXVzaW5pKSB3cm90ZToNCj48Pg0KPj4+PiAraWZlcSAoJChDT05GSUdfU0NTSV9TTklD
X0RFQlVHX0ZTKSwgeSkNCj4+Pj4gK2NjZmxhZ3MteSArPSAtRFNOSUNfREVCVUdfRlMNCj4+Pg0K
Pj4+IFdoeSBkbyB5b3UgbmVlZCBhbiBleHRyYSBkZWZpbmUgaGVyZSBqdXN0IHVzZQ0KPj4+IENP
TkZJR19TQ1NJX1NOSUNfREVCVUdfRlMgaW4gc291cmNlIGNvZGUgZGlyZWN0bHkNCj4+IEFncmVl
LCBJIGp1c3Qgd2FudCB0byB1c2UgYSBzaG9ydGVyIG1hY3JvIGluIHRoZSBzb3VyY2UuDQo+DQo+
RG9uJ3QgZG8gdGhpcy4gSXQgaXMgYSBjb252ZW50aW9uIHRoYXQgaWYgYSBwcm9ncmFtbWVyDQo+
c2VlcyBhIENPTkZJR19YWFggaGUga25vd3MgdGhhdCB0aGlzIGlzIHNldHRhYmxlIGJ5IGENCj5L
Y29uZmlnLiBCeSBtYWtpbmcgaXQgc2hvcnRlciB0aGUgcHJvZ3JhbW1lciB3aWxsIHRoaW5rIHRo
YXQNCj50aGlzIGlzIGRlYWQgY29kZSBiZWNhdXNlIGl0IGlzIG5vdCBzZXQgYW55d2hlcmUuDQo+
DQo+Pj4NCj4+Pj4gK3NuaWMteSArPSBzbmljX2RlYnVnZnMubyBcDQo+Pj4+ICsJCXNuaWNfdHJj
Lm8NCj4+Pj4gK2VuZGlmDQo+Pj4+DQo+Pj4NCj4+PiBzbmljLSQoQ09ORklHX1NDU0lfU05JQ19E
RUJVR19GUykgKz0gc25pY19kZWJ1Z2ZzLm8NCj4+IElmIENPTkZJR19TQ1NJX1NOSUNfREVCVUdG
UyBpcyBub3Qgc2V0LCB0aGVuIGl0IGxlYXZlcyBhIGJ1aWxkIHZhcmlhYmxlDQo+PiCp+HNuaWMt
IiBpbiBidWlsZCBzeXN0ZW0uIGlmZXEoKSBhdm9pZHMgc3VjaCB0aGluZy4NCj4NCj5UaGF0IGlz
IGZpbmUuIFRoaXMgaXMgZG9uZSBhbGwgb3ZlciB0aGUgS2VybmVsIE1ha2VmaWxlLg0KPlRoZXJl
IGFyZSB0d28gdG9ucyBvZiB0aGVzZSAiZG8gbm90aGluZyBtYWtlIHZhcmlhYmxlcyINCj4NCj5J
dCB0aGUgd2F5IHdlIGRvIGl0IGluIHRoZSBLZXJuZWwuIChJIGFjdHVhbGx5IGxpa2UgaXQpDQo+
DQo+Pj4NCj4+PiBZb3UgZG8gbm90IHRoZSAgaWZlcSAoKSB0aGluZyBhdCBhbGwNCj4+Pg0KPj4+
IENoZWVycw0KPj4+IEJvYXoNCj4+Pg0KPj4gVGhhbmtzDQo+PiBzaW1oYQ0KPj4+DQo+PiANCj4N
Cg0K
