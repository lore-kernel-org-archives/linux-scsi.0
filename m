From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Mon, 24 Mar 2003 16:30:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7F78FD.5030605@splentec.com>
References: <20030319182755.A9535@beaverton.ibm.com> <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com> <3E7B7A9A.6030007@splentec.com> <20030321165050.B9578@beaverton.ibm.com> <3E7F3C67.5010704@splentec.com> <20030324112940.A11000@beaverton.ibm.com> <3E7F688C.3020009@splentec.com> <20030324202509.GF2371@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> 
> 
> Irk no, that's quite a bad idea.

Of course it's bad idea -- that's what I've been saying in
all my emails in this thread, but no one listens, until now.

> I completely agree with you that making assumptions about q->queue_lock
> == host lock is really really bad. Don't do that.

Well, Jens, after 4 emails saying the same thing in different
words, but seeing no feedback, I _had to_ yield.

But, I'm nevetheless learning how to participate in
mailing lists -- just keep saying the same thing
in different words, until ppl get what you're trying
to say.

-- 
Luben


