From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] target: remove spin_lock_assert() in
 __target_(attach|detach)_tg_pt_gp()
Date: Fri, 23 Mar 2018 17:44:46 +0000
Message-ID: <1521827085.2535.12.camel@wdc.com>
References: <20180321153854.GB24312@kernel.org>
         <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
         <20180322093745.GC4229@kernel.org>
         <20180323155513.dwbgvblenlji33as@linutronix.de>
         <1521822325.2535.5.camel@wdc.com>
         <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
         <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
         <20180323171959.7ac6klrqg4fdk3ey@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180323171959.7ac6klrqg4fdk3ey@linutronix.de>
Content-Language: en-US
Content-ID: <B0EF4A7A86E3864C8F349081FE016E90@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "acme@kernel.org" <acme@kernel.org>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE4LTAzLTIzIGF0IDE4OjE5ICswMTAwLCBiaWdlYXN5QGxpbnV0cm9uaXguZGUg
d3JvdGU6DQo+IF9fdGFyZ2V0X2F0dGFjaF90Z19wdF9ncCgpIGFuZCBfX3RhcmdldF9kZXRhY2hf
dGdfcHRfZ3AoKSBjaGVjayBpZiB0aGUgY2FsbGVyDQo+IGhvbGRzIGx1bl90Z19wdF9ncF9sb2Nr
KCkuIEJvdGggZnVuY3Rpb25zIGFyZSBzdGF0aWMsIHRoZSBjYWxsZXJzIGFyZQ0KPiBhY3F1aXJp
bmcgdGhlIGxvY2sgYmVmb3JlIHRoZSBpbnZvY2F0aW9uIG9mIHRoZSBmdW5jdGlvbiBzbyB0aGUg
Y2hlY2sNCj4gbG9va3Mgc3VwZXJmbHVvdXMuDQo+IFJlbW92ZSBpdC4NCg0KRG9lcyB0aGlzIGNo
ZWNrIGNhdXNlIHRyb3VibGUgdG8gYW55b25lIG9yIHRvIGEgc3BlY2lmaWMga2VybmVsIGNvbmZp
Z3VyYXRpb24/DQpJbiBvdGhlciB3b3JkcywgZG8gd2UgcmVhbGx5IG5lZWQgdG8gcmVtb3ZlIHRo
ZXNlIGNoZWNrcz8gSSB0aGluayB0aGF0IHRoZXNlDQpjaGVja3MgYXJlIHVzZWZ1bCBhcyBkb2N1
bWVudGF0aW9uIHRvIHBlb3BsZSB3aG8gcmVhZCB0aGUgU0NTSSB0YXJnZXQgY29kZS4NClRoZSB0
YXJnZXQgY29kZSBpcyBhbHJlYWR5IGhhcmQgdG8gZm9sbG93IHNvIEkgdGhpbmsgYW55IGRvY3Vt
ZW50YXRpb24sDQplc3BlY2lhbGx5IGRvY3VtZW50YXRpb24gaW4gdGhlIGZvcm0gb2YgY29kZSB0
aGF0IGlzIGNoZWNrZWQgYXQgcnVudGltZSwgaXMNCndlbGNvbWUuDQoNClRoYW5rcywNCg0KQmFy
dC4NCg0KDQoNCg==
