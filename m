From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 06/12] scsi: sd_zbc: Rearrange code
Date: Fri, 15 Sep 2017 21:02:22 +0000
Message-ID: <1505509340.2417.18.camel@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
         <20170915100645.17999-7-damien.lemoal@wdc.com>
         <1505487062.2852.12.camel@wdc.com> <20170915175117.GG8578@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:4899 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdIOVDM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 17:03:12 -0400
In-Reply-To: <20170915175117.GG8578@lst.de>
Content-Language: en-US
Content-ID: <EBA56F0391301C4CBCBAB5083F747D97@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>

T24gRnJpLCAyMDE3LTA5LTE1IGF0IDE5OjUxICswMjAwLCBoY2hAbHN0LmRlIHdyb3RlOg0KPiBP
biBGcmksIFNlcCAxNSwgMjAxNyBhdCAwMjo1MTowM1BNICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUg
d3JvdGU6DQo+ID4gT24gRnJpLCAyMDE3LTA5LTE1IGF0IDE5OjA2ICswOTAwLCBEYW1pZW4gTGUg
TW9hbCB3cm90ZToNCj4gPiA+IFJlYXJyYW5nZSBzZF96YmNfc2V0dXAoKSB0byBpbmNsdWRlIHVz
ZV8xNl9mb3JfcncgYW5kIHVzZV8xMF9mb3JfcncNCj4gPiA+IGFzc2lnbm1lbnRzIGFuZCBtb3Zl
IHRoZSBjYWxjdWxhdGlvbiBvZiBzZGtwLT56b25lX3NoaWZ0IHRvZ2V0aGVyDQo+ID4gPiB3aXRo
IHRoZSBhc3NpZ25tZW50IG9mIHRoZSB2ZXJpZmllZCB6b25lX2Jsb2NrcyB2YWx1ZSBpbg0KPiA+
ID4gc2RfemJjX2NoZWNrX3pvbmVfc2l6ZSgpLg0KPiA+IA0KPiA+IEJvdGggZnVuY3Rpb25zIGFy
ZSBjYWxsZWQgZnJvbSBpbnNpZGUgYmxvY2tfZGV2aWNlX29wZXJhdGlvbnMucmV2YWxpZGF0ZV9k
aXNrLg0KPiA+IElzbid0IHRoYXQgdG9vIGxhdGUgdG8gc2V0IHVzZV8xWzA2XV9mb3Jfcnc/IFNo
b3VsZG4ndCBib3RoIGJlIHNldCBqdXN0IGFmdGVyDQo+ID4gdGhlIHNsYXZlX2FsbG9jIGNhbGxi
YWNrIGhhcyBiZWVuIGNhbGxlZD8NCj4gDQo+IEhtbS4gIHNkX3JlYWRfY2FwYWNpdHkgYWxyZWFk
eSBpcyBjYWxsZWQgZnJvbSB0aGUgc2FtZSBwYXRoIGFuZCBzZWVtcw0KPiB0byB3b3JrLi4NCg0K
SGVsbG8gQ2hyaXN0b3BoLA0KDQpNeSBjb25jZXJuIGlzIHRoYXQgaWYgYm90aCBhIFNDU0kgTExE
IGFuZCB0aGUgWkJDIGNvZGUgc2V0IHVzZV8xWzA2XV9mb3JfcncNCnRoYXQgdGhlc2Ugc2V0dGlu
Z3MgbWF5IGNvbmZsaWN0LiBTaG91bGQgdGhlIFpCQyBjb2RlIGUuZy4gcmVmdXNlIHRoYXQgdGhl
IHNkDQpkcml2ZXIgaXMgYXR0YWNoZWQgdG8gYSBaQkMgZGlzayBjb250cm9sbGVkIGJ5IGEgU0NT
SSBMTEQgdGhhdCBzdXBwb3J0cw0KdXNlXzEwX2Zvcl9ydyBidXQgbm90IHVzZV8xNl9mb3Jfcnc/
DQoNClRoYW5rcywNCg0KQmFydC4=
