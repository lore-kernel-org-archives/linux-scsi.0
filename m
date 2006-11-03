From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 5/8] resend cciss: disable DMA prefetch on P600
Date: Fri, 3 Nov 2006 16:58:01 +0100
Message-ID: <20061103155800.GJ13555@kernel.dk>
References: <20061103155412.GA1657@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:22881 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1753286AbWKCP4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2006 10:56:06 -0500
Content-Disposition: inline
In-Reply-To: <20061103155412.GA1657@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Nov 03 2006, Mike Miller (OS Dev) wrote:
> PATCH 5 of 8 resend
> 
> This patch unconditionally disables DMA prefetch on the P600 controller. A
> bug in the ASIC may result in prefetching either beyond the end of memory
> or to fall off into a memory hole.
> Please consider this for inclusion.
> 
> Thanks,
> mikem
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>

Acked-by: Jens Axboe <jens.axboe@oracle.com>

When you are done with the review comments, just repost the full series
again so it can be easily included.

-- 
Jens Axboe

