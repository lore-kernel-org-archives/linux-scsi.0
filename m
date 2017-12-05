From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v3 1/2] Ensure that the SCSI error handler gets woken up
Date: Tue, 5 Dec 2017 22:59:42 +0000
Message-ID: <1512514780.2660.46.camel@wdc.com>
References: <1512490788.2660.16.camel@wdc.com>
         <sr4inbsihn7krboba8euqqp1.1512508675214@email.android.com>
         <1512510365.2660.35.camel@wdc.com> <5A27228D.1090705@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:5839 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752390AbdLEW7q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 17:59:46 -0500
In-Reply-To: <5A27228D.1090705@virtuozzo.com>
Content-Language: en-US
Content-ID: <39C91A776C2BC8489DBB96B5674A05D2@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "stuart.w.hayes@gmail.com" <stuart.w.hayes@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>

T24gV2VkLCAyMDE3LTEyLTA2IGF0IDAxOjQ5ICswMzAwLCBQYXZlbCBUaWtob21pcm92IHdyb3Rl
Og0KPiBPbiAxMi8wNi8yMDE3IDEyOjQ2IEFNLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4g
QW55d2F5LCB0aGUgZGlmZmVyZW50IHNjZW5hcmlvcyBJIHNlZSBhcmUgYXMgZm9sbG93czoNCj4g
PiAoYSkgc2NzaV9kZWNfaG9zdF9idXN5KCkgZmluaXNoZXMgYmVmb3JlIHNjc2lfZWhfaW5jX2hv
c3RfZmFpbGVkKCkgc3RhcnRzLg0KPiA+IChiKSBzY3NpX2RlY19ob3N0X2J1c3koKSBzdGFydHMg
YWZ0ZXIgc2NzaV9laF9pbmNfaG9zdF9mYWlsZWQoKSBoYXMNCj4gPiAgICAgIGZpbmlzaGVkLg0K
PiANCj4gU28gSSB0aGluayBpbiAoYikgc2NzaV9kZWNfaG9zdF9idXN5IHN0YXJ0cyBhZnRlciBz
Y3NpX2VoX2luY19ob3N0X2ZhaWxlZA0KPiBoYXMgX3N0YXJ0ZWRfLg0KDQpBZ3JlZWQsIGFuZCB0
aGF0J3MgZmluZSwgc2luY2UgaW4gdGhhdCBjYXNlIHRoZSBTQ1NJIGhvc3Qgc3RhdGUgaGFzIGFs
cmVhZCBiZWVuDQptb2RpZmllZCBhbmQgaGVuY2UgYm90aCBmdW5jdGlvbnMgd2lsbCBvYnRhaW4g
dGhlIFNDU0kgaG9zdCBsb2NrLiBUaGUgcmVsZXZhbnQNCmNvZGUgd2lsbCBiZSBzZXJpYWxpemVk
IHRocm91Z2ggdGhlIFNDU0kgaG9zdCBsb2NrLg0KDQo+ID4gSW4gY2FzZSAoYSkgc2NzaV9laF9p
bmNfaG9zdF9mYWlsZWQoKSB3aWxsIHdha2UgdXAgdGhlIGVycm9yIGhhbmRsZXIuIEFuZCBpbg0K
PiA+IGNhc2UgKGIpIHNjc2lfZGVjX2hvc3RfYnVzeSgpIHdpbGwgd2FrZSB1cCB0aGUgZXJyb3Ig
aGFuZGxlci4gU28gaXQncyBub3QNCj4gPiBjbGVhciB0byBtZSB3aHkgeW91IHRoaW5rIHRoYXQg
dGhlcmUgaXMgYSBzY2VuYXJpbyBpbiB3aGljaCB0aGUgRUggd29uJ3QgYmUNCj4gPiB3b2tlbiB1
cD8NCj4gDQo+IFNvIGluIGNhc2UgKGIpLCBpbiBteSB1bmRlcnN0YW5kaW5nLCBzY3NpX2RlY19o
b3N0X2J1c3kgY2FuIHNraXAgd2FrZXVwcyANCj4gYXMgaXQgZG9lcyBub3Qgc2VlIGhvc3RfZmFp
bGVkIGNoYW5nZSB5ZXQuDQoNClRoYXQncyBub3QgY29ycmVjdC4gSWYgc2NzaV9kZWNfaG9zdF9i
dXN5KCkgb2J0YWlucyB0aGUgU0NTSSBob3N0IGxvY2sgYmVmb3JlDQpzY3NpX2VoX2luY19ob3N0
X2ZhaWxlZCgpIG9idGFpbnMgaXQgdGhlbiB0aGUgbGF0dGVyIGZ1bmN0aW9uIHdpbGwgdHJpZ2dl
ciBhDQpTQ1NJIEVIIHdha2V1cC4NCg0KQmFydC4=
