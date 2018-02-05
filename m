From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH V2 8/8] scsi: hpsa: use blk_mq to solve irq affinity issue
Date: Mon, 5 Feb 2018 16:07:20 +0000
Message-ID: <1abf74156ac846d0938c0f56382181c0@microsemi.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
         <20180205152035.15016-9-ming.lei@redhat.com>
 <1517846290.11655.6.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0041.outbound.protection.outlook.com ([104.47.42.41]:56384
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753078AbeBEQHa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Feb 2018 11:07:30 -0500
In-Reply-To: <1517846290.11655.6.camel@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBUaGlzIGlzIGEgY3JpdGljYWwgaXNzdWUg
b24gdGhlIEhQU0EgYmVjYXVzZSBMaW51cyBhbHJlYWR5IGhhcyB0aGUNCj4gb3JpZ2luYWwgY29t
bWl0IHRoYXQgY2F1c2VzIHRoZSBzeXN0ZW0gdG8gZmFpbCB0byBib290Lg0KPiANCj4gQWxsIG15
IHRlc3Rpbmcgd2FzIG9uIERMMzgwIEc3IHNlcnZlcnMgd2l0aDoNCj4gDQo+IEhld2xldHQtUGFj
a2FyZCBDb21wYW55IFNtYXJ0IEFycmF5IEc2IGNvbnRyb2xsZXJzDQo+IFZlbmRvcjogSFAgICAg
ICAgTW9kZWw6IFA0MTBpICAgICAgICAgICAgUmV2OiA2LjY0DQo+IA0KPiBNaW5nJ3MgcGF0Y2gg
Zml4ZXMgdGhpcyBzbyB3ZSBuZWVkIHRvIHRyeSBtb3ZlIHRoaXMgYWxvbmcuDQo+IA0KPiBJIGhh
dmUgYSBETDM4MCBHOCBhcyB3ZWxsIHdoaWNoIGlzIGFsc28gbGlrZWx5IGV4cG9zZWQgaGVyZSBh
bmQgSSBhZGRlZA0KPiAgRG9uIEJyYWNlIGZvciBGWUkgdG8gdGhpcyBsaXN0Lg0KPiANCj4gVGhh
bmtzIE1pbmcNCg0KUnVubmluZyBzb21lIHRlc3RzIG5vdy4NCg==
