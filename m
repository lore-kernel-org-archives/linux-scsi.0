From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH 05/10] block: convert to pos and nr_sectors accessors
Date: Thu, 30 Apr 2009 18:30:33 +0100
Message-ID: <1241112633.4698.1.camel@localhost.localdomain>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
	 <1240996428-10159-6-git-send-email-tj@kernel.org>
	 <1241037446.4516.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:21318 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932971AbZD3Rld (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2009 13:41:33 -0400
In-Reply-To: <1241037446.4516.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, Jeff Garzik <jgarzik@pobox.com>

On Wed, 2009-04-29 at 21:39 +0100, Adrian McMenamin wrote:
> On Wed, 2009-04-29 at 18:13 +0900, Tejun Heo wrote:
> > With recent cleanups, there is no place where low level driver
> > directly manipulates request fields.  This means that the 'hard'
> > request fields always equal the !hard fields.  Convert all
> > rq->sectors, nr_sectors and current_nr_sectors references to
> > accessors.
> > 
> 
> Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Apologies, my sendmail was setup badly after a recent mail server crash
so this bounced alot. Hopefully it will reach everybody this time.

