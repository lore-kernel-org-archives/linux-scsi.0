From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] bnx2fc: fix incorrect DMA memory mapping in
	bnx2fc_map_sg()
Date: Fri, 22 Aug 2014 14:11:06 +0200
Message-ID: <20140822121106.GA14110@lst.de>
References: <1407140413-4561-1-git-send-email-mlombard@redhat.com> <1408556122.10706.20.camel@lbirv-waie-lx2.broadcom.com> <53F7091C.1080400@redhat.com> <alpine.OSX.2.00.1408220805170.360@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36117 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273AbaHVMLK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2014 08:11:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1408220805170.360@administrators-macbook-pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>, Eddie Wai <eddie.wai@broadcom.com>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, hch@lst.de

On Fri, Aug 22, 2014 at 08:08:33AM -0400, Chad Dupuis wrote:
> Eddie, Maurizio,
>
> Since it looks like there can be a difference in the pdev would it make 
> sense instead to convert the unmap function to use the bare DMA API so 
> we're consistent in our use of hba->pcidev->dev?  Maybe something like 
> this:

This looks like a better plan to me.  Can you also document why you
are using plain dma_map/unmap_sg and a different dma device in the code?

