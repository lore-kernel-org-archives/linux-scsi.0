From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 5/5] scsi_debug: add resp_write_scat function
Date: Thu, 14 Dec 2017 22:57:46 +0000
Message-ID: <1513292262.2475.100.camel@sandisk.com>
References: <20171214014016.13142-1-dgilbert@interlog.com>
         <20171214014016.13142-6-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:47817 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754069AbdLNW5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 17:57:50 -0500
In-Reply-To: <20171214014016.13142-6-dgilbert@interlog.com>
Content-Language: en-US
Content-ID: <64F96D1BB761FB4192DB8EB8165374BD@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE3LTEyLTEzIGF0IDIwOjQwIC0wNTAwLCBEb3VnbGFzIEdpbGJlcnQgd3JvdGU6
DQo+ICsJezAsIDB4N2YsIDB4MTEsIEZfU0FfSElHSCB8IEZfRF9PVVQgfCBGRl9NRURJQV9JTywg
cmVzcF93cml0ZV9zY2F0LA0KPiArCSAgICBOVUxMLCB7MzIsICAweGM3LCAwLCAwLCAwLCAwLCAw
eDNmLCAweDE4LCAweDAsIDB4MTEsIDB4ZjgsDQo+ICsJCSAgIDAsIDB4ZmYsIDB4ZmYsIDB4MCwg
MHgwfSB9LAkvKiBXUklURSBTQ0FUVEVSRUQoMzIpICovDQoNCkkga25vdyB0aGlzIGlzIGNvbnNp
c3RlbnQgd2l0aCBvdGhlciBjb21tYW5kIGRlY2xhcmF0aW9ucyBpbiB0aGUgc2NzaV9kZWJ1Zw0K
ZHJpdmVyLCBidXQgaXQgc2VlbXMgd2VpcmQgdG8gbWUgdG8gcmVwb3J0IHRvIHRoZSBpbml0aWF0
b3IgdGhhdCBvbmx5IHNvbWUNCmJpdHMgb2YgdGhlIEFERElUSU9OQUwgQ0RCIExFTkdUSCBmaWVs
ZHMgYXJlIHN1cHBvcnRlZCAoMHgxOCk/IEZyb20gU1BDLTU6DQoNClRoZSBDREIgVVNBR0UgREFU
QSBmaWVsZCBjb250YWlucyBpbmZvcm1hdGlvbiBhYm91dCB0aGUgQ0RCIGZvciB0aGUgY29tbWFu
ZA0KYmVpbmcgcXVlcmllZC4gVGhlIGZpcnN0IGJ5dGUgb2YgdGhlIENEQiBVU0FHRSBEQVRBIGZp
ZWxkIHNoYWxsIGNvbnRhaW4gdGhlDQpvcGVyYXRpb24gY29kZSBmb3IgdGhlIGNvbW1hbmQgYmVp
bmcgcXVlcmllZC4gSWYgdGhlIGNvbW1hbmQgYmVpbmcgcXVlcmllZA0KY29udGFpbnMgYSBzZXJ2
aWNlIGFjdGlvbiwgdGhlbiB0aGF0IHNlcnZpY2UgYWN0aW9uIGNvZGUgc2hhbGwgYmUgcGxhY2Vk
IGluDQp0aGUgQ0RCIFVTQUdFIERBVEEgZmllbGQgaW4gdGhlIHNhbWUgbG9jYXRpb24gYXMgdGhl
IFNFUlZJQ0UgQUNUSU9OIGZpZWxkIG9mDQp0aGUgY29tbWFuZCBDREIuIEFsbCBvdGhlciBieXRl
cyBvZiB0aGUgQ0RCIFVTQUdFIERBVEEgZmllbGQgc2hhbGwgY29udGFpbiBhDQp1c2FnZSBtYXAg
Zm9yIGJpdHMgaW4gdGhlIENEQiBmb3IgdGhlIGNvbW1hbmQgYmVpbmcgcXVlcmllZC4NCiANCj4g
KwlscmRwID0ga3phbGxvYyhsYmRvZl9ibGVuLCBHRlBfQVRPTUlDKTsNCj4gKwlpZiAobHJkcCA9
PSBOVUxMKSB7DQo+ICsJCW1rX3NlbnNlX2J1ZmZlcihzY3AsIElMTEVHQUxfUkVRVUVTVCwgSU5T
VUZGX1JFU19BU0MsDQo+ICsJCQkJSU5TVUZGX1JFU19BU0NRKTsNCj4gKwkJcmV0dXJuIGlsbGVn
YWxfY29uZGl0aW9uX3Jlc3VsdDsNCj4gKwl9DQoNCkl0IHNlZW1zIHdlaXJkIHRvIG1lIHRvIHJl
cG9ydCBhIGZhdGFsIGVycm9yIHRvIHRoZSBpbml0aWF0b3IgaWYgYSBtZW1vcnkNCmFsbG9jYXRp
b24gZmFpbHM/IEkgdGhpbmsgb3RoZXIgU0NTSSBMTERzIHJldHVybiBTQ1NJX01MUVVFVUVfSE9T
VF9CVVNZIGlmIGENCm1lbW9yeSBhbGxvY2F0aW9uIGZhaWxzLg0KDQpUaGFua3MsDQoNCkJhcnQu
