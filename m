From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] ARM randconfig fixes for SCSI
Date: Wed, 25 Jun 2014 13:04:57 +0200
Message-ID: <20140625110457.GD19181@infradead.org>
References: <1402003789-1990031-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57858 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFYLCm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 07:02:42 -0400
Content-Disposition: inline
In-Reply-To: <1402003789-1990031-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Matthew Wilcox <matthew@wil.cx>, Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>

Can I get another set of reviews for these?

On Thu, Jun 05, 2014 at 11:29:45PM +0200, Arnd Bergmann wrote:
> Hi James,
> 
> These are some fixes for ancient randconfig build bugs I
> ran into on ARM. Clearly none of these are urgent, but it
> would be nice to have them merged for 3.17 if they look
> good to you.
> 
> Arnd Bergmann (4):
>   [SCSI] Don't build AdvanSys on ARM
>   [SCSI] pas16: don't call free_dma()
>   [SCSI] qlogicfas: don't call free_dma()
>   [SCSI] NCR53c406a: don't call free_dma() by default
> 
>  drivers/scsi/Kconfig      | 2 +-
>  drivers/scsi/NCR53c406a.c | 2 +-
>  drivers/scsi/pas16.c      | 2 --
>  drivers/scsi/qlogicfas.c  | 2 --
>  4 files changed, 2 insertions(+), 6 deletions(-)
> 
> -- 
> 1.8.3.2
> 
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
