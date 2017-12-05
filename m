From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/2] scsi-mq: Only show the CDB if available
Date: Tue, 5 Dec 2017 16:22:33 +0000
Message-ID: <1512490952.2660.18.camel@wdc.com>
References: <20171205003809.1705-1-bart.vanassche@wdc.com>
         <20171205003809.1705-2-bart.vanassche@wdc.com>
         <20171205011536.GC8365@ming.t460p> <1512439190.2739.0.camel@wdc.com>
         <20171205050008.GA9989@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:4729 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbdLEQWh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 11:22:37 -0500
In-Reply-To: <20171205050008.GA9989@ming.t460p>
Content-Language: en-US
Content-ID: <3B46DBD401BB154F913A5E1C9475DB69@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>

T24gVHVlLCAyMDE3LTEyLTA1IGF0IDEzOjAwICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gTm8s
IGRvIG5vdCBtaXggdHdvIGRpZmZlcmVudCB0aGluZ3MgaW4gb25lIHBhdGNoLCBlc3BlY2lhbGx5
IHRoZSBmaXggcGFydA0KPiBuZWVkIHRvIGJlIGJhY2twb3J0ZWQgdG8gc3RhYmxlLg0KPiANCj4g
VGhlIGZpeCBwYXJ0IHNob3VsZCBhaW0gYXQgVjQuMTUsIGFuZCB0aGUgb3RoZXIgcGFydCBjYW4g
YmUgYSBWNC4xNg0KPiBzdHVmZi4NCg0KRG9lcyB0aGlzIG1lYW4gdGhhdCB5b3UgZG8gbm90IHBs
YW4gdG8gcG9zdCBhIHY1IG9mIHlvdXIgcGF0Y2ggYW5kIHRoYXQgeW91DQp3YW50IG1lIHRvIHJl
d29yayB0aGlzIHBhdGNoIHNlcmllcz8gSSBjYW4gZG8gdGhhdC4NCg0KQmFydC4=
