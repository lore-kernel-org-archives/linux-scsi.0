From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 03/14] blk-mq: provide dummy blk_mq_map_queue_type()
 helper
Date: Mon, 29 Oct 2018 10:22:59 -0700
Message-ID: <1540833779.196084.56.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-4-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-4-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4 diff --git a/block/blk-mq.h b/block/blk-mq.h
+AD4 index 889f0069dd80..79c300faa7ce 100644
+AD4 --- a/block/blk-mq.h
+AD4 +-+-+- b/block/blk-mq.h
+AD4 +AEAAQA -80,6 +-80,12 +AEAAQA static inline struct blk+AF8-mq+AF8-hw+AF8-ctx +ACo-blk+AF8-mq+AF8-map+AF8-queue(struct request+AF8-queue +ACo-q,
+AD4  	return q-+AD4-queue+AF8-hw+AF8-ctx+AFs-set-+AD4-map+AFs-0+AF0.mq+AF8-map+AFs-cpu+AF0AXQA7
+AD4  +AH0
+AD4  
+AD4 +-static inline struct blk+AF8-mq+AF8-hw+AF8-ctx +ACo-blk+AF8-mq+AF8-map+AF8-queue+AF8-type(struct request+AF8-queue +ACo-q,
+AD4 +-							  int type, int cpu)
+AD4 +-+AHs
+AD4 +-	return blk+AF8-mq+AF8-map+AF8-queue(q, cpu)+ADs
+AD4 +-+AH0
+AD4 +-
+AD4  /+ACo
+AD4   +ACo sysfs helpers
+AD4   +ACo-/

How about renaming 'type' into something like hw+AF8-ctx+AF8-type to make it more
clear what its meaning is? How about declaring both the 'type' and 'cpu'
arguments as unsigned ints?

Thanks,

Bart.
