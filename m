From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v3 1/6] qla2xxx: Only allow operational MBX to proceed
 during RESET.
Date: Mon, 5 Dec 2016 18:36:05 +0000
Message-ID: <9BA73AEA-9D23-48D6-84B1-3E7610930257@cavium.com>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-2-git-send-email-himanshu.madhani@cavium.com>
 <20161205160157.GA11206@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0087.outbound.protection.outlook.com ([104.47.36.87]:46298
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751592AbcLESgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Dec 2016 13:36:07 -0500
In-Reply-To: <20161205160157.GA11206@infradead.org>
Content-Language: en-US
Content-ID: <C42B89438A2B1744951C795CF0963C40@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

DQpPbiAxMi81LzE2LCA4OjAxIEFNLCAiQ2hyaXN0b3BoIEhlbGx3aWciIDxoY2hAaW5mcmFkZWFk
Lm9yZz4gd3JvdGU6DQoNCj5DYW4geW91IGRlc2NyaWJlIHRoZSBjaGFuZ2VzIGluIHRoZSBib2R5
IGEgYml0IG1vcmU/ICBXaHkgZG8geW91DQo+b25seSB3YW50IHRoZXNlIGNvbW1hbmRzIHRvIGJl
IHNlbnQ/ICBXaHkgaXMgdGhlIHdhcm5pbmcgYWRkZWQNCj53aGVuIGl0IHRha2VzIGxvbmdlciB0
aGFuIG5lc3NlY2FyeT8gIE90aGVyd2lzZSB0aGlzIHBhdGNoDQo+bG9va3MgZmluZSB0byBtZS4N
Cg0KVGhpcyBwYXRjaCBpcyBhbGxvd2luZyBvbmx5IFJPTSBtYWlsYm94IGNvbW1hbmQgd2hpY2gg
YXJlIG5lY2Vzc2FyeSB0byBpbml0aWFsaXplDQpjaGlwIGFmdGVyIGEgcmVzZXQgaGFzIGJlZW4g
aXNzdWVkLiBJbiBhIHRhcmdldCBlbnZpcm9ubWVudCwgdGhlcmUgY291bGQgYmUgYSB1c2VyDQpz
cGFjZSBkYWVtb24gd2hpY2ggY2FuIGlzc3VlIHN0YXRpc3RpY3MgYW5kIG90aGVyIG1hbmFnZW1l
bnQgbWFpbGJveCBjb21tYW5kIHdoaWNoDQphcmUgbm9uLWNyaXRpY2FsLiBUaGlzIHBhdGNoIHdp
bGwgdGltZW91dCBub24gY3JpdGljYWwgbWFpbGJveCBjb21tYW5kcyBpbW1lZGlhdGVseQ0KcmF0
aGVyIHRoYW4gd2FpdGluZyBmb3IgdGltZW91dCwgaWYgZHJpdmVyIGRldGVjdHMgdGhhdCBjaGlw
IHJlc2V0IGhhcyBiZWVuIGlzc3VlZCANCm9yIGNoaXAgcmVzZXQgaXMgaW4gcHJvZ3Jlc3MuDQoN
ClRoYW5rcywNCkhpbWFuc2h1DQo+DQo=
