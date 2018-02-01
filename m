From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] qedi: Fix truncation of name and secret
Date: Thu, 1 Feb 2018 15:59:46 +0000
Message-ID: <1517500776.2746.11.camel@wdc.com>
References: <20180201065734.20441-1-nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58732 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751722AbeBAP7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 10:59:50 -0500
In-Reply-To: <20180201065734.20441-1-nilesh.javali@cavium.com>
Content-Language: en-US
Content-ID: <3E01F990F830A04F9AAEA62A85DBB7B7@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "nilesh.javali@cavium.com" <nilesh.javali@cavium.com>, "lduncan@suse.com" <lduncan@suse.com>, "cleech@redhat.com" <cleech@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>

T24gV2VkLCAyMDE4LTAxLTMxIGF0IDIyOjU3IC0wODAwLCBOaWxlc2ggSmF2YWxpIHdyb3RlOg0K
PiBBZGp1c3QgdGhlIE5VTEwgYnl0ZSBhZGRlZCBieSBzbnByaW50Zi4NCg0KSGVsbG8gTmlsZXNo
LA0KDQpTb3JyeSBidXQgbmVpdGhlciB0aGUgdGl0bGUgbm9yIHRoZSBkZXNjcmlwdGlvbiBvZiB0
aGlzIHBhdGNoIG1ha2UgY2xlYXIgd2hhdA0KdGhlIGludGVudGlvbiBvZiB0aGlzIHBhdGNoIGlz
LiBQbGVhc2UgZGVzY3JpYmUgdGhpcyBtb3JlIGNsZWFybHkuDQoNCj4gQEAgLTE4NDAsNyArMTg0
MCw3IEBAIHN0YXRpYyBzc2l6ZV90IHFlZGlfc2hvd19ib290X2luaV9pbmZvKHZvaWQgKmRhdGEs
IGludCB0eXBlLCBjaGFyICpidWYpDQo+ICANCj4gIAlzd2l0Y2ggKHR5cGUpIHsNCj4gIAljYXNl
IElTQ1NJX0JPT1RfSU5JX0lOSVRJQVRPUl9OQU1FOg0KPiAtCQlyYyA9IHNucHJpbnRmKHN0ciwg
TlZNX0lTQ1NJX0NGR19JU0NTSV9OQU1FX01BWF9MRU4sICIlc1xuIiwNCj4gKwkJcmMgPSBzbnBy
aW50ZihzdHIsIE5WTV9JU0NTSV9DRkdfSVNDU0lfTkFNRV9NQVhfTEVOICsgMSwgIiVzIiwNCj4g
IAkJCSAgICAgIGluaXRpYXRvci0+aW5pdGlhdG9yX25hbWUuYnl0ZSk7DQo+ICAJCWJyZWFrOw0K
PiAgCWRlZmF1bHQ6DQoNClRoZSBmdW5jdGlvbiBxZWRpX3Nob3dfYm9vdF9pbmlfaW5mbygpIGlz
IHVzZWQgdG8gZXhwb3J0IGluZm9ybWF0aW9uIHRocm91Z2gNCnN5c2ZzLiBVc2VycyBleHBlY3Qg
QVNDSUkgZGF0YSBpbiBzeXNmcyB0byBiZSB0ZXJtaW5hdGVkIHdpdGggYSBuZXdsaW5lLiBTbyBJ
DQp0aGluayByZW1vdmluZyB0aGUgdHJhaWxpbmcgbmV3bGluZSBpcyB3cm9uZy4gQWRkaXRpb25h
bGx5LCBhbiBleHBsYW5hdGlvbiBvZg0Kd2h5IHlvdSB0aGluayB0aGF0IHRoZSBzZWNvbmQgYXJn
dW1lbnQgb2YgdGhlIHNucHJpbnRmKCkgY2FsbCBzaG91bGQgYmUNCmluY3JlYXNlZCBpcyBtaXNz
aW5nLiBBbmQgc2luY2UgYnVmIHBvaW50cyBhdCBhIGJ1ZmZlciBvZiBzaXplIFBBR0VfU0laRSwN
CmhhdmUgeW91IGNvbnNpZGVyIHRvIGNoYW5nZSB0aGUgc2Vjb25kIHNucHJpbnRmKCkgYXJndW1l
bnQgaW50byBQQUdFX1NJWkU/DQoNClRoYW5rcywNCg0KQmFydC4=
