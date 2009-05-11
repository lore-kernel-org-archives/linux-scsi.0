From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: libsas depends on HAS_DMA
Date: Mon, 11 May 2009 23:16:20 +0000
Message-ID: <200905112316.20574.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de> <1242082233.27353.9.camel@mulgrave.int.hansenpartnership.com> <1242082784.27353.13.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:55607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZEKXQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2009 19:16:22 -0400
In-Reply-To: <1242082784.27353.13.camel@mulgrave.int.hansenpartnership.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Monday 11 May 2009 22:59:44 James Bottomley wrote:
> Actually, looking at this further, the problem is only in the ata
> compatibility layer because of the way libata does dma mapping on behalf
> of drivers, so the solution below (just disable SATA support if HAS_DMA
> isn't defined) will work without requiring select dependency
> modification.

Ah, in that case, the patch should not be needed at all, because
SCSI_SAS_ATA already depends on ATA, and I also submitted a patch
to make ATA depend on HAS_DMA.

Thanks for looking at it.

	Arnd <><
