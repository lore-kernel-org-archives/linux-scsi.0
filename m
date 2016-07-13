From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] ipr: Add scsi multi-queue support
Date: Tue, 12 Jul 2016 17:55:00 -0700
Message-ID: <20160713005500.GA24478@infradead.org>
References: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
 <1468357329-3790-3-git-send-email-wenxiong@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51804 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbcGMAz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 20:55:58 -0400
Content-Disposition: inline
In-Reply-To: <1468357329-3790-3-git-send-email-wenxiong@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, JBottomley@Odin.com, martin.petersen@oracle.com, brking@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com

On Tue, Jul 12, 2016 at 04:02:09PM -0500, wenxiong@linux.vnet.ibm.com wrote:
> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> 
> Add scsi multi-queue support in ipr driver. This feature
> is enabled by setting ipr_use_blk_mq=1 when loading ipr
> module and scsi blk-mq is enabled in the kernel.

This is not a useful option, as using of blk-mq is not up to the
driver.  If you want to control the number of queues used please
add a nr_queues option instead.
