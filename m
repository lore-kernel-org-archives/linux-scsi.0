From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: scsi device attributes
Date: Fri, 22 Oct 2004 21:27:07 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410222124200.5604@poirot.grange>
References: <Pine.LNX.4.60.0410212223120.7042@poirot.grange>
 <20041022124007.GC4201@parcelfarce.linux.theplanet.co.uk>
 <1098450017.2017.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:45249 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268001AbUJVVKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 17:10:22 -0400
In-Reply-To: <1098450017.2017.19.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 22 Oct 2004, James Bottomley wrote:

> On Fri, 2004-10-22 at 08:40, Matthew Wilcox wrote:
> > How about something more along the following lines?  I haven't converted
> > sym2 to the generic queue code yet, so it's untested (and is obviously
> > broken because nothing initialises max_queue_depth).
> 
> Yes, I was considering something like this.  The original queue code in
> 53c700 was designed as an example of how to do attribute overrides. 
> However, there needs to be a callback into the LLD to tell it that the
> queue is being overriden (and allow a veto for depth increases).  I'll
> look at adding the extra pieces.

Right. Feel free to hold off the patch, until you implement the generic 
sdev_store_queue_depth().

Thanks
Guennadi
---
Guennadi Liakhovetski

