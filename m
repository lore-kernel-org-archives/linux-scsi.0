From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] remove unused includes and misleading comments from scsi_lib.c
Date: Wed, 20 Nov 2002 11:10:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021120111016.A20388@eng2.beaverton.ibm.com>
References: <20021117235449.B9824@lst.de> <20021120084709.A18453@eng2.beaverton.ibm.com> <20021120185048.A4886@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021120185048.A4886@lst.de>; from hch@lst.de on Wed, Nov 20, 2002 at 06:50:48PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 20, 2002 at 06:50:48PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 20, 2002 at 08:47:09AM -0800, Patrick Mansfield wrote:
> > I had to add back the smp_lock.h include to compile with CONFIG_PREEMPT,
> > as kernel_locked was not defined and is used by in_atomic().
> 
> Bah.  Any chance you could fix the header declaring in_atomic() to pull
> in smp_lock.h by itself instead?

It is in hardirq.h, arch specific, 11 of the 20 hardirq.h files would
need the change (they reference kernel_locked) to include smp_lock.h.

665 files include smp_lock.h
89  files include hardirq.h
32  files include both

So, should I change the arch hardirq.h files to include smp_lock.h,
or just add smp_lock.h to scsi_lib.c?

-- Patrick Mansfield
