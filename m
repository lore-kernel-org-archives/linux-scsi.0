From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Mon, 21 Aug 2017 19:53:13 +0000
Message-ID: <1503345191.2571.13.camel@wdc.com>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
         <1503090353.2622.15.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
         <1503092817.2622.19.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8DBDE4@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44766 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753555AbdHUTyC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2017 15:54:02 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D195B8DBDE4@avsrvexchmbx2.microsemi.net>
Content-Language: en-US
Content-ID: <70B6AB454164214194DB6B0DD180DB38@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "viswas.g@microsemi.com" <viswas.g@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "mahesh.rajashekhara@microsemi.com" <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "kevin.barnett@microsemi.com" <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "justin.lindley@microsemi.com" <justin.lindley@microsemi.com>, "John.Hall@microsemi.com" <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gTW9uLCAyMDE3LTA4LTIxIGF0IDE5OjEyICswMDAwLCBEb24gQnJhY2Ugd3JvdGU6DQo+IE9u
IEZyaWRheSBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+ID4gQ2FuIHlvdSBjaGVjayBvbiB5b3Vy
IHRlc3Qgc3lzdGVtIHdoaWNoIHVkZXYgcnVsZSBjaGFuZ2VzDQo+ID4gbWF4X3NlY3RvcnNfa2I/
IEkNCj4gPiBoYXZlIGNoZWNrZWQgdHdvIHJlY2VudCBMaW51eCBkaXN0cm8ncyBidXQgaGF2ZW4n
dCBiZWVuIGFibGUgdG8gZmluZA0KPiA+IHN1Y2ggYSB1ZGV2IHJ1bGU6DQo+ID4gJCBncmVwIC1y
dyBtYXhfc2VjdG9yc19rYiAvdXNyL2xpYi91ZGV2L3J1bGVzLmQgL2V0Yy91ZGV2L3J1bGVzLmQg
fCB3Yw0KPiA+IC1sDQo+ID4gMA0KPiA+IA0KPiA+IFRoYW5rcywNCj4gPiANCj4gPiBCYXJ0Lg0K
PiANCj4gT24gbXkgc3lzdGVtIGl0IGlzIDYwLWJsb2NrLnJ1bGVzLCBhbmQgaXQgaXMgdGhlIGxh
c3QgcnVsZSBpbiB0aGF0IHJ1bGUNCj4gZmlsZS4NCj4gLS0NCj4gIyBkbyBub3QgZWRpdCB0aGlz
IGZpbGUsIGl0IHdpbGwgYmUgb3ZlcndyaXR0ZW4gb24gdXBkYXRlDQo+IA0KPiAjIGVuYWJsZSBp
bi1rZXJuZWwgbWVkaWEtcHJlc2VuY2UgcG9sbGluZw0KPiBBQ1RJT049PSJhZGQiLCBTVUJTWVNU
RU09PSJtb2R1bGUiLCBLRVJORUw9PSJibG9jayIsDQo+IEFUVFJ7cGFyYW1ldGVycy9ldmVudHNf
ZGZsX3BvbGxfbXNlY3N9PT0iMCIsIFwNCj4gICBBVFRSe3BhcmFtZXRlcnMvZXZlbnRzX2RmbF9w
b2xsX21zZWNzfT0iMjAwMCINCj4gDQo+ICMgZm9yd2FyZCBzY3NpIGRldmljZSBldmVudCB0byBj
b3JyZXNwb25kaW5nIGJsb2NrIGRldmljZQ0KPiBBQ1RJT049PSJjaGFuZ2UiLCBTVUJTWVNURU09
PSJzY3NpIiwgRU5We0RFVlRZUEV9PT0ic2NzaV9kZXZpY2UiLA0KPiBURVNUPT0iYmxvY2siLCBB
VFRSe2Jsb2NrLyovdWV2ZW50fT0iY2hhbmdlIg0KPiANCj4gIyB3YXRjaCBtZXRhZGF0YSBjaGFu
Z2VzLCBjYXVzZWQgYnkgdG9vbHMgY2xvc2luZyB0aGUgZGV2aWNlIG5vZGUgd2hpY2gNCj4gd2Fz
IG9wZW5lZCBmb3Igd3JpdGluZw0KPiBBQ1RJT04hPSJyZW1vdmUiLCBTVUJTWVNURU09PSJibG9j
ayIsDQo+IEtFUk5FTD09Imxvb3AqfG52bWUqfHNkKnx2ZCp8eHZkKnxwbWVtKiIsIE9QVElPTlMr
PSJ3YXRjaCINCg0KSGVsbG8gRG9uLA0KDQpDYW4geW91IGhhdmUgYW5vdGhlciBsb29rIGF0IHRo
ZSB1ZGV2IHJ1bGVzIG9uIHlvdXIgdGVzdCBzeXN0ZW0/IFRoZSBsYXN0DQpydWxlIGluIDYwLWJs
b2NrLnJ1bGVzIGxvb2tzIGxpa2UgYSB3YXRjaCBydWxlIHRvIG1lLiBUaGUgc2FtZSBob2xkcyBm
b3IgdGhlDQp1cHN0cmVhbSB2ZXJzaW9uIG9mIHRoYXQgZmlsZSAoaHR0cHM6Ly9naXRodWIuY29t
L3N5c3RlbWQvc3lzdGVtZC9ibG9iL21hc3RlDQpyL3J1bGVzLzYwLWJsb2NrLnJ1bGVzKS4NCg0K
QmFydC4=
