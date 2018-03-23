From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2 v2] target: drop spin_lock_assert() + irqs_disabled()
 combo checks
Date: Fri, 23 Mar 2018 17:47:14 +0000
Message-ID: <1521827233.2535.15.camel@wdc.com>
References: <20180321153854.GB24312@kernel.org>
         <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
         <20180322093745.GC4229@kernel.org>
         <20180323155513.dwbgvblenlji33as@linutronix.de>
         <1521822325.2535.5.camel@wdc.com>
         <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
         <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
         <20180323173633.kh5fwrfj6b5elki5@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323173633.kh5fwrfj6b5elki5@linutronix.de>
Content-Language: en-US
Content-ID: <07681E6E0C3FEB4D8675F0958D837123@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "acme@kernel.org" <acme@kernel.org>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTAzLTIzIGF0IDE4OjM2ICswMTAwLCBTZWJhc3RpYW4gQW5kcnplaiBTaWV3
aW9yIHdyb3RlOg0KPiBUaGVyZSBhcmUgYSBmZXcgZnVuY3Rpb25zIHdoaWNoIGNoZWNrIGZvciBp
ZiB0aGUgbG9jayBpcyBoZWxkDQo+IChzcGluX2xvY2tfYXNzZXJ0KCkpIGFuZCB0aGUgaW50ZXJy
dXB0cyBhcmUgZGlzYWJsZWQgKGlycXNfZGlzYWJsZWQoKSkuDQo+ID4gRnJvbSBsb29raW5nIGF0
IHRoZSBjb2RlLCBlYWNoIGZ1bmN0aW9uIGlzIHN0YXRpYywgdGhlIGNhbGxlciBpcyBuZWFyIGJ5
DQo+IA0KPiBhbmQgZG9lcyBzcGluX2xvY2tfaXJxfHNhZmUoKS4gQXMgTGludXMgcHV0cyBpdDoN
Cj4gDQo+ID4gSXQncyBub3QgbGlrZSB0aGlzIGlzIHNvbWUgZnVuY3Rpb24gdGhhdCBpcyBleHBv
cnRlZCB0byByYW5kb20gdXNlcnMsDQo+ID4gYW5kIHdlIHNob3VsZCBjaGVjayB0aGF0IHRoZSBj
YWxsaW5nIGNvbnZlbnRpb24gaXMgcmlnaHQuDQo+ID4gDQo+ID4gVGhpcyBsb29rcyBsaWtlICJp
dCBtYXkgaGF2ZSBiZWVuIHVzZWZ1bCBkdXJpbmcgY29kaW5nIHRvIGRvY3VtZW50DQo+ID4gdGhp
bmdzLCBidXQgaXQncyBub3QgdXNlZnVsIGxvbmctdGVybSIuDQo+IA0KPiBSZW1vdmUgdGhvc2Ug
Y2hlY2tzLg0KDQpSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxiYXJ0LnZhbmFzc2NoZUB3
ZGMuY29tPg0KDQoNCg0K
