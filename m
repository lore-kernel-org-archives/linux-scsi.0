From: Konrad Rzeszutek <konrad@darnok.org>
Subject: Re: [patch 16/17] scsi: add iSCSI iBFT Support
Date: Wed, 9 Apr 2008 22:30:50 -0400
Message-ID: <200804092230.50693.konrad@darnok.org>
References: <200803282148.m2SLmiGS012261@imap1.linux-foundation.org> <1206743305.3662.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:52605 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbYDJCjz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2008 22:39:55 -0400
In-Reply-To: <1206743305.3662.58.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, ketuzsezr@darnok.org, greg@kroah.com, michaelc@cs.wisc.edu, pjones@redhat.com

On Friday 28 March 2008 18:
> >
> >  Documentation/ABI/testing/sysfs-ibft |   23
> >  arch/x86/kernel/setup_32.c           |    3
> >  arch/x86/kernel/setup_64.c           |    4
> >  drivers/firmware/Kconfig             |   20
> >  drivers/firmware/Makefile            |    2
> >  drivers/firmware/iscsi_ibft.c        |  982 +++++++++++++++++++++++++
> >  drivers/firmware/iscsi_ibft_find.c   |   84 ++
> >  include/linux/iscsi_ibft.h           |   50 +
> >  8 files changed, 1168 insertions(+)
>
> Um, this has no piece in the SCSI tree or any of our allied files ...
> it's basically partly in arch/x86 and partly in drivers/firmware.  It's
> job is to export parameters from a rom bios.  I think it belongs to
> Greg ...
>
> James


Greg,

If it wouldn't be too much trouble, could you give this an ACK please?

Thanks
