From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
 block/for-2.6.31 tree
Date: Wed, 20 May 2009 19:40:35 +0300
Message-ID: <4A143283.5000104@panasas.com>
References: <4A12797B.2060901@panasas.com> <4A12AC23.30808@panasas.com>	 <20090520111619.87f815b1.sfr@canb.auug.org.au>	 <1242830240.2881.10.camel@localhost.localdomain>	 <20090521004251.9160e228.sfr@canb.auug.org.au>	 <1242830865.2881.13.camel@localhost.localdomain> <1242836425.2881.44.camel@localhost.localdomain> <4A14322A.4000709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756405AbZETQkt@vger.kernel.org>
In-Reply-To: <4A14322A.4000709@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 05/20/2009 07:39 PM, Boaz Harrosh wrote:
> On 05/20/2009 07:20 PM, James Bottomley wrote:
>> On Wed, 2009-05-20 at 14:47 +0000, James Bottomley wrote:
>>> OK, so I think your pulling of my posmerge tree can cope with the fact
>>> that I did the necessary rebasing in block for-next before I made it the
>>> base of my combined tree .... think of this as a nice test.
>>>
>>> Just building now ... if it works, I'll push to SCSI post merge and all
>>> our problems should go away.
>> Unfortunately the combined tree hits a BUG_ON blk-core.c:2045 when doing
>> SPI domain validation.
>>
>> There will be a short delay ...
>>
>> James
>>
>>
> 
> I have rebased block/for-next onto linus/master which should give us the
> same content?
> 
> But line 2045 is on a code comment.
> 
> if I now do a git-log v2.6.30-rc3..HEAD I have the following patches:

for blk-core.c that is

> pick 42dad76 block: simplify I/O stat accounting
> pick af498d7 block: fix the bio_vec array index out-of-bounds test
> pick d616ee5 block: clear req->errors on bio completion only for fs requests
> pick 268ea3d block: merge blk_invoke_request_fn() into __blk_run_queue()
> pick d097b7d block: kill blk_start_queueing()
> pick 3099167 block: don't set REQ_NOMERGE unnecessarily
> pick 4095018 block: cleanup REQ_SOFTBARRIER usages
> pick 17fc349 block: reorder request completion functions
> pick 6e6732a block: reorganize request fetching functions
> pick ca219b4 block: kill blk_end_request_callback()
> pick ea1e706 block: clean up request completion API
> pick 70a8607 block: move rq->start_time initialization to blk_rq_init()
> pick fa6e42b block: implement and use [__]blk_end_request_all()
> pick 861af79 block: kill rq->data
> pick 6abeea3 block: make blk_do_io_stat() do the full "is this rq accountable" checks
> pick 2f94129 block: catch trying to use more bits than request->cmd_flags has
> pick 325f440 block: implement blk_rq_pos/[cur_]sectors() and convert obvious ones
> pick 7168ea4 block: convert to pos and nr_sectors accessors
> pick 209e1e4 block: drop request->hard_* and *nr_sectors
> pick 80d23d0 block: hide request sector and data_len
> pick 563e977 block: implement and enforce request peek/start/fetch
> pick 6cd0982 block: move completion related functions back to blk-core.c
> pick 3978c4e block: set rq->resid_len to blk_rq_bytes() on issue
> pick 01f54fd block: Add blk_make_request(), takes bio, returns a request
> pick 0d58792 block: add warning to blk_make_request()
> 
> How did you resolve the block/for-next and linus/master merge?
> 
> Thanks
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
