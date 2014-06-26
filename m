From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 0/4] ARM randconfig fixes for SCSI
Date: Thu, 26 Jun 2014 14:11:39 +1000 (EST)
Message-ID: <alpine.LNX.2.00.1406261340220.6206@nippy.intranet>
References: <1402003789-1990031-1-git-send-email-arnd@arndb.de> <20140625110457.GD19181@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52622 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaFZEMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 00:12:42 -0400
In-Reply-To: <20140625110457.GD19181@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Matthew Wilcox <matthew@wil.cx>, Michael Schmitz <schmitzmic@gmail.com>


On Wed, 25 Jun 2014, Christoph Hellwig wrote:

> Can I get another set of reviews for these?

Reviewed-by: Finn Thain <fthain@telegraphics.com.au>

(All four patches.)

> >   [SCSI] pas16: don't call free_dma()
> >   [SCSI] qlogicfas: don't call free_dma()

BTW, I found that the suprious free_dma() calls appeared in 2.5.73 when a 
generic release implementation was apparently added to drivers that lacked 
any release method.

--
