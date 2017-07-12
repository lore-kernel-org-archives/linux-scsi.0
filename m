From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: add support for legacy boards
Date: Wed, 12 Jul 2017 09:12:39 +0200
Message-ID: <677ff445-bfb3-4723-ef97-c026de1e4632@suse.de>
References: <1499755744-79217-1-git-send-email-hare@suse.de>
 <alpine.LRH.2.20.1707111547060.31569@math.ut.ee>
 <4993A297653ECB4581FA5C3C31323D19533CE9D1@avsrvexchmbx2.microsemi.net>
 <alpine.LRH.2.20.1707111853330.9598@math.ut.ee>
 <20170712071121.GA5545@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40033 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751378AbdGLHMm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Jul 2017 03:12:42 -0400
In-Reply-To: <20170712071121.GA5545@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Meelis Roos <mroos@linux.ee>
Cc: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

On 07/12/2017 09:11 AM, Christoph Hellwig wrote:
> On Tue, Jul 11, 2017 at 06:58:36PM +0300, Meelis Roos wrote:
>>> The 5i controller is probably too old for the hpsa driver to support. 
>>> The hpsa driver is looking for information to determine if the drive is online/offline and
>>> this information is not available.
>>>
>>> What was the original issue you were having with the cciss driver?
>>
>> Christoph Hellwig updated block layer with "block: Make most 
>> scsi_req_init() calls implicit" and at first try, cciss was left without 
>> the needed initialization. This caused OOPS in udev probing but the 
>> system worked. The issue was fixed by Christoph quickly.
> 
> The original patch is from Bart, but otherwise correct.
> 
>> But he suggested it might be worth trying hpsa driver instead of cciss, 
>> with a longer term goal to to move users of cciss over to hpsa if 
>> possible. Now that I have tested it, it seems not all older cards are 
>> supported in hpsa - it's more than ID-s and interrupt masks.
> 
> Seems like it.  And the idea behind this game is that we'd like to slowly
> get rid of old request_fn based drivers.  Given that hpsa supports very
> similar hardware cciss is a target for removal once that hardware is
> switched over.  But it seems like we'll need more work in this area..
> 
I'll give it a shot.
I seem to have an oldish cciss board floating about; let's see how far I
get with those.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
