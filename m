From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [patch RESEND] atp870u: 64 bit bug in atp885_init()
Date: Wed, 9 Dec 2015 13:07:58 +0100
Message-ID: <201512091307.59549.linux@rainbow-software.org>
References: <55B9CA3B.1030205@suse.de> <20151209102453.GE3173@mwanda> <20151209115339.46a09d94@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:49061 "EHLO
	smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbbLIMIH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 07:08:07 -0500
In-Reply-To: <20151209115339.46a09d94@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wednesday 09 December 2015 12:53:39 One Thousand Gnomes wrote:
> On Wed, 9 Dec 2015 13:24:53 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > On 64 bit CPUs there is a memory corruption bug on probe().  It should
> > be a u32 pointer instead of an unsigned long pointer or we write past
> > the end of the setupdata[] array.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Reviewed-by: Hannes Reinecke <hare@suse.com>
> > ---
> > Resending because we have shuffled the code around so the patch needed
> > to be refreshed against linux-next.  Although I do wonder why we are
> > still working on this code since it has never worked on 64 bit systems
> > so probably all the users gave up a decade ago.
> 
> So this is untested ? If so please make it very clear in the commit
> message because the kernel is IMHO getting too full of polished, neat,
> recently modified, never tested, never used code.
> 
> I agree it would be better if the driver was simply deleted. I've not
> even seen an ATP870 bug report in years.

Maybe because it worked. Although the code was horrible. I've done some big changes to this driver recently (tested, of course).
I can't test this patch as I don't have ATP885 card, only ATP870.

-- 
Ondrej Zary
