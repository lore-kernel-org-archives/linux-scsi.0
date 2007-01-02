From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] block: export blk_verify_command for SG v4
Date: Tue, 2 Jan 2007 11:49:16 +0000
Message-ID: <20070102114916.GC24951@infradead.org>
References: <20061216001756S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49249 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbXABLtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 06:49:18 -0500
Content-Disposition: inline
In-Reply-To: <20061216001756S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

On Sat, Dec 16, 2006 at 12:18:23AM +0900, FUJITA Tomonori wrote:
> blk_fill_sghdr_rq doesn't work for SG v4 so verify_command needed to
> be exported.

So fixup blk_fill_sghdr_rq to deal with SG v4 aswell.  We really
need to support all SGv4 features in the core code - bsg should
only be a small wrapper around core functionality at the end.

And while you're touching this code, is there any chance you could
unifity the command permission tables for the block layer code and
the sg driver?  This has been long overdue.

doug has a nice document somewhere that documents the differences
between command allowances for the block layer vs the sg driver.
Please go through these and take the more resonable version for
each command.

