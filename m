From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 4/4] sd: use async_probe cookie to avoid deadlocks
Date: Thu, 14 Dec 2017 22:13:19 +0000
Message-ID: <1513289597.2475.86.camel@sandisk.com>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
         <1513069072-32514-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48123 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752886AbdLNWNW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 17:13:22 -0500
In-Reply-To: <1513069072-32514-5-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <51582C93A1ABF34DAC3C003CF3CD984B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

T24gVHVlLCAyMDE3LTEyLTEyIGF0IDA5OjU3ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
DQo+IFdpdGggdGhlIGN1cnJlbnQgZGVzaWduIHdlJ3JlIHdhaXRpbmcgZm9yIGFsbCBhc3luYyBw
cm9iZXMgdG8NCj4gZmluaXNoIHdoZW4gcmVtb3ZpbmcgYW55IHNkIGRldmljZS4NCj4gVGhpcyBt
aWdodCBsZWFkIHRvIGEgbGl2ZWxvY2sgd2hlcmUgdGhlICdyZW1vdmUnIGNhbGwgaXMgYmxvY2tp
bmcNCj4gZm9yIGFueSBwcm9iZSBjYWxscyB0byBmaW5pc2gsIGFuZCB0aGUgcHJvYmUgY2FsbHMg
YXJlIHdhaXRpbmcgZm9yDQo+IGEgcmVzcG9uc2UsIHdoaWNoIHdpbGwgbmV2ZXIgYmUgcHJvY2Vz
c2VzIGFzIHRoZSB0aHJlYWQgaGFuZGxpbmcNCj4gdGhlIHJlc3BvbnNlcyBpcyB3YWl0aW5nIGZv
ciB0aGUgcmVtb3ZlIGNhbGwgdG8gZmluaXNoLg0KPiBXaGljaCBpcyBjb21wbGV0ZWx5IHBvaW50
bGVzcyBhcyB3ZSBvbmx5IF9yZWFsbHlfIGNhcmUgZm9yIHRoZQ0KPiBwcm9iZSBvbiBfdGhpc18g
ZGV2aWNlIHRvIGJlIGNvbXBsZXRlZDsgYW55IG90aGVyIHByb2JpbmcgY2FuDQo+IGhhcHBpbHkg
Y29udGludWUgZm9yIGFsbCB3ZSBjYXJlLg0KPiBTbyBzYXZlIHRoZSBhc3luYyBwcm9iaW5nIGNv
b2tpZSBpbiB0aGUgc3RydWN0dXJlIGFuZCBvbmx5IHdhaXQNCj4gaWYgdGhpcyBzcGVjaWZpYyBw
cm9iZSBpcyBzdGlsbCBhY3RpdmUuDQoNCkZyb20gYXN5bmNfc3luY2hyb25pemVfY29va2llX2Rv
bWFpbigpOg0KDQoJd2FpdF9ldmVudChhc3luY19kb25lLCBsb3dlc3RfaW5fcHJvZ3Jlc3MoZG9t
YWluKSA+PSBjb29raWUpOw0KDQpTbyBhc3luY19zeW5jaHJvbml6ZV9jb29raWVfZG9tYWluKCkg
YWxzbyB3YWl0cyBmb3IgbXVsdGlwbGUgYXN5bmNocm9ub3VzDQpwcm9iZXMgdG8gZmluaXNoLiBE
b2VzIHRoaXMgcGF0Y2ggaGF2ZSBhbnkgYWR2YW50YWdlcyBvdmVyIHRoZSBwYXRjaCBJDQpwb3N0
ZWQgKGh0dHBzOi8vbWFyYy5pbmZvLz9sPWxpbnV4LXNjc2kmbT0xNTEyNzUzNjg3MTQ1NDApPw0K
DQpUaGFua3MsDQoNCkJhcnQu
