From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] [SCSI] pas16: don't call free_dma()
Date: Wed, 11 Jun 2014 05:17:27 -0700
Message-ID: <20140611121727.GC8389@infradead.org>
References: <1402003789-1990031-1-git-send-email-arnd@arndb.de>
 <1402003789-1990031-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaFKMR3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 08:17:29 -0400
Content-Disposition: inline
In-Reply-To: <1402003789-1990031-3-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>

On Thu, Jun 05, 2014 at 11:29:47PM +0200, Arnd Bergmann wrote:
> The pas16 scsi driver does not use DMA, and the call to free_dma()
> in its exit function seems to have been copied incorrectly from
> another driver but never caused trouble.
> 
> One case where it gets in the way is randconfig builds on ARM,
> which depending on the configuration does not provide a free_dma()
> function, causing this build error:

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
