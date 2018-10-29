From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 02/14] blk-mq: abstract out queue map
Date: Mon, 29 Oct 2018 11:33:59 -0700
Message-ID: <1540838039.196084.78.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-3-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-3-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4 struct blk+AF8-mq+AF8-tag+AF8-set +AHs
+AD4 -	unsigned int		+ACo-mq+AF8-map+ADs
+AD4 +-	struct blk+AF8-mq+AF8-queue+AF8-map	map+AFs-HCTX+AF8-MAX+AF8-TYPES+AF0AOw
+AD4  	const struct blk+AF8-mq+AF8-ops	+ACo-ops+ADs
+AD4  	unsigned int		nr+AF8-hw+AF8-queues+ADs
+AD4  	unsigned int		queue+AF8-depth+ADs	/+ACo max hw supported +ACo-/

How about documenting that nr+AF8-hw+AF8-queues is the number of hardware queues across
all hardware queue types instead of e.g. the number of hardware queues for a
single hardware queue type? This is something that only became clear to me after
having reviewed a later patch in this series. Anyway:

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
