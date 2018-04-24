From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Regression 4.17-rc1: SSD doesn properly resume causing system
 hang (NULL pointer dereference)
Date: Tue, 24 Apr 2018 17:31:40 +0000
Message-ID: <14ff1ed06e36a372680872c227b5abe389c753da.camel@wdc.com>
References: <59ca6556-11a6-4f77-76e7-d51c7175eb32@molgen.mpg.de>
         <67ffdf0050a04bf3615c3d8a3a90b0c9c2aeb1ad.camel@wdc.com>
         <2cc5f0fb-4caa-9c28-7daa-68993d5cb41a@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2cc5f0fb-4caa-9c28-7daa-68993d5cb41a@molgen.mpg.de>
Content-Language: en-US
Content-ID: <2E675AA673B99046A1D0CD4F22AD66AC@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "pmenzel+linux-block@molgen.mpg.de" <pmenzel+linux-block@molgen.mpg.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "regressions@leemhuis.info" <regressions@leemhuis.info>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE4LTA0LTI0IGF0IDE5OjEwICswMjAwLCBQYXVsIE1lbnplbCB3cm90ZToNCj4g
UGxlYXNlIGZpbmQgdGhlIGNvbmZpZ3VyYXRpb24gZmlsZSBhdHRhY2hlZC4gVGhlIGxvZyBvbmx5
IGhhcyANCj4gYGluaXRjYWxsX2RlYnVnIG5vX2NvbnNvbGVfc3VzcGVuZGAgYWRkZWQuDQoNCldo
YXQgSSB3YXMgbG9va2luZyBmb3IgaW4gdGhlIC5jb25maWcgaXMgdGhlIGZvbGxvd2luZzoNCkNP
TkZJR19TQ1NJX01RX0RFRkFVTFQ9eQ0KDQpDYW4geW91IGFsc28gcHJvdmlkZSB0aGUgZGlzYXNz
ZW1ibHkgb3V0cHV0IGZvciBibGtfc2V0X3J1bnRpbWVfYWN0aXZlLA0KZS5nLiBieSBsb2FkaW5n
IHZtbGludXggaW50byBnZGIgYW5kIGJ5IHJ1bm5pbmcgdGhlIGNvbW1hbmQgImRpc2FzDQpibGtf
c2V0X3J1bnRpbWVfYWN0aXZlIj8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg0KDQoNCg0K
