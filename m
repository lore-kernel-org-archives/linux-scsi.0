From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer in scsi_cmnd
Date: Fri, 21 Dec 2007 07:00:25 -0700
Message-ID: <20071221140024.GO29690@parisc-linux.org>
References: <20071221023011.4C4BADDDFA@ozlabs.org> <20071221103326.7ce1bc4f@the-village.bc.nu> <20071221131640.GN29690@parisc-linux.org> <20071221133027.GA11495@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60746 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbXLUOA0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Dec 2007 09:00:26 -0500
Content-Disposition: inline
In-Reply-To: <20071221133027.GA11495@alpha.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org

On Fri, Dec 21, 2007 at 02:30:28PM +0100, Thomas Bogendoerfer wrote:
> there are SCSI host drivers, which also DMA to the sense buffer like
> sgiwd93.c for example.

Yes ... and there are others which don't, for example qla2xxx and
sym53c8xx.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
