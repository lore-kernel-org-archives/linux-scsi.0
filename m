From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi_transport_sas: Fix error handling in
 sas_smp_request()
Date: Fri, 25 Aug 2017 15:38:48 +0000
Message-ID: <1503675527.2680.1.camel@wdc.com>
References: <20170823182558.15370-1-bart.vanassche@wdc.com>
         <20170825153529.GB18440@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:8732 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933386AbdHYPjg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 11:39:36 -0400
In-Reply-To: <20170825153529.GB18440@lst.de>
Content-Language: en-US
Content-ID: <6FE7F35B78A665448A1E29D99093188B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>

T24gRnJpLCAyMDE3LTA4LTI1IGF0IDE3OjM1ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gSSBsb29rZWQgYSBiaXQgbW9yZSBhdCB0aGUgaGlzdG9yeSBvZiB0aGlzLCBhbmQgaXQg
c2VlbXMgbGlrZSB0aGUgb25seQ0KPiBpc3N1ZSB3aXRoIGNvbW1pdCAxN2Q1MzYzYjgzZjggaGVy
ZSBpcyB1c2luZyB0aGUgYmxrX3N0YXR1c190IHR5cGUgZm9yIHRoZQ0KPiByZXQgdmFyaWFibGUu
ICBFdmVuIGJlZm9yZSB0aGF0IHRoZSBuZWdhdGl2ZSBlcnJvciBjb2RlIGxlYWtlZCBvdXQNCj4g
dG8gdXNlcnNwYWNlLiAgV2UgY2FuIHRyeSB0byBqdXN0IHR1cm4gdGhhdCBiYWNrIGludG8gYW4g
aW50LCBidXQgSSdsbA0KPiBhbHNvIHNlbmQgb3V0IGFuIFJGQyBwYXRjaCB0byB1c2UgYnNnLWxp
YiBmb3IgdGhlIFNBUyB0cmFuc3BvcnQgaW4gYSBiaXQuDQoNCkhlbGxvIENocmlzdG9waCwNCg0K
RG8geW91IHdhbnQgbWUgdG8gc3BsaXQgdGhpcyBwYXRjaCBpbiB0d28gcGF0Y2hlcyAtIG9uZSB0
aGF0IGNoYW5nZXMgdGhlIHR5cGUNCm9mICdyZXQnIGFuZCBhbm90aGVyIG9uZSB0aGF0IHRyYW5z
bGF0ZXMgdGhlIFVuaXggZXJyb3IgY29kZSBpbnRvIGEgU0NTSSByZXN1bHQ/DQoNClRoYW5rcywN
Cg0KQmFydC4=
