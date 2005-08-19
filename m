From: Christoph Hellwig <hch@infradead.org>
Subject: Re: increase SD_STATS ?
Date: Fri, 19 Aug 2005 10:27:11 +0100
Message-ID: <20050819092711.GA28752@infradead.org>
References: <43059223.4020205@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:14514 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932593AbVHSJ1M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 05:27:12 -0400
Content-Disposition: inline
In-Reply-To: <43059223.4020205@ext.bull.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Aug 19, 2005 at 10:02:43AM +0200, Frederic TEMPORELLI wrote:
> Hi,
> 
> 
> Due to SD_STATS=256  (/drivers/scsi/sd.c)
> there's a limit on the max /dev/sd devices.
> 
> Now, we have a large FC fabric, with more than 3500 LUNs...
> => Of course, we have an Oops when an HBA is connected to the fabric
> (still sd.c, BUG in function sd_iostats_bump when sd>SD_STATS)
> 
> What (bad) side-effects can be expected if we increase SD_STATS (4096 
> should be nice, may be 8192) ?

>From you description it looks like you are using some odd 2.4.x vendor
tree.  Just upgrade to latest 2.6 and these limitations will go away.

