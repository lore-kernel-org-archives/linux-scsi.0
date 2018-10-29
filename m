From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 06/14] blk-mq: add 'type' attribute to the sysfs hctx
 directory
Date: Mon, 29 Oct 2018 10:40:09 -0700
Message-ID: <1540834809.196084.65.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-7-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-7-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4 It can be useful for a user to verify what type a given hardware
+AD4 queue is, expose this information in sysfs.

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
