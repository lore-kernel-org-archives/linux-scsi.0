From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm 10/11] sata_inic162x: use pci_set_dma_max_seg_size
Date: Wed, 24 Oct 2007 07:39:30 -0400
Message-ID: <471F2EF2.9080304@garzik.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024172847R.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54489 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbXJXLjd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 07:39:33 -0400
In-Reply-To: <20071024172847R.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> This sets the segment size limit properly via pci_set_dma_max_seg_size
> and remove blk_queue_max_segment_size because scsi-ml calls it.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/ata/sata_inic162x.c |   25 +++++++++++++------------
>  1 files changed, 13 insertions(+), 12 deletions(-)

ACK


