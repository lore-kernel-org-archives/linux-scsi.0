From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] prepare qla1280 drivers for ISP1020/1040 support
Date: Sat, 7 Feb 2004 09:03:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040207080300.GA15781@lst.de>
References: <20040206155632.GA4679@lst.de> <20040206174815.A10879@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:5848 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266474AbUBGIDG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Feb 2004 03:03:06 -0500
Content-Disposition: inline
In-Reply-To: <20040206174815.A10879@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jes Sorensen <jes@wildopensource.com>, linux-scsi@vger.kernel.org

On Fri, Feb 06, 2004 at 05:48:15PM -0800, Patrick Mansfield wrote:
> > Warning:  this patch hasn't actually been tested on a currently
> > supported chip due to lack of hardware.
> 
> So with this patch should 1020's work OK with this driver?

Not yet.  There's another bunch of changes needed, but this is the
intrusive part, I'll hopefully submit those next week when I'm 
comfortable with the changes.

