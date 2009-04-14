From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 17:49:17 -0500
Message-ID: <1239749357.3638.3.camel@mulgrave>
References: <49E335BA.3020103@panasas.com>
	 <200904141654.24067.bzolnier@gmail.com>
	 <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk>
	 <200904150009.06539.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60686 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbZDNWtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 18:49:20 -0400
In-Reply-To: <200904150009.06539.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>, Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>

On Wed, 2009-04-15 at 00:09 +0200, Bartlomiej Zolnierkiewicz wrote:

OK, look, guys, could we stop this argument?  It's becoming a bit old.

For the record, I was unhappy to have libata pata in SCSI, but it got
moved into drivers/ata shortly after, limiting my influence.  I thought
having a slow wind down of legacy pata in drivers/ide but moving to
libata for sata was the correct split.  I agree with Jeff that the SCSI
layer did provide unique features that SATA/NCQ needed at the time ...
but I also think we need to move them into block sooner rather than
later.

I'm the last person ever to proscribe a kernel subsystem that has
willing volunteers, so drivers/ide is yours as long as you want to
maintain it.  I can certainly see the merits of a thinner stack to the
embedded world, and not a few embedded developers seem to agree.

As far as moving it out of SCSI goes, I've always been a supporter of
this.  Tejun looks like he's willing to execute, so I feel much more
sanguine that it will happen.  The point of the notes was really to draw
attention to something I hadn't realised:  we can't refactor block to
get libata out of SCSI without also changing drivers/ide, which does
make the problem harder.

On a final note about the urgency of getting libata out of SCSI: Intel
has been worrying for a while about the fatness of the SCSI/libata
stack, and its effects on performance, especially command transmission
via SAT, so I'm hoping they'll be supporting the effort.

Jmaes


