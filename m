From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: RE: [PATCH] scsi_dh_alua: Add module parameter to allow failover to
 non preferred path without STPG
Date: Mon, 1 Apr 2013 21:18:59 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF21FF95717@SACEXCMBX04-PRD.hq.netapp.com>
References: <8255ED565A0EAA4A960625E27D49DBF21FF906FB@SACEXCMBX04-PRD.hq.netapp.com>
 <1364826280.3828.120.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:18769 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523Ab3DAVTC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Apr 2013 17:19:02 -0400
In-Reply-To: <1364826280.3828.120.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.de" <hare@suse.de>

SG93IGFib3V0IHRoZSBmb2xsb3dpbmc/ICBSZXdvcmRlZCBpbiBhIHdheSBzdWNoIHRoYXQgMCBt
ZWFucyBubyBhbmQgMSBtZWFucyB5ZXMuDQoNCitzdGF0aWMgdWludCBvcHRpbWl6ZV9zdHBnOw0K
K21vZHVsZV9wYXJhbShvcHRpbWl6ZV9zdHBnLCB1aW50LCBTX0lSVUdPfFNfSVdVU1IpOyANCitN
T0RVTEVfUEFSTV9ERVNDKG9wdGltaXplX3N0cGcsICJBbGxvdyB1c2Ugb2YgYSBub24tb3B0aW1p
emVkIHBhdGgsIHJhdGhlciB0aGFuIHNlbmRpbmcgYSBTVFBHLCB3aGVuIGltcGxpY2l0IFRQR1Mg
aXMgc3VwcG9ydGVkICgwPU5vLDE9WWVzKS4gRGVmYXVsdCBpcyAwLiIpOw0KDQoNClRoYW5rcywN
ClNlYW4gU3Rld2FydA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogRXdhbiBN
aWxuZSBbbWFpbHRvOmVtaWxuZUByZWRoYXQuY29tXSANClNlbnQ6IE1vbmRheSwgQXByaWwgMDEs
IDIwMTMgOToyNSBBTQ0KVG86IFN0ZXdhcnQsIFNlYW4NCkNjOiBsaW51eC1zY3NpQHZnZXIua2Vy
bmVsLm9yZzsgZG0tZGV2ZWxAcmVkaGF0LmNvbTsgSmFtZXMuQm90dG9tbGV5QHN1c2UuZGU7IHNu
aXR6ZXJAcmVkaGF0LmNvbTsgaGFyZUBzdXNlLmRlDQpTdWJqZWN0OiBSZTogW1BBVENIXSBzY3Np
X2RoX2FsdWE6IEFkZCBtb2R1bGUgcGFyYW1ldGVyIHRvIGFsbG93IGZhaWxvdmVyIHRvIG5vbiBw
cmVmZXJyZWQgcGF0aCB3aXRob3V0IFNUUEcNCg0KT24gVGh1LCAyMDEzLTAzLTI4IGF0IDIyOjA3
ICswMDAwLCBTdGV3YXJ0LCBTZWFuIHdyb3RlOg0KPiArc3RhdGljIHVpbnQgb3B0aW1pemVfc3Rw
ZzsNCj4gK21vZHVsZV9wYXJhbShvcHRpbWl6ZV9zdHBnLCB1aW50LCBTX0lSVUdPfFNfSVdVU1Ip
OyANCj4gK01PRFVMRV9QQVJNX0RFU0Mob3B0aW1pemVfc3RwZywgIlNlbmQgU1RQRyBjb21tYW5k
IGZvciBGYWlsb3ZlciBvbiANCj4gK25vbi1wcmVmZXJyZWQgcGF0aCgwPVllcywxPU5vKS4gRGVm
YXVsdCBpcyAwLiIpOw0KDQpDb3VsZCB5b3UgcG9zc2libHkgcmV3b3JkIHRoZSBkZXNjcmlwdGlv
bj8gIFdoZW4gSSBmaXJzdCByZWFkIHRoaXMsIGl0IHNlZW1lZCBiYWNrd2FyZHMgdG8gaGF2ZSAw
PVllcyBhbmQgMT1Oby4NCg0KLUV3YW4gRC4gTWlsbmUgPGVtaWxuZUByZWRoYXQuY29tPg0KDQoN
Cg0K
