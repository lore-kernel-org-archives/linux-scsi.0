From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Wed, 10 Jan 2018 16:22:15 +0000
Message-ID: <1515601333.2745.8.camel@wdc.com>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
         <20180108100531.GA6967@infradead.org>
         <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:62772 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965828AbeAJQWW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 11:22:22 -0500
In-Reply-To: <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
Content-Language: en-US
Content-ID: <D441A586F79EBD4DBB4B86C153A14282@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "shivasharan.srikanteshwara@broadcom.com" <shivasharan.srikanteshwara@broadcom.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>, "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>

T24gVHVlLCAyMDE4LTAxLTA5IGF0IDIyOjA3ICswNTMwLCBLYXNoeWFwIERlc2FpIHdyb3RlOg0K
PiBPdmVyYWxsIE5WTUUgc3VwcG9ydCBiZWhpbmQgTVIgY29udHJvbGxlciBpcyByZWFsbHkgYSBT
Q1NJIGRldmljZS4gT24gdG9wDQo+IG9mIHRoYXQsIGZvciBNZWdhUmFpZCwgTlZNRSBkZXZpY2Ug
Y2FuIGJlIHBhcnQgb2YgVmlydHVhbCBEaXNrIGFuZCB0aG9zZQ0KPiBkcml2ZSB3aWxsIG5vdCBi
ZSBleHBvc2VkIHRvIHRoZSBkcml2ZXIuIFVzZXIgYXBwbGljYXRpb24gbWF5IGxpa2UgdG8gdGFs
aw0KPiB0byBoaWRkZW4gTlZNRSBkZXZpY2VzIChwYXJ0IG9mIFZEcykuIFRoaXMgcGF0Y2ggd2ls
bCBleHRlbmQgdGhlIGV4aXN0aW5nDQo+IGludGVyZmFjZSBmb3IgbWVnYXJhaWQgcHJvZHVjdCBp
biB0aGUgc2FtZSB3YXkgaXQgaXMgY3VycmVudGx5IHN1cHBvcnRlZA0KPiBmb3Igb3RoZXIgcHJv
dG9jb2xzIGxpa2UgU01QLCBTQVRBIHBhc3MtdGhyb3VnaC4NCg0KSXQgc2VlbXMgdG8gbWUgbGlr
ZSB0aGVyZSBpcyBhIGNvbnRyYWRpY3Rpb24gaW4gdGhlIGFib3ZlIHBhcmFncmFwaDogaWYgc29t
ZQ0KTlZNZSBkZXZpY2VzIGFyZSBub3QgZXhwb3NlZCB0byB0aGUgZHJpdmVyLCBob3cgY2FuIGEg
dXNlciBzcGFjZSBhcHBsaWNhdGlvbg0KZXZlciBzZW5kIE5WTWUgY29tbWFuZHMgdG8gaXQ/DQoN
CkFueXdheSwgaGFzIGl0IGJlZW4gY29uc2lkZXJlZCB0byBpbXBsZW1lbnQgdGhlIE5WTWUgc3Vw
cG9ydCBhcyBhbiBOVk1lDQp0cmFuc3BvcnQgZHJpdmVyPyBUaGUgdXBzdHJlYW0ga2VybmVsIGFs
cmVhZHkgc3VwcG9ydHMgTlZNZSBjb21tdW5pY2F0aW9uDQp3aXRoIE5WTWUgUENJIGRldmljZXMs
IE5WTWUgb3ZlciBSRE1BIGFuZCBOVk1lIG92ZXIgRkMuIElmIGNvbW11bmljYXRpb24gdG8NCnRo
ZSBOVk1lIGRldmljZXMgYmVoaW5kIHRoZSBNZWdhUmFpZCBjb250cm9sbGVyIHdvdWxkIGJlIGlt
cGxlbWVudGVkIGFzIGFuDQpOVk1lIHRyYW5zcG9ydCBkcml2ZXIgdGhlbiBhbGwgZnVuY3Rpb25h
bGl0eSBvZiB0aGUgTGludXggTlZNZSBkcml2ZXIgY291bGQNCmJlIHJldXNlZCwgaW5jbHVkaW5n
IGl0cyBzeXNmcyBlbnRyaWVzLg0KDQpCYXJ0Lg==
