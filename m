From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V9 6/7] SCSI: allow to pass null rq to
 scsi_prep_state_check()
Date: Fri, 13 Oct 2017 23:16:12 +0000
Message-ID: <1507936571.13345.51.camel@wdc.com>
References: <20171013180532.29304-1-ming.lei@redhat.com>
         <20171013180532.29304-7-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8062 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdJMXQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2017 19:16:15 -0400
In-Reply-To: <20171013180532.29304-7-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <7EAD39FA101A304C96E059B7641BE44E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>

T24gU2F0LCAyMDE3LTEwLTE0IGF0IDAyOjA1ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gSW4g
dGhlIGZvbGxvd2luZyBwYXRjaCwgd2Ugd2lsbCBpbXBsZW1lbnQgc2NzaV9nZXRfYnVkZ2V0KCkN
Cj4gd2hpY2ggbmVlZCB0byBjYWxsIHNjc2lfcHJlcF9zdGF0ZV9jaGVjaygpIHdoZW4gcnEgaXNu
J3QNCj4gZGVxdWV1ZWQgeWV0Lg0KDQpNeSB1bmRlcnN0YW5kaW5nIGlzIHRoYXQgdGhpcyBjaGFu
Z2UgaXMgb25seSBuZWVkZWQgYmVjYXVzZSBzY3NpX21xX2dldF9idWRnZXQoKQ0KY2FsbHMgc2Nz
aV9wcmVwX3N0YXRlX2NoZWNrKCkgd2l0aCB0aGUgcmVxIGFyZ3VtZW50IHNldCB0byBOVUxMLiBT
aW5jZQ0Kc2NzaV9wcmVwX3N0YXRlX2NoZWNrKCkgdGVzdHMgZm9yIHNkZXYgc3RhdGVzIG90aGVy
IHRoYW4gU0RFVl9SVU5OSU5HIGFuZCBzaW5jZQ0KdGhlIHB1cnBvc2Ugb2YgdGhpcyBzZXJpZXMg
aXMgdG8gb3B0aW1pemUgcGVyZm9ybWFuY2UgZm9yIHRoZSBjYXNlIFNERVZfUlVOTklORw0KSSdt
IG5vdCBzdXJlIGl0J3MgYSBnb29kIGlkZWEgdG8gbWFrZSBzY3NpX21xX2dldF9idWRnZXQoKSBj
YWxsDQpzY3NpX3ByZXBfc3RhdGVfY2hlY2soKS4gQW5kIGlmIHNjc2lfbXFfZ2V0X2J1ZGdldCgp
IHdvdWxkbid0IGNhbGwNCnNjc2lfcHJlcF9zdGF0ZV9jaGVjaygpIHRoZW4gdGhpcyBwYXRjaCBp
cyBub3QgbmVjZXNzYXJ5Lg0KDQpCYXJ0Lg==
