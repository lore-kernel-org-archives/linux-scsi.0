From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
 padding in favour of that provided by the block layer
Date: Sun, 03 Feb 2008 16:37:15 +0900
Message-ID: <47A56F2B.4040904@gmail.com>
References: <1199138168.3110.12.camel@localhost.localdomain>	 <1200698057.3111.68.camel@localhost.localdomain>	 <1201894847.3134.59.camel@localhost.localdomain>	 <47A37AF3.3030503@garzik.org>	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com> <1202013174.3187.69.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1202013174.3187.69.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
>> I think the best solution is to update block layer draining such that it
>> can be included together before the merge window closes.  I'll dig into it.
> 
> Like I said, the block layer pieces are already upstream.  All we need
> is the ATA bits and I think it should all work ... unless there's some
> part I haven't though of?

Yeah, I think we'll probably need to add rq->raw_data_len and I'd really
like to map longer drain area but I think the basics are there.  What's
needed is updating libata accordingly and testing it.  I'm currently
away from all my toys.  I'll implement the ATA part, test it and submit
the patch on Monday.

Thanks.

-- 
tejun
