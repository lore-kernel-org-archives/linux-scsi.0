From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Tue, 29 Aug 2017 18:13:24 +0000
Message-ID: <1504030401.2653.43.camel@wdc.com>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
         <1503090353.2622.15.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
         <1503092817.2622.19.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8DBDE4@avsrvexchmbx2.microsemi.net>
         <1503345191.2571.13.camel@wdc.com>
        ,<4993A297653ECB4581FA5C3C31323D195B8DBE34@avsrvexchmbx2.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D195B8E9103@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:34183 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2SOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 14:14:12 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D195B8E9103@avsrvexchmbx1.microsemi.net>
Content-Language: en-US
Content-ID: <0B36BB4E5111054896822F81D6F0288B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "viswas.g@microsemi.com" <viswas.g@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "mahesh.rajashekhara@microsemi.com" <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "kevin.barnett@microsemi.com" <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "justin.lindley@microsemi.com" <justin.lindley@microsemi.com>, "John.Hall@microsemi.com" <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gVHVlLCAyMDE3LTA4LTI5IGF0IDE3OjQyICswMDAwLCBEb24gQnJhY2Ugd3JvdGU6DQo+IEZy
b206IERvbiBCcmFjZQ0KPiA+IFsgLi4uIF0NCj4gPiBIZWxsbyBEb24sDQo+ID4gDQo+ID4gQ2Fu
IHlvdSBoYXZlIGFub3RoZXIgbG9vayBhdCB0aGUgdWRldiBydWxlcyBvbiB5b3VyIHRlc3Qgc3lz
dGVtPyBUaGUgbGFzdA0KPiA+IHJ1bGUgaW4gNjAtYmxvY2sucnVsZXMgbG9va3MgbGlrZSBhIHdh
dGNoIHJ1bGUgdG8gbWUuIFRoZSBzYW1lIGhvbGRzIGZvciB0aGUNCj4gPiB1cHN0cmVhbSB2ZXJz
aW9uIG9mIHRoYXQgZmlsZQ0KPiA+IChodHRwczovL2dpdGh1Yi5jb20vc3lzdGVtZC9zeXN0ZW1k
L2Jsb2IvbWFzdGUNCj4gPiByL3J1bGVzLzYwLWJsb2NrLnJ1bGVzKS4NCj4gPiANCj4gPiBCYXJ0
Lg0KPiANCj4gSXQgaXMgYSB3YXRjaCBydWxlLg0KPiANCj4gc3lzdGVtZC9zcmMvdWRldi91ZGV2
ZC5jDQo+ICAgIG1hbmFnZXJfbmV3DQo+ICAgICAgICBtYW5hZ2VyLT5mZF9pbm90aWZ5ID0gdWRl
dl93YXRjaF9pbml0KG1hbmFnZXItPnVkZXYpOw0KPiAgICAgICAgc2RfZXZlbnRfYWRkX2lvKG1h
bmFnZXItPmV2ZW50LCAmbWFuYWdlci0+aW5vdGlmeV9ldmVudCwgbWFuYWdlci0+ZmRfaW5vdGlm
eSwgRVBPTExJTiwgb25faW5vdGlmeSwgbWFuYWdlcik7DQo+ICAgICAgICAgICAgb25faW5vdGlm
eSAoc3lzdGVtZCBzb3VyY2UgY29kZTogc3JjL3VkZXYvdWRldmQuYykNCj4gICAgICAgICAgICAg
ICBzeW50aGVzaXplX2NoYW5nZQ0KPiAgICAgICAgICAgICAgICAgICAgIGlvY3RsIC0tPiBCTEtS
UlBBUlQNCj4gDQo+IFRoaXMgcnVsZSBlbmRzIHVwIGNhbGxpbmcgQkxLUlJQQVJULg0KDQpIZWxs
byBEb24sDQoNClNvcnJ5IGlmIEknbSBzbG93IHRvZGF5LCBidXQgaXQncyBub3QgY2xlYXIgdG8g
bWUgaG93IHRoZSBCTEtSUlBBUlQgaW9jdGwNCnRyaWdnZXJzIGEgY2hhbmdlIG9mIG1heF9zZWN0
b3JzX2tiPyBBbmQgZXZlbiBpZiBpdCByZWFsbHkgaXMgdGhpcyBpb2N0bCB0aGF0DQp0cmlnZ2Vy
cyBhIGNoYW5nZSBvZiBtYXhfc2VjdG9yc19rYiwgc2hvdWxkIHRoZSBrZXJuZWwgY29kZSB0aGF0
IGhhbmRsZXMNCm1heF9zZWN0b3JzX2tiIHdyaXRlcyBiZSBtb2RpZmllZCBvciBzaG91bGQgcmF0
aGVyIGEgdWRldiBydWxlIGJlIGFkZGVkIHRoYXQNCnNldHMgbWF4X3NlY3RvcnNfa2IgdG8gdGhl
IGRlc2lyZWQgdmFsdWUgYWZ0ZXIgZWFjaCBwYXJ0aXRpb24gcmVzY2FuPw0KDQpUaGFua3MsDQoN
CkJhcnQu
