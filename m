From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 09:21:49 +0200
Message-ID: <20071017072149.GC5041@kernel.dk>
References: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:18808 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXJQHWQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 03:22:16 -0400
Content-Disposition: inline
In-Reply-To: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> Commit 2c941a204070ab32d92d40318a3196a7fb994c00 looks incomplete. The
> helper functions like prepare_sg() need to support sg chaining too.

Thanks Tomo, applied. I'll get this pushed out later today with any
other sg chaining fallout we may see.

-- 
Jens Axboe

