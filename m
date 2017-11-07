From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] sd: Fix a disk probing hang
Date: Tue, 7 Nov 2017 22:42:20 +0000
Message-ID: <1510094539.2656.44.camel@wdc.com>
References: <20171107173807.14396-1-bart.vanassche@wdc.com>
         <1510078140.3118.18.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:45384 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752046AbdKGWmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 17:42:23 -0500
In-Reply-To: <1510078140.3118.18.camel@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <E9EBC53DF50B9C40A6845A509FA5927F@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

T24gVHVlLCAyMDE3LTExLTA3IGF0IDEwOjA5IC0wODAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IGJ1dCBjYW4geW91IGludmVzdGlnYXRlIHRoZSByb290IGNhdXNlIHJhdGhlciB0aGFuIHRy
eWluZyB0aGlzIGJhbmRhaWQ/DQoNCkhlbGxvIEphbWVzLA0KDQpUaGFua3MgZm9yIHlvdXIgcmVw
bHkuIEkgdGhpbmsgdGhhdCB0aGUgcm9vdCBjYXVzZSBpcyB0aGF0IFNDU0kgc2Nhbm5pbmcNCmFj
dGl2aXR5IGNhbiBjb250aW51ZSB0byBzdWJtaXQgSS9PIGV2ZW4gYWZ0ZXIgc2NzaV9yZW1vdmVf
aG9zdCgpIGhhcw0KdW5sb2NrZWQgc2Nhbl9tdXRleCBidXQgdGhhdCBzY3NpX3JlbW92ZV9ob3N0
KCkgcmVtb3ZlcyBzb21lIG9mIHRoZQ0KaW5mcmFzdHJ1Y3R1cmUgdGhhdCBpcyBlc3NlbnRpYWwg
dG8gcHJvY2VzcyBTQ1NJIHJlcXVlc3RzLiBBcmUgeW91IE9LIHdpdGgNCmUuZy4gbW92aW5nIGEg
c2lnbmlmaWNhbnQgcGFydCBvZiBzY3NpX3JlbW92ZV9ob3N0KCkgaW50bw0Kc2NzaV9ob3N0X2Rl
dl9yZWxlYXNlKCk/DQoNClRoYW5rcywNCg0KQmFydC4=
