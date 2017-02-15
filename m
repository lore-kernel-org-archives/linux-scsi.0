From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v4] sd: Check for unaligned partial completion
Date: Wed, 15 Feb 2017 15:10:54 +0000
Message-ID: <1487171439.2990.2.camel@sandisk.com>
References: <20170215021230.11181-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:57103 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdBOPMF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 10:12:05 -0500
In-Reply-To: <20170215021230.11181-1-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <974AD17BBFD070438D06DD359CAE6339@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "hch@lst.de" <hch@lst.de>

T24gV2VkLCAyMDE3LTAyLTE1IGF0IDExOjEyICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToN
Cj4gKwkJCXJlc2lkID0gcm91bmRfdXAocmVzaWQsIHNlY3Rvcl9zaXplKTsNCj4gKwkJCWlmIChy
ZXNpZCA8IGdvb2RfYnl0ZXMpDQo+ICsJCQkJZ29vZF9ieXRlcyAtPSByZXNpZDsNCj4gKwkJCWVs
c2UNCj4gKwkJCQlnb29kX2J5dGVzID0gMDsNCj4gKwkJCXNjc2lfc2V0X3Jlc2lkKFNDcG50LCBy
ZXNpZCk7DQoNCkhlbGxvIERhbWllbiwNCg0KSWYgdGhlIERhdGEtT3V0IGJ1ZmZlciBpcyBzbWFs
bGVyIHRoYW4gYSBzaW5nbGUgbG9naWNhbCBibG9jaywgY2FuIHRoZSBhYm92ZQ0KY29kZSBjYXVz
ZSByZXNpZCB0byBleGNlZWQgdGhlIERhdGEtT3V0IGJ1ZmZlciBzaXplPyBJIHRoaW5rIHdlIHNo
b3VsZCBhdm9pZA0KdG8gY29udmVydCBhIHJlc2lkdWFsIG92ZXJmbG93IGludG8gYSByZXNpZHVh
bCB1bmRlcmZsb3cuIEFkZGl0aW9uYWxseSwgd2lsbA0Kcm91bmRfdXAoKSB3b3JrIGNvcnJlY3Rs
eSBpZiByZXNpZCBpcyBuZWdhdGl2ZSAocmVzaWR1YWwgdW5kZXJmbG93KT8gSG93DQphYm91dCB1
c2luZyB0aGUgZm9sbG93aW5nICh1bnRlc3RlZCkgY29kZSBpbnN0ZWFkIG9mIHRoZSBhYm92ZT8N
Cg0KaWYgKHJlc2lkID4gMCkgew0KICAgICAgICByZXNpZCA9IG1pbihnb29kX2J5dGVzLCByb3Vu
ZF91cChyZXNpZCwgc2VjdG9yX3NpemUpKTsNCiAgICAgICAgZ29vZF9ieXRlcyAtPSByZXNpZDsN
CiAgICAgICAgc2NzaV9zZXRfcmVzaWQoU0NwbnQsIHJlc2lkKTsNCn0NCg0KVGhhbmtzLA0KDQpC
YXJ0Lg==
