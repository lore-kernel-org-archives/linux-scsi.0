From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 15:20:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <404249AA.4050808@pobox.com>
References: <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <137982704.1078081053@aslan.btc.adaptec.com> <404236C1.5000001@pobox.com> <156412704.1078082931@aslan.btc.adaptec.com> <40423F7B.4020102@pobox.com> <162922704.1078083749@aslan.btc.adaptec.com> <4042410C.7070701@pobox.com> <20040229200636.GI31904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3538 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262130AbUB2UVL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 15:21:11 -0500
In-Reply-To: <20040229200636.GI31904@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Jens Axboe wrote:
> Don't forget that this isn't the only condition. What about pci dma
> mapping failures?


hehe, granted there might be other conditions, but for PCI DMA mapping 
specifically, it is (unfortunately) currently defined to not fail.

That wants changing for ppc64 and x86-64 iommu, which are a -lot- more 
likely to fail an iommu transaction than parisc or sparc64... but that's 
the way it is for now.  Way too many drivers assume PCI DMA mapping 
always succeeds.

	Jeff



