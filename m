From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Tue, 29 Aug 2017 23:00:20 +0000
Message-ID: <1504047619.2653.75.camel@wdc.com>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
         <1503090353.2622.15.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
         <1503092817.2622.19.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8DBDE4@avsrvexchmbx2.microsemi.net>
         <1503345191.2571.13.camel@wdc.com>
         ,<4993A297653ECB4581FA5C3C31323D195B8DBE34@avsrvexchmbx2.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D195B8E9103@avsrvexchmbx1.microsemi.net>
         ,<1504030401.2653.43.camel@wdc.com>
         ,<4993A297653ECB4581FA5C3C31323D195B8E9143@avsrvexchmbx1.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D195B8E9191@avsrvexchmbx1.microsemi.net>
        ,<1504045532.2653.68.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8E9288@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:45817 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751746AbdH2XBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 19:01:11 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D195B8E9288@avsrvexchmbx1.microsemi.net>
Content-Language: en-US
Content-ID: <D9E0ED123CCF294A9B968059AF4ACD19@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "viswas.g@microsemi.com" <viswas.g@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "mahesh.rajashekhara@microsemi.com" <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "kevin.barnett@microsemi.com" <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "justin.lindley@microsemi.com" <justin.lindley@microsemi.com>, "John.Hall@microsemi.com" <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gVHVlLCAyMDE3LTA4LTI5IGF0IDIyOjMyICswMDAwLCBEb24gQnJhY2Ugd3JvdGU6DQo+IFVz
ZXJzIGRvIHNldCBtYXhfc2VjdG9yc19rYiBmb3IgcGVyZm9ybWFuY2UgcmVhc29ucy4gVGhleSBj
YW4gaW5jcmVhc2UNCj4gcGVyZm9ybWFuY2UgYnkgc2V0dGluZyBtYXhfc2VjdG9yc19rYiB0byBk
aWZmZXJlbnQgdmFsdWVzIGRlcGVuZGluZyBvbg0KPiB0aGVpciBJL08gbmVlZHMuDQo+IA0KPiBB
bmQsIGlmIHRoZXkgc2V0IHRoZSB2YWx1ZSwgYW5kIHNkX3JldmFsaWRhdGVfZGlzayBjaGFuZ2Vz
IHRoaXMgdmFsdWUsIA0KPiB0aGVyZSBpcyBubyBoaXN0b3J5IG9mIHdoYXQgdGhleSBzZXQgdGhl
IHZhbHVlIHRvLiANCg0KSGVsbG8gRG9uLA0KDQpIb3cgYWJvdXQgYXNraW5nIHRoZXNlIHVzZXJz
IHRvIGNyZWF0ZSBhIHVkZXYgcnVsZSBpbnN0ZWFkIG9mIGRpcmVjdGx5DQptb2RpZnlpbmcgbWF4
X3NlY3RvcnNfa2IgaW4gc3lzZnM/DQoNCkJhcnQu
