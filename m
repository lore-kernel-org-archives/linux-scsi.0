From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH 16/18] gdrom: dequeue in-flight request
Date: Fri, 08 May 2009 20:53:45 +0100
Message-ID: <1241812425.18200.0.camel@localhost.localdomain>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
	 <1241751256-17435-17-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-17-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On Fri, 2009-05-08 at 11:54 +0900, Tejun Heo wrote:
> gdrom already dequeues and fully completes requests on normal path and
> the error paths can be easily converted to do so too.  Clean it up and
> dequeue requests on error paths too.
> 
> While at it remove superflous blk_fs_request() && !blk_rq_sectors()
> condition check.
> 
> [ Impact: dequeue in-flight request, cleanup ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> ---

Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

