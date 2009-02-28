From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: Transport identifier
Date: Sat, 28 Feb 2009 14:19:07 +0900
Message-ID: <20090228141855Z.fujita.tomonori@lab.ntt.co.jp>
References: <20090227163326V.fujita.tomonori@lab.ntt.co.jp>
	<yq1eixjdws0.fsf@sermon.lab.mkp.net>
	<20090228045014.GP16891@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:47557 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZB1FTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2009 00:19:18 -0500
In-Reply-To: <20090228045014.GP16891@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: martin.petersen@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, 27 Feb 2009 21:50:14 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Feb 27, 2009 at 11:13:03PM -0500, Martin K. Petersen wrote:
> > The following patch below sits somewhere between my original take and
> > your patch.  Those transports that have classes implemented fill out the
> > id like you did.  The ones that don't (ATA, FireWire and USB) set it
> > manually.  Best of both worlds, IMHO.
> 
> You seem to have missed the patch to scsi_transport_spi.c.
> There's also a lot of parallel SCSI drivers that don't use
> scsi_transport_spi.c yet.  I'm OK with them being 'unknown' and
> eventually people patching them (or perhaps better, converting them to
> use scsi_transport_spi!), but thought it was worth mentioning.

Yeah, that's why my patch sets SCSI_TRANSPORT_SPI to 0. So a lot of
parallel SCSI drivers that don't use spi class can get 'spi'
properly. It's better to convert them to use spi class but I really
doubt someone would do.
