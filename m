From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Discard merging / Write same support v5
Date: Thu, 20 Sep 2012 14:47:17 +0200
Message-ID: <505B1055.5090509@kernel.dk>
References: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>  <505B0D02.70707@kernel.dk> <1348145006.2936.12.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38803 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab2ITMro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2012 08:47:44 -0400
In-Reply-To: <1348145006.2936.12.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, shli@kernel.org, snitzer@redhat.com

On 09/20/2012 02:43 PM, James Bottomley wrote:
> On Thu, 2012-09-20 at 14:33 +0200, Jens Axboe wrote:
>> On 09/18/2012 06:19 PM, Martin K. Petersen wrote:
>>> I've been beating on this patch kit for the last few weeks with a bunch
>>> of different devices. I have also tested extensively with Shaohua Li's
>>> MD RAID0 discard support.
>>>
>>> The only functional change is support for discard and write same
>>> bio/request merging. Other than that there were a few tweaks for later
>>> kernels by both Mike and me.
>>>
>>> I put a writesame5 branch on:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git
>>>
>>> It's against block/for-3.7/core.
>>>
>>> [PATCH 1/8] block: Clean up special command handling logic
>>> [PATCH 2/8] block: Consolidate command flag and queue limit checks
>>> [PATCH 3/8] block: Implement support for WRITE SAME
>>> [PATCH 4/8] block: Make blkdev_issue_zeroout use WRITE SAME
>>> [PATCH 5/8] block: ioctl to zero block ranges
>>> [PATCH 6/8] scsi: Add a report opcode helper
>>> [PATCH 7/8] sd: Permit merged discard requests
>>> [PATCH 8/8] sd: Implement support for WRITE SAME
>>
>> Thanks Martin, I queued up 1..5 in for-3.7/core. I'm assuming James will
>> pick up the SCSI bits?
> 
> Yes, but Linus gave me a rocket about post merge trees.  Can you do this
> on a separate branch and I'll build on top of that?

He did, didn't he... You could just use for-3.7/core as of today,
there's not that much in there yet. Alternatively, I'd have to rebase
for-3.7/core and rip them out, put them in a separate branch, and pull
that back into for-3.7/core.

-- 
Jens Axboe

