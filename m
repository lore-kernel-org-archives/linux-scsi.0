From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V3 7/8] block: allow to allocate req with REQF_PREEMPT
 when queue is preempt frozen
Date: Mon, 4 Sep 2017 04:13:26 +0000
Message-ID: <1504498405.10804.10.camel@wdc.com>
References: <20170902130840.24609-1-ming.lei@redhat.com>
         <20170902130840.24609-8-ming.lei@redhat.com>
         <20170902131208.GA10940@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20275 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdIDEOP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Sep 2017 00:14:15 -0400
In-Reply-To: <20170902131208.GA10940@ming.t460p>
Content-Language: en-US
Content-ID: <D87437F73444DA4596860F8AE418D689@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: "tj@kernel.org" <tj@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>

T24gU2F0LCAyMDE3LTA5LTAyIGF0IDIxOjEyICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gUGxl
YXNlIGxldCB1cyBrbm93IGlmIFYzIGFkZHJlc3NlcyB5b3VyIHByZXZpb3VzIGNvbmNlcm4gYWJv
dXQgY2FsbGluZw0KPiBibGtfcXVldWVfZW50ZXJfbGl2ZSgpIGR1cmluZyBwcmVlbXB0IGZyZWV6
aW5nLg0KDQpEbyB5b3UgdW5kZXJzdGFuZCBob3cgcmVxdWVzdCBxdWV1ZSBjbGVhbnVwIHdvcmtz
PyBUaGUgYWxnb3JpdGhtIHVzZWQgZm9yDQpyZXF1ZXN0IHF1ZXVlIGNsZWFudXAgaXMgYXMgZm9s
bG93czoNCiogU2V0IHRoZSBEWUlORyBmbGFnLiBUaGlzIGZsYWcgbWFrZXMgYWxsIGxhdGVyIGJs
a19nZXRfcmVxdWVzdCgpIGNhbGxzDQogIGZhaWwuDQoqIFdhaXQgdW50aWwgYWxsIHBlbmRpbmcg
cmVxdWVzdHMgaGF2ZSBmaW5pc2hlZC4NCiogU2V0IHRoZSBERUFEIGZsYWcuIEZvciB0aGUgdHJh
ZGl0aW9uYWwgYmxvY2sgbGF5ZXIsIHRoaXMgZmxhZyBjYXVzZXMNCiAgYmxrX3J1bl9xdWV1ZSgp
IG5vdCB0byBjYWxsIC5yZXF1ZXN0X2ZuKCkgYW55bW9yZS4gRm9yIGJsay1tcSBpdCBpcw0KICBn
dWFyYW50ZWVkIGluIGFub3RoZXIgd2F5IHRoYXQgLnF1ZXVlX3JxKCkgd29uJ3QgYmUgY2FsbGVk
IGFueW1vcmUgYWZ0ZXINCiAgdGhpcyBmbGFnIGhhcyBiZWVuIHNldC4NCg0KQWxsb3dpbmcgYmxr
X2dldF9yZXF1ZXN0KCkgdG8gc3VjY2VlZCBhZnRlciB0aGUgRFlJTkcgZmxhZyBoYXMgYmVlbiBz
ZXQgaXMNCmNvbXBsZXRlbHkgd3JvbmcgYmVjYXVzZSB0aGF0IGNvdWxkIHJlc3VsdCBpbiBhIHJl
cXVlc3QgYmVpbmcgcXVldWVkIGFmdGVyDQp0aGUgREVBRCBmbGFnIGhhcyBiZWVuIHNldCwgcmVz
dWx0aW5nIGluIGVpdGhlciBhIGhhbmdpbmcgcmVxdWVzdCBvciBhIGtlcm5lbA0KY3Jhc2guIFRo
aXMgaXMgd2h5IGl0J3MgY29tcGxldGVseSB3cm9uZyB0byBhZGQgYSBibGtfcXVldWVfZW50ZXJf
bGl2ZSgpIGNhbGwNCmluIGJsa19vbGRfZ2V0X3JlcXVlc3QoKSBvciBibGtfbXFfYWxsb2NfcmVx
dWVzdCgpLiBIZW5jZSBteSBOQUsgZm9yIGFueQ0KcGF0Y2ggdGhhdCBhZGRzIGEgYmxrX3F1ZXVl
X2VudGVyX2xpdmUoKSBjYWxsIHRvIGFueSBmdW5jdGlvbiBjYWxsZWQgZnJvbQ0KYmxrX2dldF9y
ZXF1ZXN0KCkuIFRoYXQgaW5jbHVkZXMgdGhlIHBhdGNoIGF0IHRoZSBzdGFydCBvZiB0aGlzIGUt
bWFpbCB0aHJlYWQuDQoNCkJhcnQu
