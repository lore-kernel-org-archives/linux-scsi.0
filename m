From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Tue, 29 Aug 2017 22:25:33 +0000
Message-ID: <1504045532.2653.68.camel@wdc.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64573 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbdH2W0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 18:26:24 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D195B8E9191@avsrvexchmbx1.microsemi.net>
Content-Language: en-US
Content-ID: <15FD85E8DB1AC641A47E0D2156C3A82C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "viswas.g@microsemi.com" <viswas.g@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "mahesh.rajashekhara@microsemi.com" <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "kevin.barnett@microsemi.com" <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "justin.lindley@microsemi.com" <justin.lindley@microsemi.com>, "John.Hall@microsemi.com" <John.Hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

T24gVHVlLCAyMDE3LTA4LTI5IGF0IDE5OjQxICswMDAwLCBEb24gQnJhY2Ugd3JvdGU6DQo+IEJM
S1JSUEFSVCBlbmRzIHVwIGluIHRoZSBzZCBkcml2ZXIgZnVuY3Rpb24gc2RfcmV2YWxpZGF0ZV9k
aXNrLCB3aGljaCByZXNldHMNCj4gICAgICAgICBxLT5saW1pdHMubWF4X3NlY3RvcnMgPSBtaW4o
cndfbWF4LCBxdWV1ZV9tYXhfaHdfc2VjdG9ycyhxKSk7DQo+IGJhY2sgdG8gdGhlIHZhbHVlIGZy
b20gVlBEIHBhZ2UgMHhiMC4NCj4gDQo+IFdoZW4geW91IGNhdCBvdXQgbWF4X3NlY3RvcnNfa2Is
IGl0IG9idGFpbnMgaXQncyB2YWx1c2UgZnJvbSBxLT5saW1pdHMubWF4X3NlY3RvcnMNCj4gDQo+
IEFkZGluZyBhIHVkZXYgcnVsZS4uLiBXaWxsIHRoZXJlIGJlIGEgZGVsYXkgYmV0d2VlbiB0aGUg
d2F0Y2ggcnVsZSBhbmQgdGhlIG5ldyBydWxlPw0KDQpIZWxsbyBEb24sDQoNCkluIHlvdXIgb3Jp
Z2luYWwgZS1tYWlsIHlvdSB3cm90ZSB0aGF0IG1heF9zZWN0b3JzX2tiIHdhcyB0dW5lZCBiZWNh
dXNlDQpvZiBwZXJmb3JtYW5jZSByZWFzb25zLiBTbyBkb2VzIGl0IHJlYWxseSBtYXR0ZXIgdGhh
dCBmb3IgYSB2ZXJ5IHNob3J0DQp0aW1lIG1heF9zZWN0b3JzX2tiIGRvZXMgbm90IGhhdmUgdGhl
IG9wdGltYWwgdmFsdWU/DQoNCj4gT25lIG1vcmUgcG9pbnQsIHdoYXQgd2lsbCBJIGNoYW5nZSB0
aGUgdmFsdWUgYmFjayB0bz8gVGhlIHdhdGNoIHJ1bGUgDQo+IGNoYW5nZWQgaXQgYW5kIEkgZG8g
bm90IGhhdmUgdGhlIG9yaWdpbmFsIHZhbHVlLg0KDQpUbyB0aGUgdmFsdWUgeW91IHdhbnQgdG8g
c2V0IG1heF9zZWN0b3JzX2tiIHRvLg0KDQpCYXJ0Lg==
