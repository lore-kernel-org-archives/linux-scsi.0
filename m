From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 6/9] blk-mq: rename blk_mq_freeze_queue_wait as
 blk_freeze_queue_wait
Date: Thu, 31 Aug 2017 22:37:46 +0000
Message-ID: <1504219064.31872.68.camel@wdc.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
         <20170831172728.15817-7-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:62054 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdHaWif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 18:38:35 -0400
In-Reply-To: <20170831172728.15817-7-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <B128C92BDA2BB044BD35AAF8EF577E4E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: "oleksandr@natalenko.name" <oleksandr@natalenko.name>

T24gRnJpLCAyMDE3LTA5LTAxIGF0IDAxOjI3ICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gVGhl
IG9ubHkgY2hhbmdlIG9uIGxlZ2FjeSBpcyB0aGF0IGJsa19kcmFpbl9xdWV1ZSgpIGlzIHJ1bg0K
PiBmcm9tIGJsa19mcmVlemVfcXVldWUoKSwgd2hpY2ggaXMgY2FsbGVkIGluIGJsa19jbGVhbnVw
X3F1ZXVlKCkuDQo+IA0KPiBTbyB0aGlzIHBhdGNoIHJlbW92ZXMgdGhlIGV4cGxpY2l0ZSBfX2Js
a19kcmFpbl9xdWV1ZSgpIGluDQo+IGJsa19jbGVhbnVwX3F1ZXVlKCkuDQoNCkhlbGxvIE1pbmcs
DQoNClNob3VsZG4ndCB0aGUgcmVuYW1lIGFuZCB0aGUgbW92ZSBvZiB0aGUgX19ibGtfZHJhaW5f
cXVldWUoKSBiZQ0Kc2VwYXJhdGUgcGF0Y2hlcz8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
