From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 03/25] qla2xxx: Allow ABTS RX, RIDA on ATIOQ for
 ISP83XX/27XX
Date: Mon, 22 May 2017 17:35:15 +0000
Message-ID: <07A12D60-BAA3-4A40-8124-DC8A41BABCEF@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
 <20170519215344.2168-4-himanshu.madhani@cavium.com>
 <1495233728.2581.8.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0043.outbound.protection.outlook.com ([104.47.41.43]:2593
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1760367AbdEVRfR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 May 2017 13:35:17 -0400
In-Reply-To: <1495233728.2581.8.camel@sandisk.com>
Content-Language: en-US
Content-ID: <93F3E33FE12AE94AB13BF87C32F4198A@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SGkgQmFydCwgDQoNCj4gT24gTWF5IDE5LCAyMDE3LCBhdCAzOjQyIFBNLCBCYXJ0IFZhbiBBc3Nj
aGUgPGJhcnQudmFuYXNzY2hlQHNhbmRpc2suY29tPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwgMjAx
Ny0wNS0xOSBhdCAxNDo1MyAtMDcwMCwgSGltYW5zaHUgTWFkaGFuaSB3cm90ZToNCj4+IEZyb206
IFF1aW5uIFRyYW4gPHF1aW5uLnRyYW5AY2F2aXVtLmNvbT4NCj4+IA0KPj4gQWxsb3cgQUJUUyBS
WCwgUklEQSB0byBiZSBtb3ZlZCB0byBBVElPIFF1ZXVlIG9ubHkgZm9yDQo+PiBJU1A4M1hYIGFu
ZCBJU1AyN1hYLg0KPiANCj4gSGVsbG8gSGltYW5zaHUsDQo+IA0KPiBTb3JyeSBidXQgdGhpcyBk
ZXNjcmlwdGlvbiBzb3VuZHMgcmF0aGVyIG15c3RlcmlvdXMgdG8gbWU/DQo+IA0KPiBCYXJ0Lg0K
DQp3ZSBoYWQgYWRkZWQgbW9kdWxlIHBhcmFtZXRlciDigJwgcWwyeG12YXN5bmN0b2F0aW/igJ0g
YXMgcGFydCBvZiB0aGUgSW1wcm92ZSBSU0NOIGhhbmRsaW5nIHBhdGNoIA0KaHR0cHM6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2Nv
bW1pdC9kcml2ZXJzL3Njc2kvcWxhMnh4eD9pZD00MWRjNTI5YTQ2MDJhYzczNzAyMGY0MjNmODQ2
ODZhODFkZTM4ZTZkDQoNCkF0IHRoZSB0aW1lIHdoZW4gd2Ugc3VibWl0dGVkIHBhdGNoLCB3ZSB3
ZXJlIHNldHRpbmcgYml0IGZvciBhbGwgSVNQcyB3aGljaCBpcyBub3QgY29ycmVjdC4gT25seSBJ
U1A4M1hYLzI3WFggc2hvdWxkIGJlIGFsbG93ZWQgdG8gc2V0IHRoaXMgYml0LiANCg0KU2V0dGlu
ZyB0aGlzIEJpdCB3aWxsIGFsbG93IGZpcm13YXJlIHRvIHBvc3QgQUJUUy9QVVJFWC9SSURBIElP
Q0LigJlzIHZpYSBBVElPIHF1ZXVlIG9ubHkgd2hlbiB0YXJnZXQvZHVhbCBtb2RlIGlzIG9wZXJh
dGlvbmFsLg0KDQpUaGFua3MsDQotIEhpbWFuc2h1DQoNCg==
