From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 1/3] scsi_tgt_lib: Use scsi_init_io instead of
 scsi_alloc_sgtable
Date: Thu, 8 Nov 2007 22:04:01 +0900
Message-ID: <20071108220325R.tomof@acm.org>
References: <4730AF73.7010009@panasas.com>
	<20071108121321F.fujita.tomonori@lab.ntt.co.jp>
	<4732C9B8.6050204@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:47612 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbXKHNFA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Nov 2007 08:05:00 -0500
In-Reply-To: <4732C9B8.6050204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bhalevy@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, pw@osc.edu

On Thu, 08 Nov 2007 10:32:56 +0200
Benny Halevy <bhalevy@panasas.com> wrote:

> On Nov. 08, 2007, 5:13 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Tue, 06 Nov 2007 20:16:19 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >>   - If we export scsi_init_io()/scsi_release_buffers() instead of
> >>     scsi_{alloc,free}_sgtable() from scsi_lib than tgt code is
> >>     much more insulated from scsi_lib changes. As a bonus it will
> >>     also gain bidi capability when it comes.
> >>
> >> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> > 
> > Looks good for me except for this:
> > 
> > ./scripts/checkpatch.pl ~/Mail/kernel/scsi/28814
> > ERROR: use tabs not spaces
> > #101: FILE: drivers/scsi/scsi_lib.c:741:
> > +                                              gfp_t gfp_mask)$
> 
> Come on Tomo, tabs should be used for nesting, not for decoration.
> This way no matter what's your tab expansion setup is the
> code will look correct and will make sense.  The number of space

I've never heard about that rule. I use tabs and minimum spaces for
decoration.

But it's just about the style. The patch is fine by me if you like to
use only spaces there.

Thanks,
