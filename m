From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Date: Thu, 24 May 2007 11:08:27 +0100
Message-ID: <20070524110827.65e49b78@the-village.bc.nu>
References: <fa.6bUV4KR+za7HW4tT2WBlccqvoq0@ifi.uio.no>
	<fa.NYl60pD1cwd1ESdKNCPaOwSz1WA@ifi.uio.no>
	<fa.hW9tQQfgwmXj0gAKQoWXOxVzpvk@ifi.uio.no>
	<fa.xLFpJ54sTvGq6YIol2Ew31Rrq2s@ifi.uio.no>
	<fa.JZsPKKyEKOAfxp6reMY5ZwSNjQU@ifi.uio.no>
	<fa.txrEcCPLxIukzeVBv7UG39WubcI@ifi.uio.no>
	<46552292.3090207@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55358 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754768AbXEXKEA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 06:04:00 -0400
In-Reply-To: <46552292.3090207@shaw.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>, Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

> > That didn't used to work right on the AMD boards when I tried it last as
> > we ended up with a buffer that was mapped by the IOMMU for some reason
> > and that was not below 2GB.
> 
> The physical address you mean? If that is still happening then it needs 
> to get fixed. The allocation should not succeed if it can't provide 
> memory that's inside the DMA mask for the device..

But the allocation can succeed - using GFP_DMA at least you can do it as
you get memory below 2^24 you don't need to map via the IOMMU
