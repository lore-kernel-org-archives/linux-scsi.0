From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] aic7xxx: user scsi_device host private data
Date: Mon, 23 May 2005 21:16:29 +0200
Message-ID: <20050523191629.GA8365@lst.de>
References: <20050523151422.GA3668@lst.de> <1116862481.5021.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44452 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261943AbVEWTQe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 15:16:34 -0400
Content-Disposition: inline
In-Reply-To: <1116862481.5021.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, May 23, 2005 at 10:34:41AM -0500, James Bottomley wrote:
> On Mon, 2005-05-23 at 17:14 +0200, Christoph Hellwig wrote:
> > -	BUG_ON(dev == NULL);
> 
> Leave that one, just in case ... I think it's completely impossible now,
> but I'm still suspicious of the aic untagged queues and whether they can
> spit back a command.

This doesn't make sense as we never reset the hostdata, so this is a
real can't happen.

> > -	BUG_ON(dev->active);
> 
> Ditto this one .. although I'm less sanguine that this won't be tripped.

this makes a tiny little bit more sense to keep

