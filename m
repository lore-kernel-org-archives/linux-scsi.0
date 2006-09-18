From: Konrad Rzeszutek <konradr@redhat.com>
Subject: Re: [PATCH] aic94xx: Compile problem on s390
Date: Mon, 18 Sep 2006 15:36:53 -0400
Message-ID: <20060918193653.GB11112@krzeszut.users.redhat.com>
References: <20060918191545.GA10525@krzeszut.users.redhat.com> <20060918192138.GR2585@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932326AbWIRTgh@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060918192138.GR2585@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alexisb@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 18, 2006 at 01:21:38PM -0600, Matthew Wilcox wrote:
> On Mon, Sep 18, 2006 at 03:15:45PM -0400, Konrad Rzeszutek wrote:
> > The aic94xx driver in my-scsi and aic94xx James Bottomley tree does not
> > compile on s390. Since the driver is generic, it makes sense to fix.
> 
> Erm, well, I don't think there's any s390s with PCI ;-)
> 
> > The patch is quite simple:
> > +#include <asm/scatterlist.h>
> 
> Surely should be linux/scatterlist.h?

Hm. Most of the drivers use the <asm/...> and that is where
the struct scatterlist is defined. The linux/scatterlist.h includes
the asm/scatterlist.h.

Either one works. 

-- 
Konrad Rzeszutek 1-(978)-392-3903 or 1-(617)-693-1718
IBM on-site partner.
