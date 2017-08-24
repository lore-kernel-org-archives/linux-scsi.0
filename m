From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 07/19] Fix RCU handling of scsi_device.vpd_pg8[03]
Date: Thu, 24 Aug 2017 16:54:12 +0000
Message-ID: <1503593651.2702.16.camel@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
         <20170823214009.15015-8-bart.vanassche@wdc.com>
         <20170824090718.GG19886@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33225 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752774AbdHXQy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2017 12:54:58 -0400
In-Reply-To: <20170824090718.GG19886@lst.de>
Content-Language: en-US
Content-ID: <68CA8E9C4423A6489AD8D9740A1F3372@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>

T24gVGh1LCAyMDE3LTA4LTI0IGF0IDExOjA3ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gV2VkLCBBdWcgMjMsIDIwMTcgYXQgMDI6Mzk6NTdQTSAtMDcwMCwgQmFydCBWYW4g
QXNzY2hlIHdyb3RlOg0KPiA+IE9ubHkgYW5ub3RhdGUgcG9pbnRlcnMgdGhhdCBhcmUgc2hhcmVk
IGFjcm9zcyB0aHJlYWRzIHdpdGggX19yY3UuDQo+ID4gVXNlIHJjdV9kZXJlZmVyZW5jZSgpIHdo
ZW4gZGVyZWZlcmVuY2luZyBhbiBSQ1UgcG9pbnRlci4gUHJvdGVjdA0KPiA+IGFsc28gdGhlIFJD
VSBwb2ludGVyIGRlcmVmZXJlbmNlcyB3aGVuIGZyZWVpbmcgUkNVIHBvaW50ZXJzLiBUaGlzDQo+
ID4gcGF0Y2ggc3VwcHJlc3NlcyBhYm91dCB0d2VudHkgc3BhcnNlIGNvbXBsYWludHMgYWJvdXQg
dGhlIHZwZF9wZzhbMDNdDQo+ID4gcG9pbnRlcnMuDQo+IA0KPiBTaG91bGRuJ3QgdGhlIGtmcmVl
cyBiZSBrZnJlZV9yY3U/ICBvciB3aGVyZSBlbHNlIGlzIHRoZSByY3UgcHJvdGVjdGlvbg0KPiBm
b3IgdGhlbT8NCg0KSGVsbG8gQ2hyaXN0b3BoLA0KDQpNeSB1bmRlcnN0YW5kaW5nIG9mIHRoZSBT
Q1NJIFZQRCBjb2RlIGlzIGFzIGZvbGxvd3M6DQoqIHJjdV9yZWFkX2xvY2soKSAvIHJjdV9yZWFk
X3VubG9jaygpIGlzIHVzZWQgdG8gcHJldmVudCB0aGF0IGFub3RoZXIgdGhyZWFkDQogIHVwZGF0
ZXMgYSBWUEQgYnVmZmVyIHdoaWxlIGl0IGlzIGJlaW5nIHJlYWQuDQoqIEFsbCBjb2RlIHRoYXQg
ZWl0aGVyIHVwZGF0ZXMgb3IgcmVhZHMgYSBWUEQgYnVmZmVyIGhvbGRzIGEgcmVmZXJlbmNlIG9u
DQogIHRoZSBTQ1NJIGRldmljZSB0aGF0IGJ1ZmZlciBpcyBhc3NvY2lhdGVkIHdpdGguIFRoYXQg
aXMgd2h5IEkgdGhpbmsgaXQgaXMNCiAgbm90IG5lZWRlZCB0byB1c2Uga2ZyZWVfcmN1KCkgaW4g
c2NzaV9kZXZpY2VfZGV2X3JlbGVhc2VfdXNlcmNvbnRleHQoKS4NCg0KQmFydC4NCiAg
