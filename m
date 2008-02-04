From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: dmesg spam
Date: Mon, 4 Feb 2008 12:05:48 -0800
Message-ID: <20080204120548.79f3fe57.akpm@linux-foundation.org>
References: <20080203143033.cfea0501.akpm@linux-foundation.org>
	<200802041524.55700.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53721 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757207AbYBDUFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 15:05:52 -0500
In-Reply-To: <200802041524.55700.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Mon, 4 Feb 2008 15:24:55 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Sunday 03 February 2008, Andrew Morton wrote:
> > 
> > With latest -mm, running fc8 I am getting this in the logs,
>                            ^^^
> => SCSI/libata
> 
> cc:ing Jeff
> 
> > once per second.
> > 
> > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > sr0: CDROM not ready.  Make sure there is a disc in the drive.

Well..  it's coming out of the kernel.  Presumably it's that cdrom polling
thing in KDE.  James recently made changes to sr_ioctl.c but I've been
buried in more terminal regressions than this one.
