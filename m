From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] block: Fixes for bdi handling
Date: Wed, 8 Mar 2017 09:55:04 -0700
Message-ID: <3637d996-6e69-def6-ee56-60a14a560428@kernel.dk>
References: <20170308164834.14302-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170308164834.14302-1-jack@suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/08/2017 09:48 AM, Jan Kara wrote:
> Hi!
> 
> patches in this series fix the most urgent bugs that were introduced by commit
> 165a5e22fafb "block: Move bdi_unregister() to del_gendisk()" and by
> 0dba1314d4f8 "scsi, block: fix duplicate bdi name registration crashes".
> In fact before these commits we had a different set of problems in the
> code but they were less visible :).
> 
> I'm still waiting for test confirmation from Omar and Arthur Marsh who reported
> issues but I'm not able to hit any problem anymore in my testing.  I think it
> would be nice to get the patches to rc2 so to speed up things I'm posting the
> patches now so that review can happen in parallel with the testing.
> 
> Other BDI handling fixes I have in my queue can wait a bit more since they are
> either theoretical or long-standing issues. So I'll repost them once these four
> are sorted out.

Agree, we'll need to get this sorted for -rc2, thanks a lot for looking
into it. I'll queue these up for testing as well, and hopefully ship
them off tomorrow (or Friday, at the latest).

-- 
Jens Axboe
