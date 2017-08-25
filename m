From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 07/19] Fix RCU handling of scsi_device.vpd_pg8[03]
Date: Fri, 25 Aug 2017 20:04:11 +0000
Message-ID: <1503691451.2680.16.camel@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
         <20170823214009.15015-8-bart.vanassche@wdc.com>
         <20170824090718.GG19886@lst.de> <1503593651.2702.16.camel@wdc.com>
         <AT5PR84MB0308689A9E2AA2461DEB35A0FD9B0@AT5PR84MB0308.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2564 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932644AbdHYUE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:04:59 -0400
In-Reply-To: <AT5PR84MB0308689A9E2AA2461DEB35A0FD9B0@AT5PR84MB0308.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-ID: <DD2D7B4AE5C7D5489FDD1B6B265C86F6@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gRnJpLCAyMDE3LTA4LTI1IGF0IDA1OjU4ICswMDAwLCBTZXltb3VyLCBTaGFuZSBNIHdyb3Rl
Og0KPiA+IEZyb206IEJhcnQgVmFuIEFzc2NoZSBbbWFpbHRvOkJhcnQuVmFuQXNzY2hlQHdkYy5j
b21dDQo+ID4gWyAuLi4gXQ0KPiA+IE15IHVuZGVyc3RhbmRpbmcgb2YgdGhlIFNDU0kgVlBEIGNv
ZGUgaXMgYXMgZm9sbG93czoNCj4gPiAqIHJjdV9yZWFkX2xvY2soKSAvIHJjdV9yZWFkX3VubG9j
aygpIGlzIHVzZWQgdG8gcHJldmVudCB0aGF0IGFub3RoZXIgdGhyZWFkDQo+ID4gICB1cGRhdGVz
IGEgVlBEIGJ1ZmZlciB3aGlsZSBpdCBpcyBiZWluZyByZWFkLg0KPiANCj4gTXkgdW5kZXJzdGFu
ZGluZyBpcyB0aGF0IGl0IGRvZXNuJ3QgZG8gdGhhdCAtIHlvdSBjYW4gdXBkYXRlIGFuIFJDVSBw
b2ludGVyDQo+IHdpdGggcmN1X2Fzc2lnbl9wb2ludGVyKCkgYWZ0ZXIgc29tZW9uZSBoYXMgY2Fs
bGVkIHJjdV9yZWFkX2xvY2soKSBhbmQgYmVmb3JlDQo+IHRoZXkgY2FsbCByY3VfcmVhZF91bmxv
Y2soKS4gDQoNCkhlbGxvIFNoYW5lLA0KDQpZb3UgaGF2ZSBlaXRoZXIgbWlzaW50ZXJwcmV0IG15
IHN0YXRlbWVudCBvciB0aGUgU0NTSSBWUEQgaGFuZGxpbmcgY29kZS4gSWYgeW91DQpoYXZlIGEg
bG9vayBhdCB0aGUgU0NTSSBWUEQgaGFuZGxpbmcgY29kZSB5b3Ugd2lsbCBzZWUgdGhhdCBhbiBy
Y3VfcmVhZF9sb2NrKCkgLw0KcmN1X3JlYWRfdW5sb2NrKCkgcGFpciBpcyBzdWZmaWNpZW50IHRv
IHByZXZlbnQgdGhhdCB0aGUgVlBEIGJ1ZmZlciByY3VfZGVyZWZlcmVuY2UoKQ0KcG9pbnRzIGF0
IGlzIGJlaW5nIG1vZGlmaWVkIGFzIGxvbmcgYXMgdGhlIFJDVSByZWFkIGxvY2sgaXMgaGVsZCwg
YXQgbGVhc3QgaWYNCnJjdV9kZXJlZmVyZW5jZSgpIGlzIG9ubHkgY2FsbGVkIG9uY2UuIFRoZSB1
cGRhdGUgc2lkZSBuYW1lbHkgZG9lcyBub3QgbW9kaWZ5IHRoZQ0KVlBEIGJ1ZmZlciBhZnRlciB0
aGUgcG9pbnRlciB0byB0aGF0IGJ1ZmZlciBoYXMgYmVlbiBwdWJsaXNoZWQuDQoNCj4gSXQgaXMg
cG9zc2libGUgSSBtYXkgYmUgYmVpbmcgdG9vIHBpY2t5IChpdCdzIGEgcGVyc29uYWwgZmFpbGlu
ZyBzb21ldGltZXMpDQo+IGJ1dCBpcyBpdCByZWFsbHkgdGhhdCBhIGxhcmdlIG92ZXJoZWFkIHRv
IGZyZWUgdGhlIFJDVSBwb2ludGVycyBpbiBhIHdheSB0aGF0DQo+IFJDVSBwb2ludGVycyBhcmUg
ZXhwZWN0ZWQgdG8gd29yayBldmVuIGlmIHRoZSBwb2ludGVycyBzaG91bGRuJ3QgYmUgYWNjZXNz
aWJsZQ0KPiB0byBhbnl0aGluZz8NCg0KU3dpdGNoaW5nIHRvIGtmcmVlX3JjdSgpIHJlcXVpcmVz
IG1vcmUgY2hhbmdlcyBiZWNhdXNlIGFsbCB1bnNpZ25lZCBjaGFyIHBvaW50ZXJzDQp0byBWUEQg
ZGF0YSBoYXZlIHRvIGJlIGNvbnZlcnRlZCBpbnRvIHBvaW50ZXJzIHRvIGEgc3RydWN0dXJlIHRo
YXQgY29udGFpbnMgdGhlDQpWUEQgZGF0YSBhbmQgdGhlIFJDVSBoZWFkLiBBbnl3YXksIEkgd2ls
bCBjb252ZXJ0IHRoZSBrZnJlZSgpIGNhbGxzIHRvIFJDVSBwb2ludGVycw0KaW50byBrZnJlZV9y
Y3UoKSBwb2ludGVycy4NCg0KQmFydC4=
