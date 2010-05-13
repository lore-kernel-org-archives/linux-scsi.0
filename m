From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] libsas: dereferencing variable before check
Date: Thu, 13 May 2010 20:42:32 +0200
Message-ID: <20100513184232.GC5695@bicker>
References: <20100512225629.GB5695@bicker> <23e0bf65-8758-45b3-b0a8-1df97db07d9a@email.android.com> <1273761114.4353.122.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1273761114.4353.122.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 13, 2010 at 09:31:54AM -0500, James Bottomley wrote:
> On Thu, 2010-05-13 at 01:08 +0200, Tejun Heo wrote:
> > 
> > "Dan Carpenter" <error27@gmail.com> wrote:
> > 
> > >The "qc->scsicmd" could be null so I moved the dereference inside the
> > >check.  This was introduced by 70b25f890: "[SCSI] fix locking around
> > >blk_abort_request()" 
> > >
> > >Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > Ooh.. right.
> > 
> > Asked-by: Tejun Heo <tj@kernel.org>
> 
> Well, oops, yes.  Two patches to fix one bug is a bit overboard, I
> think, plus some code rearrangement to fix the locality of the problem
> and ensure it doesn't happen again might be useful.  What about this.
> 

Looks good.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter
