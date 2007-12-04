From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 00/28] blk_end_request: full I/O completion handler
	(take 3)
Date: Tue, 4 Dec 2007 13:06:13 +0100
Message-ID: <20071204120612.GP23294@kernel.dk>
References: <20071130.182351.115904044.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:14729 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXLDMIW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 07:08:22 -0500
Content-Disposition: inline
In-Reply-To: <20071130.182351.115904044.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com

On Fri, Nov 30 2007, Kiyoshi Ueda wrote:
> Hello Jens,
> 
> The following is the updated patch-set for blk_end_request().
> Changes since the last version are only minor updates to catch up
> with the base kernel changes.
> Do you agree the implementation of blk_end_request()?
> If there's no problem, could you merge it to your tree?
> Or does it have to be merged to -mm tree first?

Looks good to me now, I'll queue it up. Thanks!

-- 
Jens Axboe

