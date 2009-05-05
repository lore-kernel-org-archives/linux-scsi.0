From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 04/11] block: implement blk_rq_pos/[cur_]sectors() and
 convert obvious ones
Date: Tue, 05 May 2009 12:42:16 +0900
Message-ID: <49FFB598.4090205@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-5-git-send-email-tj@kernel.org> <49FEF174.6040505@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49FEF174.6040505@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

Sergei Shtylyov wrote:
> Tejun Heo wrote:
> 
>> Implement accessors - blk_rq_pos(), blk_rq_sectors() and
>> blk_rq_cur_sectors() which return rq->sector, rq->hard_nr_sectors and
> 
>    Well, blk_rq_pos() returns rq->hard_sector, not rq->sector, doesn't it?

Right, description updated.

Thanks.

-- 
tejun
