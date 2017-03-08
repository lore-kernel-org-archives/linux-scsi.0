From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH 0/4] block: Fixes for bdi handling
Date: Wed, 8 Mar 2017 09:39:25 -0800
Message-ID: <20170308173925.GB8598@vader>
References: <20170308164834.14302-1-jack@suse.cz>
 <20170308165051.GA8598@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308165051.GA8598@vader>
Sender: linux-block-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 08, 2017 at 08:50:51AM -0800, Omar Sandoval wrote:
> On Wed, Mar 08, 2017 at 05:48:30PM +0100, Jan Kara wrote:
> > Hi!
> > 
> > patches in this series fix the most urgent bugs that were introduced by commit
> > 165a5e22fafb "block: Move bdi_unregister() to del_gendisk()" and by
> > 0dba1314d4f8 "scsi, block: fix duplicate bdi name registration crashes".
> > In fact before these commits we had a different set of problems in the
> > code but they were less visible :).
> > 
> > I'm still waiting for test confirmation from Omar and Arthur Marsh who reported
> > issues but I'm not able to hit any problem anymore in my testing.  I think it
> > would be nice to get the patches to rc2 so to speed up things I'm posting the
> > patches now so that review can happen in parallel with the testing.
> > 
> > Other BDI handling fixes I have in my queue can wait a bit more since they are
> > either theoretical or long-standing issues. So I'll repost them once these four
> > are sorted out.
> > 
> > 								Honza
> 
> Applying patches 1 and 2 indeed fixed my virtio-scsi problem. I'll apply
> the whole series and test that my sd/sr test cases still work.

Yup, everything is working here. For the series:

Tested-by: Omar Sandoval <osandov@fb.com>
