From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v4 4/6] qla2xxx: Add multiple queue pair functionality.
Date: Thu, 8 Dec 2016 19:06:33 +0000
Message-ID: <693AAE59-413D-4416-837A-8E60A7C73455@cavium.com>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
 <1481051266-32362-5-git-send-email-himanshu.madhani@cavium.com>
 <20161207190502.GB29031@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0073.outbound.protection.outlook.com ([104.47.34.73]:49479
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751593AbcLHTGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 14:06:35 -0500
In-Reply-To: <20161207190502.GB29031@infradead.org>
Content-Language: en-US
Content-ID: <7CA0467E9132CE4EA7E408A114F2772B@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SGkgQ2hyaXN0b3BoLA0KDQoNCg0KT24gMTIvNy8xNiwgMTE6MDUgQU0sICJDaHJpc3RvcGggSGVs
bHdpZyIgPGhjaEBpbmZyYWRlYWQub3JnPiB3cm90ZToNCg0KPk9uIFR1ZSwgRGVjIDA2LCAyMDE2
IGF0IDExOjA3OjQ0QU0gLTA4MDAsIEhpbWFuc2h1IE1hZGhhbmkgd3JvdGU6DQo+PiBGcm9tOiBN
aWNoYWVsIEhlcm5hbmRleiA8bWljaGFlbC5oZXJuYW5kZXpAY2F2aXVtLmNvbT4NCj4+IA0KPj4g
UmVwbGFjZWQgZXhpc3RpbmcgbXVsdGlwbGUgcXVldWUgZnVuY3Rpb25hbGl0eSB3aXRoIGZyYW1l
d29yaw0KPj4gdGhhdCBhbGxvd3MgZm9yIHRoZSBjcmVhdGlvbiBvZiBwYWlycyBvZiByZXF1ZXN0
IGFuZCByZXNwb25zZSBxdWV1ZXMsDQo+PiBlaXRoZXIgYXQgc3RhcnQgb2YgZGF5IG9yIGR5bmFt
aWNhbGx5Lg0KPj4gDQo+PiBRdWV1ZSBwYWlyIGNyZWF0aW9uIGRlcGVuZCBvbiBtb2R1bGUgcGFy
YW1ldGVyICJxbDJ4bXFzdXBwb3J0IiwNCj4+IHdoaWNoIG5lZWQgdG8gYmUgZW5hYmxlZCB0byBj
cmVhdGUgcXVldWUgcGFpci4NCj4NCj5UaGlzIGRvZXNuJ3Qgc2VlbSB0byBhZGRyZXNzIGFueSBv
ZiB0aGUgZmVlZGJhY2sgZnJvbSB0aGUgbGFzdA0KPnJvdW5kIG9mIGZlZWRiYWNrLCB3YXMgaXMg
c2VudCBvdXQgYmVmb3JlIHRoYXQ/DQoNCkZvbGxvd2luZyBjaGFuZ2VzIGFyZSBpbmNvcnBvcmF0
ZWQgaW50byBjdXJyZW50IHBhdGNoDQoNCi0gTWVyZ2VkIGNvZGUgZnJvbSBuZXcgZmlsZXMgaW50
byBleGlzdGluZyBjb2RlDQotIEVuYWJsZWQgbXVsdGkgcXVldWUgc3VwcG9ydCBieSBkZWZhdWx0
Lg0KLSBVcGRhdGUgdG8gdXNlIGtjYWxsb2MgaW5zdGVhZCBvZiBremFsbG9jLiANCg0KRm9sbG93
aW5nIHJldmlldyBjb21tZW50cyBhcmUgbm90IGFkZHJlc3NlZCBhcyBwYXJ0IG9mIHRoaXMgcGF0
Y2ggDQoNCi0gVXNpbmcgYml0cy1vcHMgaW5zdGVhZCBvZiB1aW50MzJfdC4NCi0gQ29udmVydGlu
ZyBtYWNyb3MgaW50byBpbmxpbmUgZnVuY3Rpb24uDQotIEZpeGluZyB0aGUgdnJlZiBjb3VudGlu
ZyBpbiB0aGUgZHJpdmVyLg0KLSBVc2luZyB3YWl0IHF1ZXVlIGluc3RlYWQgb2YgYnVzeSB3YWl0
LiANCi0gUmVtb3ZlIGRyaXZlciBhbGxvY2F0ZWQgbWVtcG9vbHMgZm9yIFNSQiBhbmQgdXNlIHRo
ZSBvbmUgcGFzc2VkIGluIHZpYSBjb21tYW5kLiANCg0KVGhlc2UgY2hhbmdlcyBhcmUgZ29pbmcg
dG8gbmVlZCB1cyB0byBydW4gcmVncmVzc2lvbiB0ZXN0cyBhbmQgd291bGQgdGFrZSBiaXQgbG9u
Z2VyLiANCldvdWxkIHlvdSBiZSB3aWxsaW5nIHRvIGFjY2VwdCB0aGlzIHBhdGNoIGFuZCB3ZSB3
aWxsIHBvc3QgdXBkYXRlcyBhcyBuZXcgcGF0Y2ggbGF0ZXIuIA0KDQpUaGFua3MsDQotIEhpbWFu
c2h1DQo=
