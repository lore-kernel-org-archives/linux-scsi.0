From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Sun, 9 Apr 2006 21:10:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604092107150.5879@poirot.grange>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:26766 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750826AbWDITK1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Apr 2006 15:10:27 -0400
In-Reply-To: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Frei <Sebastian@schnapsleichen.de>, Fredrik Roubert <roubert@df.lth.se>, lenehan@twibble.org

On Sun, 2 Apr 2006, Guennadi Liakhovetski wrote:

> Hello all,
> 
> This time I really mean it:-)
> 
> The current dc395x driver uses PIO to transfer up to 4 bytes which do not 
> get transferred by DMA (under unclear circumstances). For this the driver 
> uses page_address() which is broken on highmem. Apart from this the 
> actual calculation of the virtual address is wrong (even without highmem). 
> So, e.g., for reading it reads bytes from the driver to a wrong address 
> and returns wrong data, I guess, for writing it would just output random 
> data to the device.

It's been a week since the patch submission. James, Jamie, I'd really like 
to hear some feedback.

Thanks
Guennadi
---
Guennadi Liakhovetski
