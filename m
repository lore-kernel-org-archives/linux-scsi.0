From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] fix SG_IO bio leak
Date: Mon, 11 Dec 2006 09:55:54 +0100
Message-ID: <20061211085554.GG4576@kernel.dk>
References: <200612101633.kBAGXl6L001306@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:3262 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762654AbWLKIyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Dec 2006 03:54:44 -0500
Content-Disposition: inline
In-Reply-To: <200612101633.kBAGXl6L001306@r-dd.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Mon, Dec 11 2006, FUJITA Tomonori wrote:
> This patch fixes bio leaks in SG_IO.
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=116570666807983&w=2
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Perhaps it was a mistake to remove the bio argument. I'll apply your
patch, and contemplate if we want to strengthen this api a little.
Thanks!

-- 
Jens Axboe

