From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Thu, 07 Feb 2008 19:07:53 -0600
Message-ID: <1202432873.3171.58.camel@localhost.localdomain>
References: <1202432206.3171.53.camel@localhost.localdomain>
	 <1202432647.31361.26.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39099 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759582AbYBHBIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 20:08:00 -0500
In-Reply-To: <1202432647.31361.26.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 2008-02-07 at 17:04 -0800, Harvey Harrison wrote:
> On Thu, 2008-02-07 at 18:56 -0600, James Bottomley wrote:
> > Quite a bit of this is fixing things broken previously (the advansys fix
> > is still pending resolution, but I'll send it as an -rc fix when we have
> > it).  There's the final elimination of all drivers that are esp based
> > but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> > the usual bunch of driver updates and the addition of a new enclosure
> > services driver and the corresponding ULD.
> > 
> > The patch is available from:
> > 
> 
> I'm going to guess that this is the entry in feature-removal.txt
> that need an update then:
> 
> ---------------------------
> 
> What:	old NCR53C9x driver
> When:	October 2007
> Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> 	driver can be ported over almost trivially.
> Who:	David Miller <davem@davemloft.net>
> 	Christoph Hellwig <hch@lst.de>

Not immediately ... I anticipate a few "where'd my driver go?" type
questions from m68k for which this provides a useful reference to point
to ...

James


