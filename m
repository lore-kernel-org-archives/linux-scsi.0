From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 06/10] qla2xxx: Fix crash due to null pointer access.
Date: Sat, 24 Dec 2016 00:06:37 +0000
Message-ID: <D89164F7-0CCC-4627-86CD-9F1D166E1604@cavium.com>
References: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
 <1482357459-31079-7-git-send-email-himanshu.madhani@cavium.com>
 <1482482835.3510.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482482835.3510.7.camel@sandisk.com>
Content-Language: en-US
Content-ID: <89571B6749E3D4489CC25E7B0310BE3C@namprd07.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@infradead.org" <hch@infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>
List-Id: linux-scsi@vger.kernel.org

DQpPbiAxMi8yMy8xNiwgMTI6NDcgQU0sICJCYXJ0IFZhbiBBc3NjaGUiIDxCYXJ0LlZhbkFzc2No
ZUBzYW5kaXNrLmNvbT4gd3JvdGU6DQoNCj5UaGlzIHBhdGNoIG5lZWRzIGEgbW9yZSBkZXRhaWxl
ZCBkZXNjcmlwdGlvbi4gVGhlcmUgYXJlIG1hbnkgY2hhbmdlcyBpbiB0aGlzDQo+cGF0Y2guIFdo
YXQgY2hhbmdlcyBhcmUgdGhlIGNoYW5nZXMgdGhhdCBwcmV2ZW50IHRoZSBOVUxMIHBvaW50ZXIg
ZGVyZWZlcmVuY2U/DQo+V2hhdCBjaGFuZ2VzIChpZiBhbnkpIHdlcmUgbWFkZSBhcyB0aGUgcmVz
dWx0IG9mIGNvZGUgaW5zcGVjdGlvbj8NCg0KV2Ugc2F3IHRoaXMgc3RhY2sgdHJhY2Ugb24gb25l
IHRlc3Qgc2V0dXAgd2hpY2ggbmV2ZXIgd2FzIHJlcHJvZHVjZWQuDQpUaGlzIHBhdGNoIGlzIHJl
c3VsdCBvZiBjb2RlIGluc3BlY3Rpb24gb25seSBhbmQgd2UgaGF2ZSBub3Qgc2VlbiB0aGlzIGJl
aW5nIA0KUmVwcm9kdWNlZCBvciByZXBvcnRlZCBieSBjdXN0b21lci4gDQoNCg==
