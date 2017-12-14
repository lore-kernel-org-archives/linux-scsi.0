From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 2/5] scsi_debug: fix group_number mask
Date: Thu, 14 Dec 2017 22:26:48 +0000
Message-ID: <1513290406.2475.90.camel@sandisk.com>
References: <20171214014016.13142-1-dgilbert@interlog.com>
         <20171214014016.13142-3-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:3959 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753718AbdLNW0v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 17:26:51 -0500
In-Reply-To: <20171214014016.13142-3-dgilbert@interlog.com>
Content-Language: en-US
Content-ID: <8CA7AE7BA3C29649862CDDE3A6B94E62@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE3LTEyLTEzIGF0IDIwOjQwIC0wNTAwLCBEb3VnbGFzIEdpbGJlcnQgd3JvdGU6
DQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IG9wY29kZV9pbmZvX3QgcmVzZXJ2ZV9pYXJyWzFdID0g
ew0KPiBAQCAtNTA4LDExICs1MDgsMTEgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBvcGNvZGVfaW5m
b190IG9wY29kZV9pbmZvX2FycltTREVCX0lfTEFTVF9FTEVNRU5UICsgMV0gPSB7DQo+ICAJICAg
ICAwLCAwfSB9LA0KPiAgCXszLCAweDg4LCAwLCBGX0RfSU4gfCBGRl9ESVJFQ1RfSU8sIHJlc3Bf
cmVhZF9kdDAsIHJlYWRfaWFyciwNCj4gIAkgICAgezE2LCAgMHhmZSwgMHhmZiwgMHhmZiwgMHhm
ZiwgMHhmZiwgMHhmZiwgMHhmZiwgMHhmZiwgMHhmZiwgMHhmZiwNCj4gLQkgICAgIDB4ZmYsIDB4
ZmYsIDB4ZmYsIDB4OWYsIDB4Yzd9IH0sCQkvKiBSRUFEKDE2KSAqLw0KPiArCSAgICAgMHhmZiwg
MHhmZiwgMHhmZiwgMHhmZiwgMHhjN30gfSwJCS8qIFJFQUQoMTYpICovDQo+ICAvKiAxMCAqLw0K
PiAgCXszLCAweDhhLCAwLCBGX0RfT1VUIHwgRkZfRElSRUNUX0lPLCByZXNwX3dyaXRlX2R0MCwg
d3JpdGVfaWFyciwNCj4gIAkgICAgezE2LCAgMHhmYSwgMHhmZiwgMHhmZiwgMHhmZiwgMHhmZiwg
MHhmZiwgMHhmZiwgMHhmZiwgMHhmZiwgMHhmZiwNCj4gLQkgICAgIDB4ZmYsIDB4ZmYsIDB4ZmYs
IDB4OWYsIDB4Yzd9IH0sCQkvKiBXUklURSgxNikgKi8NCj4gKwkgICAgIDB4ZmYsIDB4ZmYsIDB4
ZmYsIDB4ZmYsIDB4Yzd9IH0sCQkvKiBXUklURSgxNikgKi8NCg0KUGxlYXNlIG1lbnRpb24gYWxs
IGNoYW5nZXMgaW4gdGhlIHBhdGNoIGRlc2NyaXB0aW9uLiBJIHRoaW5rIHRoZSBSRUFEKDE2KSBh
bmQNCldSSVRFKDE2KSBjaGFuZ2VzIG5vdCBvbmx5IGNoYW5nZSB0aGUgR1JPVVAgTlVNQkVSIGZp
ZWxkIGZyb20gNSB0byA2IGJpdHMgYnV0DQphbHNvIGRlY2xhcmUgdGhlIERMRDAgYml0IGFzIHN1
cHBvcnRlZC4gQW55d2F5Og0KDQpSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZh
bmFzc2NoZUB3ZGMuY29tPg0KDQo=
