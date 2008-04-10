From: Greg KH <greg@kroah.com>
Subject: Re: [patch 16/17] scsi: add iSCSI iBFT Support
Date: Wed, 9 Apr 2008 19:38:27 -0700
Message-ID: <20080410023827.GA6525@kroah.com>
References: <200803282148.m2SLmiGS012261@imap1.linux-foundation.org> <1206743305.3662.58.camel@localhost.localdomain> <200804092230.50693.konrad@darnok.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34868 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYDJCim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2008 22:38:42 -0400
Content-Disposition: inline
In-Reply-To: <200804092230.50693.konrad@darnok.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, ketuzsezr@darnok.org, michaelc@cs.wisc.edu, pjones@redhat.com

On Wed, Apr 09, 2008 at 10:30:50PM -0400, Konrad Rzeszutek wrote:
> On Friday 28 March 2008 18:
> > >
> > >  Documentation/ABI/testing/sysfs-ibft |   23
> > >  arch/x86/kernel/setup_32.c           |    3
> > >  arch/x86/kernel/setup_64.c           |    4
> > >  drivers/firmware/Kconfig             |   20
> > >  drivers/firmware/Makefile            |    2
> > >  drivers/firmware/iscsi_ibft.c        |  982 +++++++++++++++++++++++++
> > >  drivers/firmware/iscsi_ibft_find.c   |   84 ++
> > >  include/linux/iscsi_ibft.h           |   50 +
> > >  8 files changed, 1168 insertions(+)
> >
> > Um, this has no piece in the SCSI tree or any of our allied files ...
> > it's basically partly in arch/x86 and partly in drivers/firmware.  It's
> > job is to export parameters from a rom bios.  I think it belongs to
> > Greg ...
> >
> > James
> 
> 
> Greg,
> 
> If it wouldn't be too much trouble, could you give this an ACK please?

Hm, I thought I did, my appologies.

Send it on over to me, I'll send it through my tree, as no one else
seems to want it :)

thanks,

greg k-h
