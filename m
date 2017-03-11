From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4 v2] block: Fixes for bdi handling
Date: Sat, 11 Mar 2017 15:27:35 -0700
Message-ID: <88312b29-2a25-a4b9-f747-4c90eb6004a4@kernel.dk>
References: <20170309101624.25901-1-jack@suse.cz>
 <7177cebf-8a9b-10d4-e991-5e43f4303ffc@kernel.dk>
 <20170310102205.GA12421@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170310102205.GA12421@quack2.suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/10/2017 03:22 AM, Jan Kara wrote:
> On Thu 09-03-17 09:41:01, Jens Axboe wrote:
>> On 03/09/2017 03:16 AM, Jan Kara wrote:
>>> Hi!
>>>
>>> this is a second revision of the series fixing the most urgent bugs that were
>>> introduced by commit 165a5e22fafb "block: Move bdi_unregister() to
>>> del_gendisk()" and by 0dba1314d4f8 "scsi, block: fix duplicate bdi name
>>> registration crashes".  In fact before these commits we had a different set of
>>> problems in the code but they were less visible :).
>>
>> It was rather urgent to get those fixes in, so I already sent them off.
>> Not a huge deal, but it would be nice to add the atomic init fix as a
>> separate patch later on.
> 
> OK, actually my followup fixes remove the counter completely so I guess we
> can just leave it as is.

Yes, if that's the case, then there's little point in an incremental
cleanup.

-- 
Jens Axboe
