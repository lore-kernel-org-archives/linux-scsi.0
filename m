From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Thu, 07 Feb 2008 17:14:44 -0800
Message-ID: <1202433284.31361.29.camel@brick>
References: <1202432206.3171.53.camel@localhost.localdomain>
	 <1202432647.31361.26.camel@brick>
	 <1202432873.3171.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:53313 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614AbYBHBOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 20:14:48 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2393582rvb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Feb 2008 17:14:46 -0800 (PST)
In-Reply-To: <1202432873.3171.58.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


On Thu, 2008-02-07 at 19:07 -0600, James Bottomley wrote:
> On Thu, 2008-02-07 at 17:04 -0800, Harvey Harrison wrote:
> > On Thu, 2008-02-07 at 18:56 -0600, James Bottomley wrote:
> > > Quite a bit of this is fixing things broken previously (the advansys fix
> > > is still pending resolution, but I'll send it as an -rc fix when we have
> > > it).  There's the final elimination of all drivers that are esp based
> > > but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> > > the usual bunch of driver updates and the addition of a new enclosure
> > > services driver and the corresponding ULD.
> > > 
> > > The patch is available from:
> > > 
> > 
> > I'm going to guess that this is the entry in feature-removal.txt
> > that need an update then:
> > 
> > ---------------------------
> > 
> > What:	old NCR53C9x driver
> > When:	October 2007
> > Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> > 	driver can be ported over almost trivially.
> > Who:	David Miller <davem@davemloft.net>
> > 	Christoph Hellwig <hch@lst.de>
> 
> Not immediately ... I anticipate a few "where'd my driver go?" type
> questions from m68k for which this provides a useful reference to point
> to ...
> 
> James
> 
> 

Well, if not removed, how about updated:

What:	old NCR53C9x driver
When:	Removed Feb 2008
Why:	Replaced by the much better esp_scsi driver.  Actual low-level
	driver can be ported over almost trivially.
Who:	James Bottomley <James.Bottomley@HansenPartnership.com>

Cheers,

Harvey

