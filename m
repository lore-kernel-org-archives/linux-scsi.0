From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: dmesg spam
Date: Mon, 04 Feb 2008 14:44:18 -0600
Message-ID: <1202157858.3096.114.camel@localhost.localdomain>
References: <20080203143033.cfea0501.akpm@linux-foundation.org>
	 <200802041524.55700.bzolnier@gmail.com>
	 <20080204120548.79f3fe57.akpm@linux-foundation.org>
	 <47A7721C.5020505@garzik.org>
	 <1202156442.3096.107.camel@localhost.localdomain>
	 <47A7747C.2040702@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60977 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756472AbYBDUoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 15:44:24 -0500
In-Reply-To: <47A7747C.2040702@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>


On Mon, 2008-02-04 at 15:24 -0500, Jeff Garzik wrote:
> James Bottomley wrote:
> > It's here in sr_ioctl.c:
> 
> Ah, indeed.  My grep-fu sucks today.
> 
> 
> > I'm not averse to simply nuking the printk ... it's probably valueless
> > in a modern kernel, since something dbussy is supposed to tell you to
> > put a CD in the drive, not something in the kernel.
> 
> The reverse...  dbussy/HAL is implementing autodetection of media 
> insertion, by polling ad infinitum.

Understood ... I meant the day of the user relying on a message from a
kernel printk to tell them they need a CD in the drive is long over.

James


