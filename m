From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature
 termination"
Date: Sun, 15 Jan 2017 22:02:51 +0000
Message-ID: <1484517756.11850.1.camel@sandisk.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
         <20170115091925.GA26656@gmail.com>
         <1484496665.2405.2.camel@HansenPartnership.com>
         <CA+55aFweyFstUaKGdg6A9p65URrzZAJNBCF8ou0MfKb4EPL=Rw@mail.gmail.com>
         <1484507599.2405.16.camel@HansenPartnership.com>
         <CA+55aFyyBf9SLSNDRqMcFbmUBBkbamZYXGOgfXU8k5KYaFD2mw@mail.gmail.com>
         <1484509776.2405.21.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0070.outbound.protection.outlook.com ([104.47.38.70]:54006
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751068AbdAOWC7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Jan 2017 17:02:59 -0500
In-Reply-To: <1484509776.2405.21.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <9DCAB195A2D3124E8D46AD9418E36985@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>

T24gU3VuLCAyMDE3LTAxLTE1IGF0IDExOjQ5IC0wODAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IE9uIFN1biwgMjAxNy0wMS0xNSBhdCAxMTo0MSAtMDgwMCwgTGludXMgVG9ydmFsZHMgd3Jv
dGU6DQo+ID4gT24gU3VuLCBKYW4gMTUsIDIwMTcgYXQgMTE6MTMgQU0sIEphbWVzIEJvdHRvbWxl
eQ0KPiA+IDxKYW1lcy5Cb3R0b21sZXlAaGFuc2VucGFydG5lcnNoaXAuY29tPiB3cm90ZToNCj4g
PiA+IA0KPiA+ID4gQ2FuIHdlIGNvbXByb21pc2Ugb24gInRyeSBub3QgdG8gcmV2ZXJ0IGEgZml4
IC4uLiIuDQo+ID4gDQo+ID4gTm8uDQo+ID4gDQo+ID4gSXQncyBhYm91dCB0aW1pbmcsIGFuZCBh
Ym91dCBob3cgc2VyaW91cyB0aGUgcmVncmVzc2lvbiBpcy4NCj4gPiANCj4gPiBGb3IgZXhhbXBs
ZSwgaWYgdGhpcyBoYXBwZW5lZCBpbiByYzcsIEkgd291bGQgaGF2ZSByZXZlcnRlZA0KPiA+IGlt
bWVkaWF0ZWx5LiBObyBxdWVzdGlvbnMgYXNrZWQuDQo+ID4gDQo+ID4gSW4gdGhpcyBjYXNlLCB0
aGUgImZpeCIgd2FzIHdhcyBhbHNvIG11Y2ggbGVzcyBpbXBvcnRhbnQgdGhlbiB0aGUNCj4gPiBw
cm9ibGVtIGl0IGNhdXNlZC4gU29tZSBzcGVjaWFsaXplZCBwYXNzLXRocm91Z2ggY29tbWFuZCBu
b3QNCj4gPiB3b3JraW5nDQo+ID4gcmlnaHQsIHZzIGEgbWFjaGluZSBub3QgZXZlbiBib290aW5n
PyBUaGVyZSdzIGp1c3Qgbm8gcXVlc3Rpb24NCj4gPiB3aGF0LXNvLWV2ZXIuDQo+ID4gDQo+ID4g
U28gdGhlICJmaXgiIHlvdSBjbGFpbSBqdXN0IHdhc24ndCBuZWFybHkgaW1wb3J0YW50IGVub3Vn
aC4gSXQgd2FzDQo+ID4gYWxzbyBwcmV0dHkgcmVjZW50IGFuZCBjbGVhcmx5IHRoaW5ncyBoYWQg
d29ya2VkIGZvciBfeWVhcnNfDQo+ID4gd2l0aG91dA0KPiA+IGl0Lg0KPiA+IA0KPiA+IEluIGZh
Y3QsIEknbSBzdGlsbCBzb21ld2hhdCBpbmNsaW5lZCB0byByZXZlcnQgaXQsIGp1c3QgdG8gaGF2
ZSBhDQo+ID4gd29ya2luZyByYzQgcmVsZWFzZSBsYXRlciB0b2RheS4gQnV0IEknbSBob3Bpbmcg
bWF5YmUgSW5nbyBoYXMNCj4gPiB0aW1lwqANCj4gPiB0byB0ZXN0IHRoaW5ncyAoYWx0aG91Z2gg
SSBzdXNwZWN0IGhlJ3MgYWxyZWFkeSBhc2xlZXApLg0KPiANCj4gT0ssIHNvIHRoZSBwYXRjaCB0
byByZXZlcnQgd291bGQgYWN0dWFsbHkgYmUNCj4gDQo+IGNvbW1pdCA2NjlmMDQ0MTcwZDg5MzNj
M2Q2NmQyMzFiNjllYTk3Y2I4NDQ3MzM4DQo+IEF1dGhvcjogQmFydCBWYW4gQXNzY2hlIDxiYXJ0
LnZhbmFzc2NoZUBzYW5kaXNrLmNvbT4NCj4gRGF0ZTrCoMKgwqBUdWUgTm92IDIyIDE2OjE3OjEz
IDIwMTYgLTA4MDANCj4gDQo+IMKgwqDCoMKgc2NzaTogc3JwX3RyYW5zcG9ydDogTW92ZSBxdWV1
ZWNvbW1hbmQoKSB3YWl0IGNvZGUgdG8gU0NTSSBjb3JlDQo+IA0KPiBCZWNhdXNlIHRoYXQgY2hh
bmdlIGluIHRoZSB3YWl0IGNvZGUgYnJva2UgdGhlICJmaXgiIGluIG1wdDNzYXMuwqANCj4gQmVm
b3JlIHRoYXQgd2FzIGFwcGxpZWQsIGl0IGFjdHVhbGx5IHdvcmtlZCBldmVuIHRob3VnaCBJIHRo
aW5rIGl0J3MNCj4gYSB3cm9uZyBmaXguDQoNCkhlbGxvIEphbWVzLA0KDQpJIGRpc2FncmVlLsKg
RXZlbiBpZiBteSBwYXRjaCB3b3VsZCBiZSByZXZlcnRlZCB0aGF0IHN0aWxsIHdvdWxkbid0IGZp
eA0KdGhlIHNldmVyZSByYWNlIGNvbmRpdGlvbiB0aGF0IHdhcyBpbnRyb2R1Y2VkIGluIHRoZSBt
cHQzc2FzIGRyaXZlciBieQ0KdGhlIHBhdGNoIHRoYXQgdHJpZ2dlcnMgdGhlIGxvY2t1cCBkdXJp
bmcgYm9vdC4gQXMgSSBleHBsYWluZWQgdHdvDQp3ZWVrcyBhZ28gKHNlZSBhbHNvIGh0dHBzOi8v
d3d3LnNwaW5pY3MubmV0L2xpc3RzL2tlcm5lbC9tc2cyNDExNDEzLmh0bQ0KbCksIGNvbW1pdCAx
OGY2MDg0YTk4OWIgKCJzY3NpOiBtcHQzc2FzOiBGaXggc2VjdXJlIGVyYXNlIHByZW1hdHVyZQ0K
dGVybWluYXRpb24iKSBpcyB0aGUgb25lIHRoYXQgc2hvdWxkIGJlIHJldmVydGVkIGluc3RlYWQg
b2YgbXkgcGF0Y2guIEkNCmFncmVlIHdpdGggTGludXMgdGhhdCB0aGUgb2ZmZW5kaW5nIG1wdDNz
YXMgcGF0Y2ggYWxyZWFkeSBzaG91bGQgaGF2ZQ0KYmVlbiByZXZlcnRlZC4NCg0KQmFydC4=
