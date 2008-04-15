From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] block: add large command support
Date: Tue, 15 Apr 2008 09:29:01 +0200
Message-ID: <20080415072901.GB12774@kernel.dk>
References: <20080414010112W.tomof@acm.org> <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1208170266-1676-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1208170266-1676-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1208170266-1676-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1208170266-1676-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1208170266-1676-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, bharrosh@panasas.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 14 2008, FUJITA Tomonori wrote:
> This patch changes rq->cmd from the static array to a pointer to
> support large commands.
> 
> We rarely handle large commands. So for optimization, a struct request
> still has a static array for a command. rq_init sets rq->cmd pointer
> to the static array.

I applied 1-4, thanks.

-- 
Jens Axboe

