From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] add bsg queue resize
Date: Sun, 21 Jan 2007 15:09:13 +1100
Message-ID: <20070121040913.GG4658@kernel.dk>
References: <20070120232518E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fallbackmx02.syd.optusnet.com.au ([211.29.133.72]:43540 "EHLO
	fallbackmx02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbXAUTHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Jan 2007 14:07:09 -0500
Received: from mail06.syd.optusnet.com.au (mail06.syd.optusnet.com.au [211.29.132.187])
	by fallbackmx02.syd.optusnet.com.au (8.12.11.20060308/8.12.11) with ESMTP id l0L4As6q023787
	for <linux-scsi@vger.kernel.org>; Sun, 21 Jan 2007 15:10:54 +1100
Content-Disposition: inline
In-Reply-To: <20070120232518E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Sat, Jan 20 2007, FUJITA Tomonori wrote:
> This enables bsg to resize the queue depth via
> SG_SET_COMMAND_Q. bsg_command structures are allocated via mempool
> because the previous way to use contiguous memory makes it difficult
> to resize the queue depth when a bsg_device has outstanding commands.

You work quickly! I'll give this a review during the flight back, if
everything is alright I'll merge it up. Thanks!

-- 
Jens Axboe

