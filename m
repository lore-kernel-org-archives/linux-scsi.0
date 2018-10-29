From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 05/14] blk-mq: allow software queue to map to multiple
 hardware queues
Date: Mon, 29 Oct 2018 10:34:34 -0700
Message-ID: <1540834474.196084.64.camel@acm.org>
References: <20181029163738.10172-1-axboe@kernel.dk>
         <20181029163738.10172-6-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-6-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
+AD4 The mapping used to be dependent on just the CPU location, but
+AD4 now it's a tuple of +AHs type, cpu+AH0 instead. This is a prep patch
+AD4 for allowing a single software queue to map to multiple hardware
+AD4 queues. No functional changes in this patch.

A nitpick: mathematicians usually use the +AHs +AH0 notation for sets and () for
tuples. See also https://en.wikipedia.org/wiki/Tuple.

+AD4 +-		/+ACo wrap +ACo-/
+AD4 +-		BUG+AF8-ON(+ACE-hctx-+AD4-nr+AF8-ctx)+ADs

Another nitpick: how about changing the +ACI-wrap+ACI comment into +ACI-detect integer
overflow+ACI or so to make the purpose of the BUG+AF8-ON() statement more clear?

Thanks,

Bart.
