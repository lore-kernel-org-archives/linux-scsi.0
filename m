From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/9] qla2xxx: Move cmd search out of qla during ABTS
Date: Mon, 19 Dec 2016 16:29:57 +0000
Message-ID: <1482164975.25336.8.camel@sandisk.com>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
         <1482051769-22941-2-git-send-email-himanshu.madhani@cavium.com>
         <1482161586.25336.3.camel@sandisk.com>
         <20161219155939.GA3002@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20161219155939.GA3002@infradead.org>
Content-Language: en-US
Content-ID: <6E2D46D7F7C5C9478088A097FD1E4909@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE2LTEyLTE5IGF0IDA3OjU5IC0wODAwLCBoY2hAaW5mcmFkZWFkLm9yZyB3cm90
ZToNCj4gT24gTW9uLCBEZWMgMTksIDIwMTYgYXQgMDM6MzM6MjdQTSArMDAwMCwgQmFydCBWYW4g
QXNzY2hlIHdyb3RlOg0KPiA+IFBsZWFzZSBjb25zaWRlciByZW1vdmluZyB0aGUgc2Vzc19jbWRf
bGlzdCBsb29wLiBBbnkgbG9va3VwcyBpbg0KPiA+IHNlc3NfY21kX2xpc3Qgc2hvdWxkIGJlIHBl
cmZvcm1lZCBieSB0aGUgdGFyZ2V0IGNvcmUgYW5kIG5vdCBieSBhDQo+ID4gdGFyZ2V0IGRyaXZl
ci4gQXJlIHlvdSBhd2FyZSB0aGF0IGNvcmVfdG1yX2Fib3J0X3Rhc2soKSBwZXJmb3JtcyBhIHZl
cnkNCj4gPiBzaW1pbGFyIGxvb2t1cCB0byB0aGUgb25lIGFib3ZlPw0KPiANCj4gVGhpcyB3YXMg
bXkgZmlyc3QgcmVhY3Rpb24gYXMgd2VsbCwgYnV0IGl0IHNlZW1zIGxpa2UgcWxhMnh4eCBoYXJk
d2FyZQ0KPiBkb2Vzbid0IHBhc3MgdXAgdGhlIExVTiBmb3IgYW4gYWJvcnQgcmVxdWVzdC4gIElm
IHRoYXQncyByZWFsbHkgdGhlDQo+IGNhc2UgKHdoaWNoIHNlZW1zIHJlYWxseSBvZGQgdG8gbWUp
IHdlJ2xsIG5lZWQgdGhpcyBsb29wLiAgSWYgdGhlcmUgaXMgYQ0KPiB3YXkgdG8gZ2V0IHRoZSBs
dW4gb3V0IG9mIHRoZSBoYXJkd2FyZSBpdCB3b3VsZCBiZSBwcmVmZXJhYmxlIHRvIG1ha2UNCj4g
dXNlIG9mIHRoYXQgcGFzc2VkIHVwIGx1bi4NCg0KSGVsbG8gQ2hyaXN0b3BoLA0KDQpUaGUgU0NT
SSBBcmNoaXRlY3R1cmUgTWFudWFsIChTQU0tNikgc3BlY2lmaWVzIHRoYXQgdGhlIFNDU0kgdHJh
bnNwb3J0DQpwcm90b2NvbCBkZWZpbmVzIHdoZXRoZXIgdGhlIHNjb3BlIG9mIHRoZSBBQk9SVCBU
QVNLIHRhc2sgbWFuYWdlbWVudA0KZnVuY3Rpb24gaXMgSV9UX0wgb3IgSV9ULiBJbiB0aGUgRmli
cmUgQ2hhbm5lbCBQcm90b2NvbCBmb3IgU0NTSSAoRkNQKQ0KZG9jdW1lbnQgSSByZWFkwqB0aGF0
IGZvciBGQyBBQk9SVCBUQVNLIGNvcnJlc3BvbmRzIHRvIHRoZSBBQlRTLUxTDQpmcmFtZS4gQXMg
ZmFyIGFzIEkga25vdyBubyBMVU4gaW5mb3JtYXRpb24gaXMgcHJlc2VudCBpbiB0aGUgRkMgQUJU
Uw0KZnJhbWUuIEkgdGhpbmsgdGhpcyBtZWFucyB0aGF0IHRhcmdldF9zdWJtaXRfdG1yKCkgc2hv
dWxkIGJlIG1vZGlmaWVkDQpzdWNoIHRoYXQgaXQgc3VwcG9ydHMgIkxVTiBub3Qgc3BlY2lmaWVk
Ii4NCg0KQmFydC4=
