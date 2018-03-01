From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi_lib: increase {host|target|device}_busy count after
 dispatch cmd
Date: Thu, 1 Mar 2018 23:11:02 +0000
Message-ID: <1519945861.2675.9.camel@sandisk.com>
References: <1496655478-4039-1-git-send-email-opensource.ganesh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496655478-4039-1-git-send-email-opensource.ganesh@gmail.com>
Content-Language: en-US
Content-ID: <C456706F68F6274AA9DDEBEA8B6893AE@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hch@lst.de" <hch@lst.de>, "opensource.ganesh@gmail.com" <opensource.ganesh@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE3LTA2LTA1IGF0IDE3OjM3ICswODAwLCBHYW5lc2ggTWFoZW5kcmFuIHdyb3Rl
Og0KPiBJbiBhbmRyb2lkIHN5c3RlbSwgd2hlbiB0aGVyZSBhcmUgbG90cyBvZiB0aHJlYWRzIHJ1
bm5pbmcuIFRocmVhZCBBDQo+IGhvbGRpbmcgKmhvc3RfYnVzeSogY291bnQgaXMgZWFzaWx5IHRv
IGJlIHByZWVtcHRlZCwgYW5kIGlmIGF0IHRoZQ0KPiBzYW1lIHRpbWUsIHRocmVhZCBCIHNldCAq
aG9zdF9ibG9ja2VkKiwgdGhlbiBhbGwgb3RoZXIgdGhyZWFkcyB3aWxsDQo+IGJlIGlvIGJsb2Nr
ZWQuDQoNCkhlbGxvIEdhbmVzaCwNCg0KSGF2ZSB5b3UgY29uc2lkZXJlZCB0byBpbnNlcnQgcHJl
ZW1wdF9kaXNhYmxlKCkgYW5kIHByZWVtcHRfZW5hYmxlKCkgY2FsbHMNCndoZXJlIG5lY2Vzc2Fy
eSB0byBhY2hpZXZlIHRoZSBzYW1lIGVmZmVjdD8gSSB0aGluayB0aGF0IHdvdWxkIHJlc3VsdCBp
biBhDQptdWNoIGxlc3MgaW50cnVzaXZlIHBhdGNoLg0KDQpUaGFua3MsDQoNCkJhcnQuDQoNCg0K
