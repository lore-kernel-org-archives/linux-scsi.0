From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/2] libata: remove blk_queue_max_phys_segments
Date: Mon, 3 Sep 2007 12:29:43 +0200
Message-ID: <20070903102943.GN4253@kernel.dk>
References: <20070903103519T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:12915 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbXICKeF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Sep 2007 06:34:05 -0400
Content-Disposition: inline
In-Reply-To: <20070903103519T.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Mon, Sep 03 2007, FUJITA Tomonori wrote:
> Jeff, can I get your ACK on this patch?
> 
> Whatever in a request queue we set, iommu code ignores all the sg list
> limitations.

It has my ack, libata should not fiddle with the physical segment
setting, since it's not managing the (non-hardware) side of the sg
table.

-- 
Jens Axboe

