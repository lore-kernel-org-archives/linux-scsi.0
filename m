From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] unexport sg v3 helper functions
Date: Tue, 24 Jul 2007 07:23:26 -0400
Message-ID: <46A5E12E.2060804@torque.net>
References: <20070722033008L.tomof@acm.org> <20070723120222.GI11657@kernel.dk> <46A57410.1090605@torque.net> <20070724064954.GD3287@kernel.dk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41944 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762039AbXGXLYX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 07:24:23 -0400
In-Reply-To: <20070724064954.GD3287@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Jens Axboe wrote:
> On Mon, Jul 23 2007, Douglas Gilbert wrote:
>> Jens Axboe wrote:
>>> On Sun, Jul 22 2007, FUJITA Tomonori wrote:
>>>> blk_fill_sghdr_rq, blk_unmap_sghdr_rq, and blk_complete_sghdr_rq were
>>>> exported for bsg, however bsg was changed to support only sg v4.
>>>>
>>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>> Acked-by: Jens Axboe <jens.axboe@oracle.com>
>> Why?
> 
> The reasoning is right there, a few lines up - bsg doesn't support sg v3
> commands.

I can read.

Why doesn't bsg support sg v3 commands?
