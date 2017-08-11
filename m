From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH RESEND 0/6] hpsa: support legacy boards
Date: Fri, 11 Aug 2017 16:35:41 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D195B8CBA03@avsrvexchmbx2.microsemi.net>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <4993A297653ECB4581FA5C3C31323D195B8C9FAB@avsrvexchmbx2.microsemi.net>
 <271fd4b5-046f-2c74-4af8-60f225744313@suse.de>
 <20170810070904.GA20910@lst.de>
 <1502374013.2736.11.camel@HansenPartnership.com>
 <8d4fdf1c-bdd6-3069-1933-a031c84811c6@suse.de>
 <4993A297653ECB4581FA5C3C31323D195B8CACF5@avsrvexchmbx2.microsemi.net>
 <6b439024-3bda-c370-b32b-d0fba67efbd9@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0087.outbound.protection.outlook.com ([104.47.36.87]:15584
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753596AbdHKQgF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 12:36:05 -0400
In-Reply-To: <6b439024-3bda-c370-b32b-d0fba67efbd9@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Meelis Roos <mroos@linux.ee>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIYW5uZXMgUmVpbmVja2UgW21h
aWx0bzpoYXJlQHN1c2UuZGVdDQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDExLCAyMDE3IDE6NDMg
QU0NCj4gVG86IERvbiBCcmFjZSA8ZG9uLmJyYWNlQG1pY3Jvc2VtaS5jb20+OyBKYW1lcyBCb3R0
b21sZXkNCj4gPEphbWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5jb20+OyBDaHJpc3Rv
cGggSGVsbHdpZw0KPiA8aGNoQGxzdC5kZT4NCj4gQ2M6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFy
dGluLnBldGVyc2VuQG9yYWNsZS5jb20+OyBNZWVsaXMgUm9vcw0KPiA8bXJvb3NAbGludXguZWU+
OyBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFJFU0VO
RCAwLzZdIGhwc2E6IHN1cHBvcnQgbGVnYWN5IGJvYXJkcw0KPiANCj4gRVhURVJOQUwgRU1BSUwN
Cg0KLi4uDQo+ID4NCj4gPiBPaywgYnV0IHRvIGNsYXJpZnkuLi4NCj4gPiAgKiBXaWxsIHRoZSBj
Y2lzcyBkcml2ZXIgYmUgcmVtb3ZlZCB3aGVuIHRoZXNlIHBhdGNoZXMgYXJlIGFwcGxpZWQ/DQo+
IE90aGVyd2lzZQ0KPiA+ICAgICB3aGF0IHdpbGwgcHJldmVudCB0aGUgY2Npc3MgZHJpdmVyIGZy
b20gbG9hZGluZyBvdmVyIHRoZXNlIGRldmljZXM/DQo+ID4gICAgIGkuZS4gaG93IG9mdGVuIHdp
bGwgdXNlcnMgbmVlZCB0byBiZSByZW1pbmRlZCB0byBhZGQNCj4gY2Npc3MuY2Npc3NfYWxsb3df
aHBzYSBmbGFnPw0KPiA+DQo+ID4NCj4gVGhlIGlkZWEgaXMgdG8gcmVtb3ZlIHRoZSBjY2lzcyBk
cml2ZXIgY29tcGxldGVseSBvbmNlIHRoZXNlIGNoYW5nZXMgYXJlDQo+IGluLiBQcmVmZXJhYmx5
IHdpdGggdGhlIHNhbWUgcGF0Y2hzZXQgdG8gYXZvaWQgYW55IHRpbWluZyBpc3N1ZXMuDQo+IA0K
PiBDaGVlcnMsDQo+IA0KPiBIYW5uZXMNCj4gLS0NCj4gRHIuIEhhbm5lcyBSZWluZWNrZSAgICAg
ICAgICAgICAgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0d29ya2luZw0KPiBoYXJlQHN1c2UuZGUg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4DQo+IFNV
U0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnDQo+IEdGOiBGLiBJ
bWVuZMO2cmZmZXIsIEouIFNtaXRoYXJkLCBKLiBHdWlsZCwgRC4gVXBtYW55dSwgRy4gTm9ydG9u
DQo+IEhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQ0KDQpPSywgdGhlbiBJIEFDSyB0aGUgc2VyaWVz
IG9uY2UgdGhlIHJldmlld3MgYnkgb3RoZXJzIGhhdmUgYmVlbiByZXNvbHZlZC4NClRoYW5rLXlv
dSBhbmQgIGV2ZXJ5b25lIGVsc2UgZm9yIHlvdXIgcGF0Y2hlcyBhbmQgYXR0ZW50aW9uIHRvIHRo
aXMgaXNzdWUuDQpBbmQgdGhhbmtzIHRvIGV2ZXJ5b25lIGZvciB5b3VyIGlucHV0Lg0KDQpBY2tl
ZC1ieTogRG9uIEJyYWNlIDxkb24uYnJhY2VAbWljcm9zZW1pLmNvbT4NCg0KDQo=
