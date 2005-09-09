From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] SAS transport class
Date: Fri, 9 Sep 2005 16:38:49 +0200
Message-ID: <20050909143848.GA15372@lst.de>
References: <20050909142250.GA13136@lst.de> <1126276536.4799.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:6101 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964923AbVIIOiw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 10:38:52 -0400
Content-Disposition: inline
In-Reply-To: <1126276536.4799.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Sep 09, 2005 at 09:35:36AM -0500, James Bottomley wrote:
> On Fri, 2005-09-09 at 16:22 +0200, Christoph Hellwig wrote:
> > In addition to the basic SCSI core objects this transport class introduces
> > two additional intermediate objects:  The SAS PHY as represented by struct
> > sas_phy defines an "outgoing" PHY on a SAS HBA or Expander, and the SAS
> > remote PHY represented by struct sas_rphy defines an "incoming" PHY on a
> > SAS Expander or end device.  Note that this is purely a software concept, the
> > underlying hardware for a PHY and a remote PHY is the exactly the same.
> 
> My only real comment is that an outgoing PHY should probably exist in a
> separate class because that concept is common to SATA, so the class
> should be shareable between sas/sata.

The code should be sharable with SATA pretty much as-is.  But instead
of creating ivory towers I'd say just split the code out once someone
uses it for SATA.  In fact I'll probably done thay once I'm done with
the paid SAS work.

> What you call a sas_rphy, when it's an expander input is the thing we're
> going to want to attach an SMP tap to for the management tools
> (eventually).

Yes, that's the plan.  I expect to work on that starting late next week
or the week after.
