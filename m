From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 19:50:12 +0000
Message-ID: <1511985011.2671.30.camel@wdc.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
         <20171129173947.GC20581@kroah.com>
         <1511981395.30220.6.camel@localhost.localdomain>
         <1511982666.2671.25.camel@wdc.com>
         <1511983229.30220.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:9939 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdK2Tua (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Nov 2017 14:50:30 -0500
In-Reply-To: <1511983229.30220.19.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <A92ACC9BA428CC4180C2E70F96DE9911@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

T24gV2VkLCAyMDE3LTExLTI5IGF0IDE0OjIwIC0wNTAwLCBFd2FuIEQuIE1pbG5lIHdyb3RlOg0K
PiBPSywgd2VsbCwgSSB0aGluayB0aGUgcG9pbnQgc3RpbGwgc3RhbmRzLCB0aG91Z2gsIG9uY2Ug
dGhlIHJlZmNvdW50DQo+IGdvZXMgdG8gemVybyBhbmQgdGhlIGRlc3RydWN0b3IgaXMgaW52b2tl
ZCwgYSBnZXQgdGhhdCB0aGVuIGluY3JlbWVudHMNCj4gdGhlIHJlZmNvdW50IHNlZW1zIGZ1bmRh
bWVudGFsbHkgd3JvbmcgdG8gbWUuDQoNCkkgYWdyZWUgdGhhdCBpbmNyZW1lbnRpbmcgYSByZWZl
cmVuY2UgY291bnQgdGhhdCBoYXMgZHJvcHBlZCB0byB6ZXJvIGlzIHdyb25nLg0KSG93ZXZlciwg
dGhhdCdzIHdoYXQgaGFwcGVucyBjdXJyZW50bHkuIFRoYXQgYmVoYXZpb3IgaGFzIGJlZW4gcmVw
b3J0ZWQgYXMgYQ0KYnVnLiBXZSBuZWVkIHRvIGZpeCB0aGlzIGJlaGF2aW9yLCBlaXRoZXIgdGhy
b3VnaCB0aGUgcGF0Y2ggYXQgdGhlIHN0YXJ0IG9mDQp0aGlzIHRocmVhZCBvciBieSB1c2luZyBj
b2RlIHRoYXQgYXZvaWRzIHRvIGluY3JlbWVudCBhIHplcm8gcmVmZXJlbmNlIGNvdW50LA0KZS5n
LiBrb2JqZWN0X2dldF91bmxlc3NfemVybygpLg0KDQpCYXJ0Lg==
