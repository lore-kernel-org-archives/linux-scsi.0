From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCHSET] block: fix PIO cache coherency bug, take 2
Date: Tue, 06 Jun 2006 13:00:08 +0200
Message-ID: <E1FnZI8-0003u0-00@dorka.pomaz.szeredi.hu>
References: <1149392479501-git-send-email-htejun@gmail.com>
	 <20060604204444.GF4484@flint.arm.linux.org.uk> <1149515032.3489.4.camel@mulgrave.il.steeleye.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:62852 "EHLO
	mail-gw2.sa.eol.hu") by vger.kernel.org with ESMTP id S1751151AbWFFLBH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 07:01:07 -0400
In-reply-to: <1149515032.3489.4.camel@mulgrave.il.steeleye.com> (message from
	James Bottomley on Mon, 05 Jun 2006 08:43:52 -0500)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: rmk+lkml@arm.linux.org.uk, htejun@gmail.com, axboe@suse.de, davem@redhat.com, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, g.liakhovetski@gmx.de, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

> > > I tried to implement flush_anon_page() too but didn't know what to
> > do
> > > with anon_vma object.
> > 
> > I'm not sure what this is about...
> 
> This was for fuse on parisc.

I have reports that this effects some ARM architectures as well.

And direct I/O over NFS and a couple other things which also use the
get_user_pages() mechanism will also not work properly without
flush_anon_page().

Miklos
