From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Mon, 24 Mar 2003 16:25:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7F77D6.9040300@splentec.com>
References: <20030319182755.A9535@beaverton.ibm.com> <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com> <3E7B7A9A.6030007@splentec.com> <20030321165050.B9578@beaverton.ibm.com> <3E7F3C67.5010704@splentec.com> <20030324112940.A11000@beaverton.ibm.com> <3E7F688C.3020009@splentec.com> <20030324202509.GF2371@suse.de> <20030324123813.A11614@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> That is another patch.

Then you should've sent it before this one.

But nevertheless, the code of the patch you posted,
assumed that q->queue_lock is the same for all
devices' request queues.  This was my beef
since the very beginning of this thread.

> 
>>Irk no, that's quite a bad idea.
>>
>>I completely agree with you that making assumptions about q->queue_lock
>>== host lock is really really bad. Don't do that.
> 
> Yes, it's bad (with or without the patch in question), I am working on

No!  With the patch in question.

The rest of SCSI Core assumes that q->queue_lock has nothing to do
with any other q's lock.

> patches to make queue_lock per scsi_device (queue_lock != host_lock),
> where I'm forced to make changes in this same area.

-- 
Luben



