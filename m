From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi_debug: implement IMMED bit
Date: Wed, 31 Jan 2018 22:05:15 +0000
Message-ID: <1517436314.7325.6.camel@wdc.com>
References: <20180130055445.20244-1-dgilbert@interlog.com>
         <ed3a63f0-2cbb-8fac-fee7-4f08b1e1e8e2@wdc.com>
         <a59aa2e7-fa26-6e24-9e79-5a14307fb49a@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41753 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753295AbeAaWFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2018 17:05:18 -0500
In-Reply-To: <a59aa2e7-fa26-6e24-9e79-5a14307fb49a@interlog.com>
Content-Language: en-US
Content-ID: <9622C1602792A248B4E9E8E6ABD0197E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE4LTAxLTMxIGF0IDE1OjI2IC0wNTAwLCBEb3VnbGFzIEdpbGJlcnQgd3JvdGU6
DQo+IE9uIDIwMTgtMDEtMzEgMTI6MDYgUE0sIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gPiBP
biAwMS8yOS8xOCAyMTo1NCwgRG91Z2xhcyBHaWxiZXJ0IHdyb3RlOg0KPiA+ID4gK3N0YXRpYyBj
b25zdCBzdHJ1Y3Qgb3Bjb2RlX2luZm9fdCBzeW5jX2NhY2hlX2lhcnJbXSA9IHsNCj4gPiA+ICsg
ICAgezAsIDB4OTEsIDAsIEZfTE9OR19ERUxBWSB8IEZfTV9BQ0NFU1MsIHJlc3Bfc3luY19jYWNo
ZSwgTlVMTCwNCj4gPiA+ICsgICAgICAgIHsxNiwgIDB4NywgMHhmZiwgMHhmZiwgMHhmZiwgMHhm
ZiwgMHhmZiwgMHhmZiwgMHhmZiwgMHhmZiwNCj4gPiANCj4gPiAgICAgICAgICAgICAgICAgICAg
Xl5eDQo+ID4gQ2FuIHlvdSBjbGFyaWZ5IHRoZSBjaG9pY2Ugb2YgIjB4NyIgaW4gdGhlIGFib3Zl
PyBBZnRlciBoYXZpbmcgaGFkIGEgbG9vayBhdCANCj4gPiBTQkMtNCBJIHdhcyBleHBlY3Rpbmcg
MHgyICh0aGUgbWFzayBmb3IgdGhlIElNTUVEIGJpdCkgc2luY2UgYWxsIG90aGVyIGJpdHMgaW4g
DQo+ID4gdGhhdCBjb21tYW5kIGJ5dGUgYXJlIGVpdGhlciByZXNlcnZlZCBvciBvYnNvbGV0ZS4N
Cj4gDQo+IEFzIGEgZ2VuZXJhbCBydWxlIHdoZW4geW91IHNlZSAib2Jzb2xldGUiIHRoYXQgbWVh
bnMgdGhhdCBmaWVsZCB3YXMgdXNlZA0KPiBpbiBhbiBlYXJsaWVyIHN0YW5kYXJkIChiaXQgMCB3
YXMgUkVMQUREUiBhbmQgYml0IDIgd2FzIFNZTkNfTlYpLiBTbw0KPiBhcHBsaWNhdGlvbiBjbGll
bnRzIGNvbXBseWluZyB3aXRoIGVhcmxpZXIgdmVyc2lvbnMgb2YgU0JDIG1pZ2h0IHNldCB0aG9z
ZQ0KPiBiaXRzLiBJZiB0aGV5IGFyZSBzZXQgYW5kIHRoZSBtYXNrIGlzIGJlaW5nIGVuZm9yY2Vk
IEkgY2hvb3NlIHRvIG5vdCBmYWlsDQo+IHRoZSBjb21tYW5kIGFzIGFuIGlsbGVnYWwgcmVxdWVz
dC4gQmFzaWNhbGx5IGFjY2VwdCBhbmQgaWdub3JlLg0KDQpJIGFncmVlIHdpdGggc2V0dGluZyBi
aXRzIGZvciBvYnNvbGV0ZSBmbGFncy4gVGhlIHJlYXNvbiBJIHdhcyBhc2tpbmcgYWJvdXQgdGhh
dA0KbWFzayBpcyBiZWNhdXNlIEkgZm91bmQgdGhlIGZvbGxvd2luZyBpbiBTQkMtNCBmb3IgYnl0
ZSAxIG9mIFNZTkNIUk9OSVpFIENBQ0hFKDE2KToNCiogQml0cyA3Li4zOiByZXNlcnZlZC4NCiog
Qml0IDI6IG9ic29sZXRlLg0KKiBCaXQgMTogSU1NRUQuDQoqIEJpdCAwOiByZXNlcnZlZC4NCg0K
PiA+ID4gLSAgICByZXR1cm4gMDsNCj4gPiA+ICsgICAgcmV0dXJuIChjbWRbMV0gJiAweDEpID8g
U0RFR19SRVNfSU1NRURfTUFTSyA6IDA7IC8qIGNoZWNrIElNTUVEIGJpdCAqLw0KPiA+IA0KPiA+
IFNob3VsZG4ndCB0aGUgbWFzayAweDIgYmUgdXNlZCB0byBjaGVjayBmb3IgdGhlIElNTUVEIGJp
dD8NCj4gDQo+IFRoYXQgY29tbWVudCBuZWVkcyBhIGxpdHRsZSBtb3JlIGNvbnRleHQ6DQoNClNv
cnJ5LCBJIGNvbmZ1c2VkIGJ5dGUgMSBvZiB0aGUgU1RBUlQgU1RPUCBjb21tYW5kIHdpdGggdGhh
dCBvZiB0aGUgU1lOQ0hST05JWkUNCkNBQ0hFIGNvbW1hbmQgc28gcGxlYXNlIGlnbm9yZSB0aGUg
YWJvdmUgY29tbWVudC4NCg0KQmFydC4=
