From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/9] percpu-refcount: introduce percpu_ref_is_dead()
Date: Thu, 31 Aug 2017 23:07:30 +0000
Message-ID: <1504220849.31872.78.camel@wdc.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
         <20170831172728.15817-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1428 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751794AbdHaXIS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 19:08:18 -0400
In-Reply-To: <20170831172728.15817-2-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <3895ED3FA8EAC74F93E97AAAD8DAB95D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: "tj@kernel.org" <tj@kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDAxOjI3ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gSW5z
aWRlIGJsb2NrIGxheWVyLCB3ZSBuZWVkIHRvIHN1cHBvcnQgdG8gYWxsb2NhdGUgcmVxdWVzdCB3
aXRoDQo+IFJRRl9QUkVFTVBUIGV2ZW4gdGhvdWdoIHF1ZXVlIGlzIGZyb3plbi4NCg0KSGVsbG8g
TWluZywNCg0KQ2FuIHBhdGNoIDgvOSBiZSByZXdvcmtlZCBzdWNoIHRoYXQgaXQgZG9lc24ndCBu
ZWVkIHRoZSBuZXcNCnBlcmNwdV9yZWZfaXNfZGVhZCgpIGhlbHBlciBmdW5jdGlvbiwgZS5nLiBi
eSBjaGVja2luZyBxLT5tcV9mcmVlemVfZGVwdGgNCnRvIGNoZWNrIHdoZXRoZXIgb3Igbm90IHJl
cXVlc3QgcHJvY2Vzc2luZyBoYXMgYmVlbiBmcm96ZW4/IEhhdmUgeW91IG5vdGljZWQNCnRoYXQg
c2V2ZXJhbCBibGstbXEgY29kZSBwYXRocyBhbHJlYWR5IGNoZWNrIHEtPm1xX2ZyZWV6ZV9kZXB0
aCB0byBjaGVjaw0Kd2hldGhlciBvciBub3QgYSBxdWV1ZSBpcyBmcm96ZW4/DQoNClRoYW5rcywN
Cg0KQmFydC4=
