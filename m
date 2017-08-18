From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Fri, 18 Aug 2017 21:46:58 +0000
Message-ID: <1503092817.2622.19.camel@wdc.com>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
         <1503090353.2622.15.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:62825 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdHRVrs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2017 17:47:48 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
Content-Language: en-US
Content-ID: <8405EBEC5B50C3498149A87D77FFC8FF@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "viswas.g@microsemi.com" <viswas.g@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "mahesh.rajashekhara@microsemi.com" <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "kevin.barnett@microsemi.com" <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "justin.lindley@microsemi.com" <justin.lindley@microsemi.com>, "John.Hall@microsemi.com" <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gRnJpLCAyMDE3LTA4LTE4IGF0IDIxOjI5ICswMDAwLCBEb24gQnJhY2Ugd3JvdGU6DQo+IEFz
IGZhciBhcyBJIGNhbiBzZWUsIHVkZXYgbG9va3MgZm9yIGZpbGUgYWNjZXNzIGluIHN5c2ZzLiAN
Cj4gSSBhbSBub3QgZXhhY3RseSBzdXJlIHdoaWNoIHJ1bGUgY2hhbmdlcyB0aGlzLiBJdCB3YXMg
YWRkZWQgaW4gbW9yZSByZWNlbnQNCj4gZGlzdHJvcy4gQ2FuIHNvbWVvbmUgaGVscCBtZSBvdXQ/
DQoNCkhlbGxvIERvbiwNCg0KQ2FuIHlvdSBjaGVjayBvbiB5b3VyIHRlc3Qgc3lzdGVtIHdoaWNo
IHVkZXYgcnVsZSBjaGFuZ2VzIG1heF9zZWN0b3JzX2tiPyBJDQpoYXZlIGNoZWNrZWQgdHdvIHJl
Y2VudCBMaW51eCBkaXN0cm8ncyBidXQgaGF2ZW4ndCBiZWVuIGFibGUgdG8gZmluZCBzdWNoIGEN
CnVkZXYgcnVsZToNCiQgZ3JlcCAtcncgbWF4X3NlY3RvcnNfa2IgL3Vzci9saWIvdWRldi9ydWxl
cy5kIC9ldGMvdWRldi9ydWxlcy5kIHwgd2MgLWwNCjANCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
