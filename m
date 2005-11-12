From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [GIT PATCH] final pre -rc pieces of SCSI for 2.6.14
Date: Fri, 11 Nov 2005 20:57:05 -0500
Message-ID: <43754BF1.5050609@pobox.com>
References: <1131745742.3505.47.camel@mulgrave> <20051111222341.GA20077@infradead.org> <Pine.LNX.4.64.0511111454140.3228@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750999AbVKLB5Y@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0511111454140.3228@g5.osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 11 Nov 2005, Christoph Hellwig wrote:
> 
>>On Fri, Nov 11, 2005 at 03:49:01PM -0600, James Bottomley wrote:
>>
>>>  o remove scsi_wait_req
>>
>>This requires '[PATCH] kill libata scsi_wait_req usage (make libata compile in
>>scsi-misc)' from Mike, because libata started to use this function in mainline
>>about the same time it was removed in scsi-misc.
> 
> 
> Yeah, I get
> 
> 	drivers/built-in.o(.text+0x12e68c): In function `.ata_cmd_ioctl':
> 	: undefined reference to `.scsi_wait_req'
> 	drivers/built-in.o(.text+0x12e85c): In function `.ata_task_ioctl':
> 	: undefined reference to `.scsi_wait_req'
> 
> right now. Can somebody forward that patch to me..

Given that that's the primary path for users issuing hdparm/SMART 
commands, I'm still hoping someone will give this patch even a simple 
"it works" test before pushing...  I requested this days ago, but 
haven't heard any results.

	Jeff
