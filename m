From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v3 2/6] qla2xxx: Fix mailbox command timeout due to
 starvation
Date: Mon, 5 Dec 2016 18:37:16 +0000
Message-ID: <E9A30DF7-B137-47DB-BAF9-0BE28B6CBB55@cavium.com>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-3-git-send-email-himanshu.madhani@cavium.com>
 <20161205160350.GB11206@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0067.outbound.protection.outlook.com ([104.47.38.67]:10380
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751639AbcLEShS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Dec 2016 13:37:18 -0500
In-Reply-To: <20161205160350.GB11206@infradead.org>
Content-Language: en-US
Content-ID: <B9A24D8EE79D7F4E93D85A37FCFCDC39@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

DQoNCk9uIDEyLzUvMTYsIDg6MDMgQU0sICJDaHJpc3RvcGggSGVsbHdpZyIgPGhjaEBpbmZyYWRl
YWQub3JnPiB3cm90ZToNCg0KPk9uIEZyaSwgRGVjIDAyLCAyMDE2IGF0IDAxOjQ0OjUzUE0gLTA4
MDAsIEhpbWFuc2h1IE1hZGhhbmkgd3JvdGU6DQo+PiBGcm9tOiBTYW15IDxzYW15QHB1cmVzdG9y
YWdlLmNvbT4NCj4+IA0KPj4gVGhpcyBwYXRjaCBoZWxwcyByZXNvbHZlIHNvbWUgb2YgdGhlIG1h
aWxib3ggdGltZW91dCBpc3N1ZSBkaXNjb3ZlcmVkDQo+PiBkdXJpbmcgbGFyZ2UgU0FOIGVtdWxh
dGlvbiB0ZXN0aW5nIHdoZXJlIDEwMDArIGluaXRpYXRvcnMgYXJlIHRyeWluZw0KPj4gdG8gbG9n
IGludG8gdGFyZ2V0IG1vZGUgcGVyc29uYWxpdHkuIFNpbmNlIGN1cnJlbnQgbWFpbGJveCBpbnRl
cmZhY2UNCj4+IGhhbmRsZXMgc3VibWlzc2lvbiBhbmQgcHJvY2Vzc2luZyBvZiBjb21tYW5kcyBp
biBhIHNlcXVlbnRpYWwgb3JkZXIsDQo+PiBjb21tYW5kIGNvdWxkIHRpbWVvdXQgcmVzdWx0aW5n
IGluIHNvbWUgaW5pdGlhdG9yIG5vdCBiZWluZyBhYmxlIHRvDQo+PiBsb2cgaW50byB0YXJnZXQu
DQo+DQo+SG93IGRvZXMgdGhlIHBhdGNoIGhhbmdlIGFueXRoaW5nPyAgWW91J3JlIHN0aWxsIHN5
bmNocm9ub3VzbHkNCj53YWl0aW5nIGZvciB0aGUgY29tbWFuZCwgaXQncyBqdXN0IHRoYXQgdGhl
IGNvbW1hbmQgcHJvY2Vzc2luZw0KPmlzIG9mZmxvYWRlZCB0byBhIHdvcmtxdWV1ZSBub3cuDQoN
ClRoZSBtYWlsYm94IHRpbWVvdXQgd2FzIGlzc3VlIGhlcmUgd2hlcmUgY29tbWFuZCBzdWJtaXR0
ZWQgdG8gbWFpbGJveCBjb3VsZCB3YWl0IA0KZm9yIG1vcmUgdGhhbiB0aW1lIGFsbG93ZWQgdG8g
d2FpdF9mb3JfY29tcGxldGlvbi4gV2XigJlsbCBzZWUgbG90IG9mIG1haWxib3ggdGltZW91dCBp
ZiANCnRoZSBudW1iZXIgb2YgaW5pdGlhdG9ycyB0cnlpbmcgdG8gbG9nIGludG8gdGFyZ2V0IG1v
ZGUgcGVyc29uYWxpdHkgaW5jcmVhc2VzIHRvIGZldw0KdGhvdXNhbmRzLg0KDQo+DQo=
