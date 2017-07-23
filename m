From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: 4.12 NULL pointer dereference in kmem_cache_free on USB storage
 removal
Date: Sun, 23 Jul 2017 03:08:22 +0000
Message-ID: <1500779301.3155.1.camel@wdc.com>
References: <726b4c5d-610d-4d74-28e3-bfbc4fad06e0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:38821 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752080AbdGWDJK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Jul 2017 23:09:10 -0400
In-Reply-To: <726b4c5d-610d-4d74-28e3-bfbc4fad06e0@gmail.com>
Content-Language: en-US
Content-ID: <23CD1309BB4AF643878C0445806B24D1@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yagmur.oymak@gmail.com" <yagmur.oymak@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gU2F0LCAyMDE3LTA3LTIyIGF0IDExOjU4ICswMzAwLCBZYWdtdXIgT3ltYWsgd3JvdGU6DQo+
IFRoaXMgcHJvYmxlbSB3YXMgcmVwb3J0ZWQgaW4gdGhlIGxpbnV4LWtlcm5lbCBsaXN0LCBoZXJl
Og0KPiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAxNy83LzEzLzcxMCwgYW5kIGl0IGlzIHNhaWQg
dGhhdCBjb21taXQNCj4gOGU2ODgyNTQ1ZDhjICgic2NzaTogQXZvaWQNCj4gdGhhdCBzY3NpX2V4
aXRfcnEoKSB0cmlnZ2VycyBhIHVzZS1hZnRlci1mcmVlIikgZml4ZXMgaXQuIEl0IGluZGVlZA0K
PiBmaXhlcyBpdCBhcyB0aGUgcHJvYmxlbSBkb2VzIG5vdCBleGlzdCBvbiA0LjEzLXJjMSAod2hp
Y2ggaW5jbHVkZXMgdGhlDQo+IGNvbW1pdCkgYW5kIG9uIDQuMTIueCBpZiB0aGUgcGF0Y2ggaXMg
YXBwbGllZC4gSG93ZXZlciwgbm9uZSBvZiB0aGUgNC4xMg0KPiByZWxlYXNlcyBzaW5jZSB0aGF0
IGRpc2N1c3Npb24gaW5jbHVkZXMgdGhlIHBhdGNoLCBzbyB0aGUgcHJvYmxlbSBpcw0KPiBzdGls
bCB0aGVyZS4gQ2FuIHRoYXQgYmUgaW5jbHVkZWQgaW4gdGhlIG5leHQgc3RhYmxlIHJlbGVhc2U/
DQoNCigrR3JlZykNCg0KSGkgR3JlZywNCg0KSXQgc2VlbXMgdG8gbWUgbGlrZSB0aGF0IGNvbW1p
dCBoYXMgbm90IGJlZW4gaW5jbHVkZWQgaW4ga2VybmVsIHY0LjEyLjM/DQpXaWxsIGl0IGJlIGlu
Y2x1ZGVkIGluIGEgbGF0ZXIgc3RhYmxlIHY0LjEyLngga2VybmVsPw0KDQpUaGFua3MsDQoNCkJh
cnQu
