From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Mon, 14 May 2007 19:46:14 +0100
Message-ID: <20070514194614.4f00655d@the-village.bc.nu>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	<20070513160608.GA29024@redhat.com>
	<1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	<Pine.LNX.4.64.0705131216440.27468@localhost.localdomain>
	<1179073670.3723.48.camel@mulgrave.il.steeleye.com>
	<46474E1A.6080904@simon.arlott.org.uk>
	<1179078537.3723.53.camel@mulgrave.il.steeleye.com>
	<Pine.LNX.4.61.0705141928230.9570@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49894 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753152AbXENSm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 14:42:28 -0400
In-Reply-To: <Pine.LNX.4.61.0705141928230.9570@yvahk01.tjqt.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Simon Arlott <simon@fire.lp0.eu>, "Robert P. J. Day" <rpjday@mindspring.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Mon, 14 May 2007 19:29:12 +0200 (MEST)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On May 13 2007 12:48, James Bottomley wrote:
> >
> >> Why does ATA select SCSI anyway? Surely PATA doesn't require it?
> >
> >That's a bit offtopic and to the wrong list.
> >
> >libata-pata does require SCSI ...
> 
> And in the long run, that SCSI parts which are actually used by ATA
> should be factored out so that SCSI really is SCSI again, and not
> "Common layer for SCSI, SATA and PATA" or so.

The common layer for the queueing is one thing, but the ATAPI devices
(CD-ROM etc) are SCSI commands over an ATA bus. A subset of SCSI commands
badly over an ATA bus but SCSI commands nevertheless - so they have the
same basic dependancies as USB storage does.

Alan
