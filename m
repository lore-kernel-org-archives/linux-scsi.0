From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] IA64: iommu uses sg_next with an invalid sg element
Date: Wed, 17 Oct 2007 10:51:47 +0200
Message-ID: <20071017085147.GJ5043@kernel.dk>
References: <20071017174927N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:11663 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbXJQIwO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 04:52:14 -0400
Content-Disposition: inline
In-Reply-To: <20071017174927N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, linux-scsi@vger.kernel.org, tomof@acm.org

On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> sg list elements might not be continuous.

Thanks, applied.

-- 
Jens Axboe

