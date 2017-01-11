From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/15] block/bsg: move queue creation into bsg_setup_queue
Date: Wed, 11 Jan 2017 10:37:13 +0100
Message-ID: <69ad74c4-2741-058a-97fa-3aa2b69571f4@suse.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
 <1484060780-15592-15-git-send-email-hch@lst.de>
 <20170111084218.GB6286@linux-x5ow.site> <20170111084512.GA6937@lst.de>
 <8810984d-9929-8937-e82c-94639fd0b8ea@suse.de> <20170111090112.GA7239@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170111090112.GA7239@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 01/11/2017 10:01 AM, Christoph Hellwig wrote:
> On Wed, Jan 11, 2017 at 09:59:17AM +0100, Hannes Reinecke wrote:
>> I'd advocate to discuss this at LSF.
>> Now that Mike moved the bio-based mpath stuff back in things got even
>> more complex.
> 
> Yeah.  If we'd _only_ have bio based support it would simplify things
> a lot, but as a third parallel path it's not exactly making things easier.
> 
>> I'll be posting a patchset for reimplementing multipath as a stand-alone
>> driver shortly; that'll give us a good starting point on how we want
>> multipath to evolve.
>>
>> Who knows; we might even manage to move multipath out of device-mapper
>> altogether.
>> That would make Mike very happy, and I wouldn't mind, either :-)
> 
> Heh.  I'm curious how you want to do that while keeping existing setups
> working, though.

which will become challenging, indeed.

ATM it's just a testbed on how things could work; we've got most of the
required infrastucture in the kernel nowadays, so that we can just drop
most of the complexity from the present multipath-tools mess.

In the end it might even boil down to update the existing device-mapper
multipath implementation. We'll see.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
