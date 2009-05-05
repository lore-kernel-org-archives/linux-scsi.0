From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 05/11] block: convert to pos and nr_sectors accessors
Date: Tue, 05 May 2009 12:42:43 +0900
Message-ID: <49FFB5B3.3000202@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>	 <1241423927-11871-6-git-send-email-tj@kernel.org> <1241466500.6677.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:52578 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbZEEDo2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2009 23:44:28 -0400
In-Reply-To: <1241466500.6677.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, Jeff Garzik <jgarzik@pobox.com>

Adrian McMenamin wrote:
> On Mon, 2009-05-04 at 16:58 +0900, Tejun Heo wrote:
>> With recent cleanups, there is no place where low level driver
>> directly manipulates request fields.  This means that the 'hard'
>> request fields always equal the !hard fields.  Convert all
>> rq->sectors, nr_sectors and current_nr_sectors references to
>> accessors.
>>
>> [ Impact: use pos and nr_sectors accessors ]
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> Tested-by: Grant Likely <grant.likely@secretlab.ca>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
>> Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
> I have re-tested this on the Dreamcast and it still works :)
> 
> Tested-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> Acked-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

Thanks.  Much appreciated.

-- 
tejun
