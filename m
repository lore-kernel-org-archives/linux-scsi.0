From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] block/sd: Fix device-imposed transfer length limits
Date: Thu, 19 Nov 2015 00:32:35 -0800
Message-ID: <20151119083235.GC11419@infradead.org>
References: <1447451209-30772-1-git-send-email-martin.petersen@oracle.com>
 <1447451209-30772-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbbKSIcg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2015 03:32:36 -0500
Content-Disposition: inline
In-Reply-To: <1447451209-30772-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

>  - blk_limits_max_hw_sectors() is no longer used and can be removed.

Killing that first in a separate patch would have been a tad cleaner.

Otherwise looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
