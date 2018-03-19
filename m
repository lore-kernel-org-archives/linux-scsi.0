From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] Change synchronize_rcu() in scsi_device_quiesce() into
 synchronize_sched()
Date: Mon, 19 Mar 2018 15:16:07 +0000
Message-ID: <1521472566.2776.6.camel@wdc.com>
References: <20180316173516.3048-1-bart.vanassche@wdc.com>
         <20180319143147.GF2943022@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180319143147.GF2943022@devbig577.frc2.facebook.com>
Content-Language: en-US
Content-ID: <85970B965A45674B9F57CC3C86CA8BC1@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "tj@kernel.org" <tj@kernel.org>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin@lichtvoll.de" <martin@lichtvoll.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE4LTAzLTE5IGF0IDA3OjMxIC0wNzAwLCBUZWp1biBIZW8gd3JvdGU6DQo+IE9u
IEZyaSwgTWFyIDE2LCAyMDE4IGF0IDEwOjM1OjE2QU0gLTA3MDAsIEJhcnQgVmFuIEFzc2NoZSB3
cm90ZToNCj4gPiBTaW5jZSBibGtfcXVldWVfZW50ZXIoKSB1c2VzIHJjdV9yZWFkX2xvY2tfc2No
ZWQoKSBzY3NpX2RldmljZV9xdWllc2NlKCkNCj4gPiBtdXN0IHVzZSBzeW5jaHJvbml6ZV9zY2hl
ZCgpLg0KPiANCj4gSXMgdGhlcmUgYSByZWFzb24gdG8gdXNlIHNjaGVkLVJDVSBoZXJlIGluc3Rl
YWQgb2YgdGhlIHJlZ3VsYXIgb25lPw0KPiBJZiBub3QsIGl0J2QgYmUgYmV0dGVyIHRvIHN3aXRj
aCB0byByZWd1bGFyIFJDVSB0aGFuIHRoZSBvdGhlciB3YXkNCj4gYXJvdW5kLg0KDQpIZWxsbyBU
ZWp1biwNCg0KQXMgZXhwbGFpbmVkIGluIHRoZSBjb21tZW50IGluIHNjc2lfZGV2aWNlX3F1aWVz
Y2UoKSwgdGhlIGVmZmVjdCBvZg0KYmxrX3NldF9wcmVlbXB0X29ubHkoKSBtdXN0IGJlIHZpc2li
bGUgZm9yIHBlcmNwdV9yZWZfdHJ5Z2V0KCkgY2FsbHMgdGhhdA0Kb2NjdXIgYWZ0ZXIgdGhlIHF1
ZXVlIHVuZnJlZXplIHRyaWdnZXJlZCBieSBzY3NpX2RldmljZV9xdWllc2NlKCkuIEhlbmNlIHRo
ZQ0KUkNVIHJlYWQgbG9jayBjYWxscyBpbiBibGtfcXVldWVfZW50ZXIoKS4gU2luY2UgdGhlc2Ug
UkNVIHJlYWQgbG9jayBjYWxscw0Kc3Vycm91bmQgYSBmdW5jdGlvbiBjYWxsIHRoYXQgdXNlcyBy
Y3VfcmVhZF9sb2NrX3NjaGVkKCksIG5hbWVseQ0KcGVyY3B1X3JlZl90cnlnZXRfbGl2ZSgpLCB3
ZSBoYXZlIHRvIHVzZSBzY2hlZC1SQ1UgaW4gYm90aCBibGtfcXVldWVfZW50ZXIoKQ0KYW5kIHNj
c2lfZGV2aWNlX3F1aWVzY2UoKS4NCg0KQmFydC4NCg0KDQoNCg==
