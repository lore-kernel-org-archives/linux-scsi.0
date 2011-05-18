From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/3] bsg: fix bsg_poll() to return POLLOUT properly
Date: Wed, 18 May 2011 21:30:57 +0200
Message-ID: <4DD41E71.6080103@kernel.dk>
References: <1305437513-3914-1-git-send-email-namhyung@gmail.com> <20110519.030933.1568838937885764850.fujita.tomonori@lab.ntt.co.jp@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54572 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933756Ab1ERTa7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 15:30:59 -0400
In-Reply-To: <20110519.030933.1568838937885764850.fujita.tomonori@lab.ntt.co.jp@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: namhyung@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@suse.de

On 2011-05-18 20:09, FUJITA Tomonori wrote:
> On Sun, 15 May 2011 14:31:51 +0900
> Namhyung Kim <namhyung@gmail.com> wrote:
> 
>> POLLOUT should be returned only if bd->queued_cmds < bd->max_queue
>> so that bsg_alloc_command() can proceed.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> ---
>>  block/bsg.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> All the three patches look good.
> 
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

You can add mine, too.

Acked-by: Jens Axboe <jaxboe@fusionio.com>

-- 
Jens Axboe

