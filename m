From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] prepare qla1280 drivers for ISP1020/1040 support
Date: Fri, 6 Feb 2004 17:48:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040206174815.A10879@beaverton.ibm.com>
References: <20040206155632.GA4679@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:5083 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265630AbUBGBsx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2004 20:48:53 -0500
Content-Disposition: inline
In-Reply-To: <20040206155632.GA4679@lst.de>; from hch@lst.de on Fri, Feb 06, 2004 at 04:56:32PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jes Sorensen <jes@wildopensource.com>, linux-scsi@vger.kernel.org

On Fri, Feb 06, 2004 at 04:56:32PM +0100, Christoph Hellwig wrote:
> I thought it might be a good idea to not dump a huge patch with all my
> restructuring at you when I'm done, so here's the bits of the 1040
> support I'm already comfortable with and that make sense to merge.
> 
> Really new is only the firmware loading by PIO as needed by the
> 1020/1040, everything else is some restructuring to make the code more
> readable and easiert to hack.  This includes the flush_cache_all removal
> I sent to the list.
> 
> Warning:  this patch hasn't actually been tested on a currently
> supported chip due to lack of hardware.

So with this patch should 1020's work OK with this driver?

i.e. these:

00:0a.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 05)
02:0a.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 05)

I am still using qlogicisp for a root disk, and on another system to test
various storage.

-- Patrick Mansfield
