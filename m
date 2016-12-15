From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 08/22] qla2xxx: Refactore target code to remove symbol
 dependency
Date: Thu, 15 Dec 2016 19:29:15 +0000
Message-ID: <8A5A0387-B871-4E64-9439-5C936947E1F8@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-9-git-send-email-himanshu.madhani@cavium.com>
 <20161214211823.GC14133@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0087.outbound.protection.outlook.com ([104.47.41.87]:4013
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752020AbcLOT3S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Dec 2016 14:29:18 -0500
In-Reply-To: <20161214211823.GC14133@infradead.org>
Content-Language: en-US
Content-ID: <E50A57F964BB994B9791F552DBEF6F22@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SGkgQ2hyaXN0b3BoLCANCg0KDQoNCk9uIDEyLzE0LzE2LCAxOjE4IFBNLCAiQ2hyaXN0b3BoIEhl
bGx3aWciIDxoY2hAaW5mcmFkZWFkLm9yZz4gd3JvdGU6DQoNCj4gLSB0aGUgbmV3IHFsYTJ4MDBf
ZnJlZV9mY3BvcnQgaXMgZW50aXJlbHkgcG9pbnRsZXNzLCBwbGVhc2UgZHJvcA0KPiAgIHRoYXQg
cGFydCBvZiB0aGUgcGF0Y2ggKGFuZCBldmVuIGlmIGl0IHdhc24ndCBwb2ludGxlc3MgaXQgc2hv
dWxkDQo+ICAgaGF2ZSBiZWVuIGEgcGF0Y2ggb24gaXQncyBvd24pDQo+IC0gcGxlYXNlIHVzZSBz
dHJ1Y3QgbmFtZXMgYW5kIG5vdCB0eXBlZGVmcyBmb3IgeW91ciBuZXcgc3RydWN0dXJlcw0KPiAt
IHByZXR0eSBtdWNoIGF2ZXJ5IHNpbmdsZSBpdGVtcyBpbiB5b3VyIGxpc3Qgc2hvdWxkIGJlIGEg
c2VwYXJhdGUNCj4gICBwYXRjaC4gIEFuZCBzb21lIG9mIHRoZW0gYXJlIGFjdGl2ZWx5IGNvdW50
ZXJwcm9kdWN0aXZlIGFuZCBzaG91bGQNCj4gICBiZSBkcm9wcGVkOg0KPg0KPiAgICAgICAgLSBS
ZW1vdmUgZGlyZWN0IGFjY2VzcyBvZiBzY3NpX3N0YXR1cyBmaWVsZCBpbiBzZV9jbWQNCj4JLSBS
ZW1vdmUgc2VfY21kIGZyb20gcWx0X2RvX2N0aW9fY29tcGxldGlvbg0KPgktIFJlbW92ZSBzZV9j
bWQgYWNjZXNzIGluIHNyciBjb2RlIHNlY3Rpb24NCj4JLSBNb3ZlIHNlX2NtZCBzdHJ1Y3Qgb3V0
c2lkZSBvZiBxbGFfdGd0X2NtZC9xbGFfdGd0X21nbXRfY21kLg0KDQpXZSBjb21iaW5lZCB0aGUg
cGF0Y2hlcyB3aGljaCBpbmNsdWRlcyBmaXhlcywgZW5oYW5jZW1lbnRzIGFuZCBjbGVhbnVwcyB0
byANClN1cHBvcnQgbXVsdGlwbGUgdGFyZ2V0IHN0YWNrcywgcmV2aWV3cyBmcm9tIGN1c3RvbWVy
LCBhbmQgdG8gaW1wcm92ZSBjb2RlDQptYWludGFpbmFiaWxpdHkuIFRoaXMgcGF0Y2ggdHJpZXMg
dG8gb3JnYW5pemUgY29kZSBsb2dpY2FsbHkgd2hpY2ggaXMgc3ByZWFkDQphY3Jvc3MgcWxhX3Rh
cmdldCBhbmQgdGNtX3FsYTJ4eHguIFdlIHdpbGwgc3BsaXQgdGhpcyBwYXRjaCBpbnRvIG11bHRp
cGxlIA0Kc3Vic2V0IGFuZCByZXN1Ym1pdCB0aGUgc2VyaWVzLiANCg0KVGhhbmtzLCANCi0gSGlt
YW5zaHUNCj4NCg==
