From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 14/22] qla2xxx: Add interrupt polling mechanism
Date: Thu, 15 Dec 2016 17:12:11 +0000
Message-ID: <40F4DD74-26CF-45E1-A32F-F08B5039B4DF@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-15-git-send-email-himanshu.madhani@cavium.com>
 <20161214210635.GC1011@infradead.org>
 <0ae46bd0-a5f1-c962-2b86-5b95d815095f@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0050.outbound.protection.outlook.com ([104.47.34.50]:23280
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751711AbcLORMP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Dec 2016 12:12:15 -0500
In-Reply-To: <0ae46bd0-a5f1-c962-2b86-5b95d815095f@acm.org>
Content-Language: en-US
Content-ID: <9C49135EFD486B48874789BE712A404E@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SGkgQmFydCwgQ2hyaXN0b3BoLCANCg0KDQoNCk9uIDEyLzE1LzE2LCAxOjI3IEFNLCAiQmFydCBW
YW4gQXNzY2hlIiA8YmFydC52YW5hc3NjaGVAZ21haWwuY29tPiB3cm90ZToNCg0KPk9uIDEyLzE0
LzIwMTYgMTA6MDYgUE0sIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPj4gT24gVHVlLCBEZWMg
MDYsIDIwMTYgYXQgMTI6MzA6NDNQTSAtMDgwMCwgSGltYW5zaHUgTWFkaGFuaSB3cm90ZToNCj4+
PiBGcm9tOiBRdWlubiBUcmFuIDxxdWlubi50cmFuQGNhdml1bS5jb20+DQo+Pj4NCj4+PiBUaGlz
IHBhdGNoIGFkZHMgY2FwYWJpbGl0eSB0byBwb2xsIGZvciBhbiBpbnRlcnJ1cHQsIElmIGhhcmR3
YXJlDQo+Pj4gZG9lcyBub3QgZ2VuZXJhdGUgYW55IGludGVycnVwdCBmb3IgMiBzZWNvbmRzLg0K
Pj4gDQo+PiBUaGlzIGRlc2NyaXB0aW9uIHNvdW5kcyBsaWtlIHRoZSBoYXJkd2FyZSBtaWdodCBi
ZSBidWdneSBhbmQgbm90DQo+PiBnZW5lcmF0ZSBpbnRlcnJ1cHRzLCBpbiB3aGljaCBjYXNlIDIg
c2Vjb25kcyBpcyBhIHZlcnkgbG9uZyB0aW1lLg0KPj4gDQo+PiBDYW4geW91IGV4cGxhaW4gdGhl
IGludGVudGlvbiBhIGJpdCBiZXR0ZXI/DQo+DQo+SW4gYWRkaXRpb24gdG8gQ2hyaXN0b3BoJ3Mg
cXVlc3Rpb246IGlzIHRoaXMgYSB3b3JrYXJvdW5kIGZvciBhIGhhcmR3YXJlDQo+YnVnIG9yIGZv
ciBhIGZpcm13YXJlIGJ1Zz8gSWYgaXQgaXMgYSB3b3JrYXJvdW5kIGZvciBhIGZpcm13YXJlIGJ1
ZywNCj5zaW5jZSB0aGUgcWxhMnh4eCBmaXJtd2FyZSBjYW4gYmUgdXBncmFkZWQsIHdoeSBpcyBh
biBpbnRlcnJ1cHQgcG9sbGluZw0KPm1lY2hhbmlzbSBhZGRlZCB0byB0aGUga2VybmVsIGRyaXZl
ciBpbnN0ZWFkIG9mIGZpeGluZyB0aGUgZmlybXdhcmU/DQo+DQo+QmFydC4NCg0KVGhpcyBpc3N1
ZSB3YXMgc2VlbiB3aGVyZSB3ZSB3ZXJlIGRlYnVnZ2luZyBpbnRlcm1pdHRlbnQgc2xvdyBzd2l0
Y2ggcmVzcG9uc2UNCnJlbGF0ZWQgdG8gY2FibGUgcHVsbCBpbiBhIHNtYWxsIHNldCBvZiB0ZXN0
IGVudmlyb25tZW50LiAgV2UgdGhvdWdodCBpdCB3YXMNCmEgSFcgaXNzdWUgYnV0IHR1cm5zIG91
dCB0byBiZSB0aGUgc3dpdGNoLiAgV2UgbGVmdCB0aGUgcGF0Y2ggaW4gdGhlIHRlc3QNCmN5Y2xl
IHRvIHNlZSBpZiB0aGUgcHJvYmxlbSByZS1vY2N1ciBhbmQgbWlzc2VkIHRha2luZyBpdCBvdXQg
YmVmb3JlIA0Kc3VibWlzc2lvbi4gIFNpbmNlIHRoZW4gd2UgaGF2ZSBub3Qgc2VlbiB0aGUgcHJv
YmxlbSByZS1vY2N1ci4gV2XigJlsbCBkcm9wDQp0aGlzIHBhdGNoIGZyb20gdGhlIHNlcmllcy4g
DQoNCg0KVGhhbmtzLA0KLSBIaW1hbnNodQ0KDQo+DQo=
