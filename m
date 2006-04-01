From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] Enable clustering and large transfers
Date: Sat, 1 Apr 2006 18:03:45 +0100
Message-ID: <20060401170345.GA4029@infradead.org>
References: <1143561824404-git-send-email-matthew@wil.cx> <Pine.LNX.4.63.0604011656490.10426@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:3275 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751558AbWDARDr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 12:03:47 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0604011656490.10426@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

On Sat, Apr 01, 2006 at 05:35:13PM +0300, Kai Makisara wrote:
> I have done some more investigation based on the message from Gerard 
> Roudier that Jens found. I fetched the FreeBSD driver. It had a 
> work-around for the 896 rev. 1 chips but I did not find that in the Linux 
> version. The work-around does build two device s/g elements for any 
> original s/g segment that crosses a 16 MB boundary.
> 
> In Linux we can do that by setting the .dma_boundary field in the 
> scsi_host_template. Would it be an acceptable solution to set the 16 MB 
> limit for all sym53c8xx adapters? It would take care of the known errata 
> and Gerards suspicions about possible problems with other chips.

We can also set the flag in the scsi_host so not all adapters are punished.

