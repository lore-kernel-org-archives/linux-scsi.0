From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
Date: Sat, 23 Feb 2008 18:09:04 -0600
Message-ID: <1203811744.3139.11.camel@localhost.localdomain>
References: <1203779614.3139.4.camel@localhost.localdomain>
	 <20080223230126.GA23265@lixom.net>  <47C0ACC1.1050306@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54065 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbYBXAJJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Feb 2008 19:09:09 -0500
In-Reply-To: <47C0ACC1.1050306@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Olof Johansson <olof@lixom.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


On Sat, 2008-02-23 at 18:31 -0500, Jeff Garzik wrote:
> Olof Johansson wrote:
> > Hi,
> > 
> > On Sat, Feb 23, 2008 at 09:13:33AM -0600, James Bottomley wrote:
> > 
> >> Jeff Garzik (1):
> >>       mvsas: Add Marvell 6440 SAS/SATA driver
> > [...]
> >>  drivers/scsi/mvsas.c                | 2981 ++++++++++++++++++++++++++++++++++++
> > 
> > I just noticed that the file permissions on that file are 755 in current
> > git, that was probably not intentional?
> 
> Definitely not intentional.  They were 0644 in the original changeset 
> (the one from me you highlighted), then the second changeset updating 
> mvsas somehow changed the perms.

Actually, unfortunately, it was ... I just didn't spot it.  The second
patch has this in the header:

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
old mode 100644
new mode 100755

It's git slang for change the mode to executable ... no idea why marvell
would do that unless it's something windows related?  Anyway, I'll
change it back.

James


