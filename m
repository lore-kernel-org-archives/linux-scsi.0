From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] bsg: use lib/idr.c to find a unique minor number
Date: Mon, 23 Jul 2007 08:38:36 +0200
Message-ID: <20070723063836.GX11657@kernel.dk>
References: <20070723093326S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:15699 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588AbXGWGiZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jul 2007 02:38:25 -0400
Content-Disposition: inline
In-Reply-To: <20070723093326S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Mon, Jul 23 2007, FUJITA Tomonori wrote:
> This replaces the current linear search for a unique minor number with
> lib/idr.c.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Awesome, that's a very nice improvement both for code and performance.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

