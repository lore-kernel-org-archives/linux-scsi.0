From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv2 0/5] SCSI EH cleanup
Date: Fri, 24 Feb 2017 04:01:25 +0000
Message-ID: <1487908867.2907.3.camel@sandisk.com>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:59288 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdBXECm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 23:02:42 -0500
In-Reply-To: <1487779650-1338-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <649EC787C95E664A87D2B4C341417460@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

T24gV2VkLCAyMDE3LTAyLTIyIGF0IDE3OjA3ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IFByaW1hcnkgZ29hbCBpcyB0byBtYWtlIGFzeW5jaHJvbm91cyBhYm9ydHMgbWFuZGF0b3J5
OyB0aGVyZSBoYXNuJ3QNCj4gYmVlbiBhIHNpbmdsZSByZXBvcnQgc28gZmFyIHdoZXJlIGFzeW5j
aHJvbm91cyBhYm9ydCB3b24ndCB3b3JrLCBzbw0KPiB0aGUgJ25vX2FzeW5jX2Fib3J0JyBmbGFn
IGhhcyBuZXZlciBiZWVuIHVzZWQgYW5kIHdpbGwgYmUgcmVtb3ZlZA0KPiB3aXRoIHRoaXMgcGF0
Y2hzZXQuDQoNCkhlbGxvIEhhbm5lcywNCg0KVGhlcmUgaXMgYSBwcm9ibGVtIHdpdGggYXN5bmNo
cm9ub3VzIGFib3J0cy4gU29tZSBTQ1NJIGRyaXZlcnMsIGUuZy4gaWJfc3JwLA0Kc3VwcG9ydCBm
YXN0IGVycm9yIHJlY292ZXJ5IGJ5IHBlcmZvcm1pbmcgYSB0cmFuc3BvcnQgbGF5ZXIgcmVjb25u
ZWN0IHdpdGhvdXQNCnJlcG9ydGluZyB0aGlzIGV2ZW50IGFzIGEgZmFpbHVyZSB0byB0aGUgU0NT
SSBjb3JlLiBXaGlsZSBzdWNoIGEgcmVjb25uZWN0IGlzDQpvbmdvaW5nIGl0IGlzIGltcG9ydGFu
dCB0aGF0IG5vIGF0dGVtcHQgaXMgbWFkZSB0byB1c2UgdGhlIGRhdGEgc3RydWN0dXJlcw0KdGhh
dCByZXByZXNlbnQgdGhlIGNvbm5lY3Rpb24uIEhlbmNlIHRoZcKgc2NzaV90YXJnZXRfYmxvY2so
KSBjYWxsIGluDQpzcnBfcmVjb25uZWN0X3Jwb3J0KCkuIFRoaXMgYmxvY2tzIG1vc3QgLnF1ZXVl
Y29tbWFuZCgpIGNhbGxzIGV4Y2VwdCB0aG9zZQ0KdGhhdCBvcmlnaW5hdGUgZnJvbSB0aGUgU0NT
SSBFSC4gSGVuY2UgdGhlIGlmIChjdXJyZW50ID09IHNob3N0LT5laGFuZGxlcikNCm11dGV4X2xv
Y2soJnJwb3J0LT5tdXRleCkgY29kZSBpbiBzcnBfcXVldWVjb21tYW5kKCkuIEFzeW5jaHJvbm91
cyBhYm9ydHMNCmJyZWFrIHRoaXMgY29kZSBiZWNhdXNlIHRoZSBhc3luY2hyb25vdXMgYWJvcnQg
Y29kZSBzdWJtaXRzIGFuIGFib3J0IGZyb20NCmFub3RoZXIgY29udGV4dCB0aGFuIHRoZSBTQ1NJ
IEVIIHRocmVhZC4gSSBrbm93IHRoYXQgdGhpcyB3YXkgb2YgZGV0ZWN0aW5nDQp0aGUgU0NTSSBF
SCBjb250ZXh0IGlzIG5vdCBhbiBvcHRpbWFsIHNvbHV0aW9uLiBBIGZldyB5ZWFycyBhZ28gSSBo
YXZlIHRyaWVkDQp0byBtb2RpZnkgdGhlIFNDU0kgRUggc3VjaCB0aGF0IHJlY29ubmVjdHMgYW5k
IC5xdWV1ZWNvbW1hbmQoKSBjYWxscyBjb3VsZA0KYmUgc2VyaWFsaXplZCBidXQgSmFtZXMgd2Fz
IG5vdCBpbnRlcmVzdGVkIGluIHN1Y2ggcGF0Y2hlcyBhdCB0aGF0IHRpbWUuDQoNCkJhcnQu
