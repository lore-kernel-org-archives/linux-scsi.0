From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] cmd_filter fixes
Date: Fri, 8 Aug 2008 08:15:37 +0200
Message-ID: <20080808061537.GI20055@kernel.dk>
References: <6cf6b73e0808071147o76817aabhc363feb41b0a176c@mail.gmail.com> <20080808092014J.fujita.tomonori@lab.ntt.co.jp> <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:9672 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbYHHGPj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 02:15:39 -0400
Content-Disposition: inline
In-Reply-To: <20080808151147J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Fri, Aug 08 2008, FUJITA Tomonori wrote:
> On Fri, 8 Aug 2008 07:54:07 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, Aug 08 2008, FUJITA Tomonori wrote:
> > > On Thu, 7 Aug 2008 20:47:45 +0200
> > > "Adel Gadllah" <adel.gadllah@gmail.com> wrote:
> > > 
> > > > Can we push this patches to Linus?
> > > > They fix the regression and do not seem to introduce a new one
> > > > (couldn't find any while testing it).
> > > 
> > > Jens? Any comments on the patchset?
> > 
> > Looks fine, I'll queue it up.
> 
> Cool, thanks.
> 
> We also discussed the possible interface changes:
> 
> http://marc.info/?t=121706320300003&r=1&w=2
> 
> Adel already has a patch for these changes:
> 
> http://marc.info/?l=linux-scsi&m=121768334007545&w=2

Yep, looks good to me.

> BTW, we also wait for your verdict on:
> 
> http://marc.info/?t=121611935500002&r=1&w=2

I've always hated the iommu virtual merging complexity. My plan is to
rip it out.

-- 
Jens Axboe

