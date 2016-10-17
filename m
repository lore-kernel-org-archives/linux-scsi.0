From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to
 firmware
Date: Mon, 17 Oct 2016 12:29:57 -0400
Message-ID: <ecb5bb6e-395f-6ca6-5d73-f48129c7d1e9@redhat.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-5-git-send-email-sumit.saxena@broadcom.com>
 <d9e79049-b4ce-588f-263d-dad015b3368d@suse.de>
 <9e5fbcef-bd72-71be-76f6-f41e26b5cb3c@redhat.com>
 <1476721205.2734.12.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933692AbcJQQ37 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 12:29:59 -0400
In-Reply-To: <1476721205.2734.12.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, kashyap.desai@broadcom.com, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Gris Ge <fge@redhat.com>, Ewan Milne <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>

On 10/17/2016 12:20 PM, James Bottomley wrote:
>> We really need to have some ways to validate that our IO stack is
>> >properly and safely configured.
>> >
>> >I would love to see a couple of things:
>> >
>> >* having T10 & T13 report the existence of a volatile write cache -
>> >this is different than WCE set, some devices have a write cache and
>> >are battery/flash backed.
> That's the non-volatile cache log page.
>
> James
>
>
That is not how the vendors implement this unfortunately. I dug into this 
non-volatile cache log page with several disk vendors last year and they were 
consistently not setting this to reflect that state.

Ric


