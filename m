From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] unexport sg v3 helper functions
Date: Mon, 23 Jul 2007 23:37:52 -0400
Message-ID: <46A57410.1090605@torque.net>
References: <20070722033008L.tomof@acm.org> <20070723120222.GI11657@kernel.dk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53531 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbXGXDit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jul 2007 23:38:49 -0400
In-Reply-To: <20070723120222.GI11657@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Jens Axboe wrote:
> On Sun, Jul 22 2007, FUJITA Tomonori wrote:
>> blk_fill_sghdr_rq, blk_unmap_sghdr_rq, and blk_complete_sghdr_rq were
>> exported for bsg, however bsg was changed to support only sg v4.
>>
>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Acked-by: Jens Axboe <jens.axboe@oracle.com>

Why?


