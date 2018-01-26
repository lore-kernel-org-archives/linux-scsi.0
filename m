From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi_debug: Use scsi-mq if it has been enabled
Date: Fri, 26 Jan 2018 16:10:17 +0000
Message-ID: <1516983017.2651.4.camel@wdc.com>
References: <20180124003958.3945-1-bart.vanassche@wdc.com>
         <20180126075837.GF2356@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:13641 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753836AbeAZQKU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 11:10:20 -0500
In-Reply-To: <20180126075837.GF2356@lst.de>
Content-Language: en-US
Content-ID: <5B11EEDF69C10A44982C39CAFAB28265@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gRnJpLCAyMDE4LTAxLTI2IGF0IDA4OjU4ICswMTAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gc2NzaV9kZWJ1ZyBhbHJlYWR5IGFsd2F5cyB1c2VzIHNjc2ktbXEgaWYgZW5hYmxlZC4g
IFRoZSBzb21ld2hhdA0KPiBtaXNuYW1lZCBzZGVidWdfbXFfYWN0aXZlIHZhcmlhYmxlIGlzIG9u
bHkgdXNlZCBmb3IgZGVjb2RpbmcNCj4gbXVsdGlxdWV1ZSB0YWdzLiAgVGhhdCBiZWluZyBzYWlk
IHRoZSBibGtfbXFfdW5pcXVlX3RhZyogaGVscGVycw0KPiBzaG91bGQgYmUgc2FmZSB0byB1c2Ug
ZXZlbiB3aXRob3V0IGJsay1tcSwgc28gdGhlIHZhcmlhYmxlIGNvdWxkDQo+IHByb2JhYmx5IGp1
c3QgYmUgcmVtb3ZlZCBlbnRpcmVseS4NCg0KSGVsbG8gQ2hyaXN0b3BoLA0KDQpSZW1vdmluZyBz
ZGVidWdfbXFfYWN0aXZlIHNvdW5kcyBsaWtlIGEgZ29vZCBpZGVhIHRvIG1lLiBJIHdpbGwgcmV3
b3JrIHRoaXMNCnBhdGNoLg0KDQpCYXJ0Lg==
