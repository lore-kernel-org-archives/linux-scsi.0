From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] remove sglist_len
Date: Thu, 6 Sep 2007 14:25:03 +0200
Message-ID: <20070906122502.GA5341@kernel.dk>
References: <20070906091901G.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:17078 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbXIFM3l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 08:29:41 -0400
Content-Disposition: inline
In-Reply-To: <20070906091901G.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Thu, Sep 06 2007, FUJITA Tomonori wrote:
> This is against Jens' sg chaining branch.
> 
> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=d6beb57f48231f5c012fb7d55b369bc0af6b0c41
> 
> The sg chaining patchset adds __use_sg to save the length of sg list
> before dma mapping. The sg chaining patchset also uses sglist_len but
> we can live without it. So let's remove sglist_len since we can add
> something to scsi_cmnd structure only when we definitely need to do.
> 
> Now the sg chaining provides a way to decrease memory consumption and
> doesn't add anything to scsi_cmnd structure.
> 
> James, do you want to change more about the sg chaining's scsi_lib.c?

Looks good to me!

-- 
Jens Axboe

