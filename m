From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] device_handler: remove VLAs
Date: Mon, 12 Mar 2018 15:41:26 +0000
Message-ID: <1520869285.3469.13.camel@wdc.com>
References: <20180309232933.14e39858@heffalump.sk2.org>
         <20180309223211.20473-1-steve@sk2.org> <1520635688.2907.17.camel@wdc.com>
         <20180310141422.3a8c451f@heffalump.sk2.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180310141422.3a8c451f@heffalump.sk2.org>
Content-Language: en-US
Content-ID: <B0DD18BB1A20EC49A68831DE9DF44737@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "steve@sk2.org" <steve@sk2.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCAyMDE4LTAzLTEwIGF0IDE0OjE0ICswMTAwLCBTdGVwaGVuIEtpdHQgd3JvdGU6DQo+
IFRoZSB0d28gcGF0Y2hlcyBJIHNlbnQgd2VyZSBzdXBwb3NlZCB0byBiZSBhbHRlcm5hdGl2ZSBz
b2x1dGlvbnM7IHNlZQ0KPiBodHRwczovL21hcmMuaW5mby8/bD1saW51eC1zY3NpJm09MTUyMDYz
NjcxMDA1Mjk1Jnc9MiBmb3IgdGhlIGludHJvZHVjdGlvbiAoSQ0KPiBzZWVtIHRvIGhhdmUgbWVz
c2VkIHVwIHRoZSBoZWFkZXJzLCBzbyB0aGUgbWFpbHMgZGlkbuKAmXQgZW5kIHVwIHRocmVhZGVk
DQo+IHByb3Blcmx5KS4NCg0KVGhlIHR3byBwYXRjaGVzIGFycml2ZWQgaW4gbXkgaW5ib3ggc2V2
ZXJhbCBtaW51dGVzIGJlZm9yZSB0aGUgY292ZXIgbGV0dGVyLiBJbg0KdGhlIGUtbWFpbCBoZWFk
ZXIgb2YgdGhlIGNvdmVyIGxldHRlciBJIGZvdW5kIHRoZSBmb2xsb3dpbmc6DQoNClgtR3JleWxp
c3Q6IGRlbGF5ZWQgMTgxMCBzZWNvbmRzIGJ5IHBvc3RncmV5LTEuMjcgYXQgdmdlci5rZXJuZWwu
b3JnOyBGcmksIDA5IE1hciAyMDE4IDE4OjA1OjA4IEVTVA0KDQpEb2VzIHRoaXMgbWVhbiB0aGF0
IHRoZSBkZWxheSBoYXBwZW5lZCBkdWUgdG8gdmdlciBzZXJ2ZXIncyBhbnRpLXNwYW0gYWxnb3Jp
dGhtPw0KDQpCYXJ0Lg0KDQoNCg0K
