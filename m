From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Mon, 24 Mar 2003 17:15:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7F837E.9020900@splentec.com>
References: <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com> <3E7B7A9A.6030007@splentec.com> <20030321165050.B9578@beaverton.ibm.com> <3E7F3C67.5010704@splentec.com> <20030324112940.A11000@beaverton.ibm.com> <3E7F688C.3020009@splentec.com> <20030324202509.GF2371@suse.de> <20030324123813.A11614@beaverton.ibm.com> <3E7F77D6.9040300@splentec.com> <20030324135640.A12273@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> The current code in scsi_queue_next_request() assume queue_lock ==
> host_lock, as does code in scsi_error.c. We get a queue_lock (or
> host_lock), and then iterate over different q's calling
> __blk_run_queue(q).

1. Please don't speak of queue_lock and host_lock as if they are
the same thing.  They are NOT, even though one points to the other.
This is an infrastructure bug and will have to go.

2. Yes I see this in scsi_error.c. How did this ever slip in!
(yes this is NOT a question, but a statement)

-- 
Luben


