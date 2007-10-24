From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm 01/11] add device_dma_parameters structure
Date: Wed, 24 Oct 2007 07:33:06 -0400
Message-ID: <471F2D72.1060501@garzik.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024174021G.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60484 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXJXLdL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 07:33:11 -0400
In-Reply-To: <20071024174021G.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, greg@kroah.com, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> iommu code merges scatter/gather segments without considering a low
> level driver's restrictions. The problem is that iommu code can't
> access to the limitations because they are in request_queue.
> 
> This patch adds a new structure, device_dma_parameters, including dma
> information. A pointer to device_dma_parameters is added to struct
> device.
> 
> - there are only max_segment_size and segment_boundary_mask there but
> we'll move more dma stuff in struct device (like dma_mask) to struct
> device_dma_parameters later. segment_boundary_mask is not supported
> yet.
> 
> - new accessors for the dma parameters are added. So we can easily
> change where to place struct device_dma_parameters in the future.
> 
> - dma_get_max_seg_size returns 64K if dma_parms in struct device isn't
> set up properly. 64K is the default max_segment_size in the block
> layer.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  include/linux/device.h      |   11 +++++++++++
>  include/linux/dma-mapping.h |   15 +++++++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)

ACK


