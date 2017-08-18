From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Fri, 18 Aug 2017 21:05:54 +0000
Message-ID: <1503090353.2622.15.camel@wdc.com>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:38510 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdHRVGn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2017 17:06:43 -0400
In-Reply-To: <150309002518.8999.15900049133748830764.stgit@brunhilda>
Content-Language: en-US
Content-ID: <673BF76A53CA2245A4E87C44576515A5@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "Viswas.G@microsemi.com" <Viswas.G@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "Mahesh.Rajashekhara@microsemi.com" <Mahesh.Rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "Kevin.Barnett@microsemi.com" <Kevin.Barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Justin.Lindley@microsemi.com" <Justin.Lindley@microsemi.com>, "john.hall@microsemi.com" <john.hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gRnJpLCAyMDE3LTA4LTE4IGF0IDE2OjAwIC0wNTAwLCBEb24gQnJhY2Ugd3JvdGU6DQo+IHBy
ZXZlbnQgc3lzdGVtZC11ZGV2ZCBmcm9tIGNoYW5naW5nIGEgZGV2aWNlJ3Mgc3lzZnMgZW50cnkN
Cj4gbWF4X3NlY3RvcnNfa2IgYmFjayB0byB0aGUgZGVmYXVsdCB2YWx1ZS4NCj4gIC0gbWF4X3Nl
Y3RvcnNfa2IgY2FuIGJlIHR3ZWFrZWQgZm9yIGJldHRlciBwZXJmb3JtYW5jZS4NCj4gIC0gdWRl
diBjYW4gYmUgdHJpZ2dlcmVkIGJ5IHNnX2xvZ3MgLXQgb3Igc2NzaV90ZW1wZXJhdHVyZSwgLi4u
DQo+ICAtIHNkX3JldmFsaWRhdGVfZGlzayBpcyBjYWxsZWQgZnJvbSB1ZGV2IGJ5IGlvY3RsIEJM
S1JSUEFSVA0KDQpIZWxsbyBEb24sDQoNCldoaWNoIHVkZXYgcnVsZSBjaGFuZ2VzIG1heF9zZWN0
b3JzX2tiIGJhY2sgdG8gdGhlIGRlZmF1bHQ/IFdoeSBkbyB5b3Ugd2FudA0KdG8gY2hhbmdlIHRo
ZSBrZXJuZWwgY29kZSBpbnN0ZWFkIG9mIG1vZGlmeWluZyB0aGF0IHVkZXYgcnVsZT8gV2hhdCBz
b2Z0d2FyZQ0KY2hhbmdlcyBtYXhfc2VjdG9yc19rYiB0byBhIHNtYWxsZXIgdmFsdWU/IElzIGl0
IGEgdWRldiBydWxlIG9yIHBlcmhhcHMNCnNvbWV0aGluZyBlbHNlPw0KDQpUaGFua3MsDQoNCkJh
cnQu
