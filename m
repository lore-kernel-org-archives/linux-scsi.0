From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Thu, 30 Nov 2017 16:08:38 +0000
Message-ID: <1512058117.2774.1.camel@wdc.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
         <1511977145.2671.13.camel@wdc.com> <5A1F5C77.5050405@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25229 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752179AbdK3QIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Nov 2017 11:08:42 -0500
In-Reply-To: <5A1F5C77.5050405@huawei.com>
Content-Language: en-US
Content-ID: <621451024B36DF4BA1049B741DFD6FF7@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "yanaijie@huawei.com" <yanaijie@huawei.com>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

T24gVGh1LCAyMDE3LTExLTMwIGF0IDA5OjE4ICswODAwLCBKYXNvbiBZYW4gd3JvdGU6DQo+IEhp
IEJhcnQsIEkgY2hvc2UgdGhlIGFwcHJvYWNoIGluIG15IHBhdGNoIGJlY2F1c2UgaXQgaGFzIGJl
ZW4gdXNlZCBpbg0KPiBzY3NpX2RldmljZV9nZXQoKSBmb3IgeWVhcnMgYW5kIGJlZW4gcHJvdmVk
IHNhZmUuIEkgdGhpbmsgdXNpbmcNCj4ga29iamVjdF9nZXRfdW5sZXNzX3plcm8oKSBpcyBzYWZl
IGhlcmUgYW5kIGNhbiBmaXggdGhpcyBpc3N1ZSB0b28uIEFuZA0KPiB0aGlzIGFwcHJvYWNoIGlz
IGJlbmVmaWNpYWwgdG8gYWxsIHVzZXJzLg0KDQpIZWxsbyBKYXNvbiwNCg0KQSBwb3NzaWJsZSBh
cHByb2FjaCBpcyB0aGF0IHdlIHN0YXJ0IHdpdGggeW91ciBwYXRjaCBhbmQgZGVmZXIgYW55IGdl
dF9kZXZpY2UoKQ0KY2hhbmdlcyB1bnRpbCBhZnRlciB5b3VyIHBhdGNoIGhhcyBiZWVuIGFwcGxp
ZWQuDQoNCkJhcnQu
