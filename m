From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Tue, 08 May 2007 12:58:35 -0500
Message-ID: <1178647115.3737.62.camel@mulgrave.il.steeleye.com>
References: <20070508171710.1ac730cd@the-village.bc.nu>
	 <20070508161444.GA4163@kernel.dk>
	 <1178642376.3737.36.camel@mulgrave.il.steeleye.com>
	 <20070508184256.029cf8a4@the-village.bc.nu>
	 <1178646426.3737.59.camel@mulgrave.il.steeleye.com>
	 <20070508185359.01a1a18d@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54642 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967047AbXEHR6t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 13:58:49 -0400
In-Reply-To: <20070508185359.01a1a18d@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 18:53 +0100, Alan Cox wrote:
> > The ultimate goal is to be able to eliminate the unchecked_isa_dma flag
> > entirely and have the block layer (or device mask allocations) fix all
> > of this in every ULD.
> 
> About time ;)

Actually, I should point out (before those who did the work get
justifiably irritated) that the overall goal is to remove the special
case non-scatter/gather path from all the drivers ... eliminating the
need to worry about DMA zone allocations is just a nice bonus as a side
effect of sending everything through the block layer.

James


