From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: export bsg.h header to user-mode
Date: Fri, 16 Jan 2009 07:50:04 +0100
Message-ID: <20090116065003.GU30821@kernel.dk>
References: <496EFA69.3050007@panasas.com> <20090115202155G.fujita.tomonori@lab.ntt.co.jp> <496F26DF.9050303@panasas.com> <20090115212942R.fujita.tomonori@lab.ntt.co.jp> <20090115164824.e637b8c6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:22204 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758033AbZAPGv1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 01:51:27 -0500
Content-Disposition: inline
In-Reply-To: <20090115164824.e637b8c6.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dougg@torque.net, stable@kernel.org

On Thu, Jan 15 2009, Andrew Morton wrote:
> On Thu, 15 Jan 2009 21:29:56 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Thu, 15 Jan 2009 14:06:55 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> > > > Your patch does the right thing?
> > > > 
> > > 
> > > Yes I just checked, the Kernel build system strips out the #ifdef __KERNEL__ sections
> > > for the exported headers. (Do "make headers_check" you can see at usr/include/linux/)
> > 
> > Thanks, I see.
> > 
> > 
> > > >> ---
> > > >> From: Boaz Harrosh <bharrosh@panasas.com>
> > > >> Date: Thu, 15 Jan 2009 10:43:17 +0200
> > > >> Subject: [PATCH] include/linux: Add bsg.h to the Kernel exported headers
> > > >>
> > > >> bsg.h in current form is perfectly suitable for user-mode
> > > >> consumption. It is needed together with scsi/sg.h for applications
> > > >> that want to interface with the bsg driver.
> > > >>
> > > >> Currently the few projects that use it would copy it over into
> > > >> the projects. But that is not acceptable for projects that need
> > > >> to provide a libxxx-devel package for distros.
> > > >>
> > > >> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> > > 
> > > TOMO Please ACK here so Jens can push it through his tree.
> > 
> > You can add my ACK.
> > 
> > 
> > > Also I think we want to:
> > > CC: stable@kernel.org
> > 
> > It's fine by me.
> > 
> 
> The patch looks OK to me.
> 
> Please resend it with a complete changelog, not this great email mess. 
> 
> The changelog should clearly explain why the change is needed after the
> merge window and it should provide justification for backporting it into
> the -stable kernels.
> 
> Please also indicate which -stable kernel versions you believe it
> should be ported into.  "everything", I assume.

Thanks Andrew, I was actually waiting for such a submission :-)

-- 
Jens Axboe

