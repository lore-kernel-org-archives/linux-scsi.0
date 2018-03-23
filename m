From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Fri, 23 Mar 2018 16:25:25 +0000
Message-ID: <1521822325.2535.5.camel@wdc.com>
References: <20180321153854.GB24312@kernel.org>
         <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
         <20180322093745.GC4229@kernel.org>
         <20180323155513.dwbgvblenlji33as@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323155513.dwbgvblenlji33as@linutronix.de>
Content-Language: en-US
Content-ID: <0E43EC1815970742906861AF2E51524A@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "acme@kernel.org" <acme@kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTAzLTIzIGF0IDE2OjU1ICswMTAwLCBTZWJhc3RpYW4gQW5kcnplaiBTaWV3
aW9yIHdyb3RlOg0KPiBJIGFtIGdvaW5nIHRha2UgdGhpcyBpbnRvIC1SVCB0cmVlIGZvciBub3cg
dW50aWwgd2UgaGF2ZSBkaWZmZXJlbnQNCj4gc29sdXRpb24uDQoNCkhhdmUgeW91IGNvbnNpZGVy
ZWQgdG8gZGVsZXRlIHRoZSBXQVJOX09OX09OQ0UoIWlycXNfZGlzYWJsZWQoKSkgc3RhdGVtZW50
Pw0KSSB0aGluayB0aGF0IGNoZWNrIGR1cGxpY2F0ZXMgZnVuY3Rpb25hbGl0eSB0aGF0IGFscmVh
ZHkgZXhpc3RzIGluIGxvY2tkZXANCnNpbmNlIGxvY2tkZXAgaXMgYWxyZWFkeSBhYmxlIHRvIGRl
dGVjdCBzcGlubG9jayB1c2UgaW5jb25zaXN0ZW5jaWVzLg0KDQpCYXJ0Lg0KDQoNCg==
