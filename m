From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Thu, 7 May 2009 19:23:24 +0900
Message-ID: <20090507184820F.fujita.tomonori@lab.ntt.co.jp>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
	<1241423927-11871-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241423927-11871-4-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, dgilbert@interlog.com, djwong@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Mon,  4 May 2009 16:58:39 +0900
Tejun Heo <tj@kernel.org> wrote:

> Cc: Pete Zaitcev <zaitcev@redhat.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  block/bsg.c                              |    8 +++---

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

The changes to sg, st, and smp stuff also look fine.
