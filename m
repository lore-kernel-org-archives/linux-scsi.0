From: Tejun Heo <htejun@gmail.com>
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len, take#2
Date: Tue, 05 May 2009 12:59:58 +0900
Message-ID: <49FFB9BE.1090709@gmail.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241423927-11871-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
List-Id: linux-scsi@vger.kernel.org

Hello,

Tejun Heo wrote:
> Upon ack, please pull from the following git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len

git tree has been updated as per comments.

* Acked-by:'s added.

* Too early blk_rq_bytes() conversion in ide-tape pushed to later
  patch.

Both changes are minor and don't make any difference to the final
result.  The new commit is f7ff5f0d7cda0b0da5e7de36dd97ff75412bbe16.

Thanks.

-- 
tejun
