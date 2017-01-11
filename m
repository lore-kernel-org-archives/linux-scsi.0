From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/15] block/bsg: move queue creation into bsg_setup_queue
Date: Wed, 11 Jan 2017 09:59:17 +0100
Message-ID: <8810984d-9929-8937-e82c-94639fd0b8ea@suse.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
 <1484060780-15592-15-git-send-email-hch@lst.de>
 <20170111084218.GB6286@linux-x5ow.site> <20170111084512.GA6937@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43953 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbdAKI7T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 03:59:19 -0500
In-Reply-To: <20170111084512.GA6937@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 01/11/2017 09:45 AM, Christoph Hellwig wrote:
> On Wed, Jan 11, 2017 at 09:42:44AM +0100, Johannes Thumshirn wrote:
>> On Tue, Jan 10, 2017 at 04:06:19PM +0100, Christoph Hellwig wrote:
>>> Simply the boilerplate code needed for bsg nodes a bit.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> ---
>>
>> that reminds me of posting my SAS bsg-lib patch...
> 
> Yes.  Having SAS use bsg-lib, and bsg-lib switched away from abusing
> struct request_queue would make this series a lot cleaner.
> 
> So maybe we should get that into the scsi tree for 4.10 together
> with the prep patches in this series as a priority and defer the actual
> struct request changes once again.  That should also give us some more
> time to sort out the dm-mpath story..
I'd advocate to discuss this at LSF.
Now that Mike moved the bio-based mpath stuff back in things got even
more complex.

I'll be posting a patchset for reimplementing multipath as a stand-alone
driver shortly; that'll give us a good starting point on how we want
multipath to evolve.

Who knows; we might even manage to move multipath out of device-mapper
altogether.
That would make Mike very happy, and I wouldn't mind, either :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
