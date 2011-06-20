From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 1/3] bsg: fix bsg_poll() to return POLLOUT properly
Date: Mon, 20 Jun 2011 13:25:31 +0200
Message-ID: <4DFF2E2B.3090405@kernel.dk>
References: <1308277029-2193-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37720 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1FTLZd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 07:25:33 -0400
In-Reply-To: <1308277029-2193-1-git-send-email-namhyung@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On 2011-06-17 04:17, Namhyung Kim wrote:
> POLLOUT should be returned only if bd->queued_cmds < bd->max_queue
> so that bsg_alloc_command() can proceed.

I picked up 1-3 and added to for-3.1/drivers

-- 
Jens Axboe

