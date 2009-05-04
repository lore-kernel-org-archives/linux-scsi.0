From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/10] block: cleanup rq->data_len usages
Date: Mon, 04 May 2009 13:19:56 +0900
Message-ID: <49FE6CEC.2060802@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>	 <1240996428-10159-9-git-send-email-tj@kernel.org>	 <49F9AC04.9060403@panasas.com> <1241105757.3320.1.camel@mulgrave.int.hansenpartnership.com> <49FCF423.7040609@kernel.org> <49FDA164.3030806@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49FDA164.3030806@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

Boaz Harrosh wrote:
> OK, NP. But in this case please note on the side all the places you
> think might be suspect for blk_rq_bytes()/blk_rq_sectors()
> cosolidation and post the list. Because it is now that you are going
> over the code and it is now that you touch exactly all these places.
> 
> You could even put a "TODO:" comments on all these places in this
> patch. So to draw later patches that audit and remove the TODO:.

Heh... okay.  I'll add a patch for the sweep conversion.

> (Or in trivial places like above that are safe even before these
> patches, just convert them silently, in the sense of least traffic)

I really don't want to do that.  Things which might look trivial often
break things and this part of API has been quite fragile, so I'd
rather put those changes after the actual unification for, if nothing
else, documentation.

> But sure I will see what I can help and send patches for. Tell me
> when you think this is stable enough for me to add patches on top
> of.

Yeap, I just finished saving the wasteland, so the refreshed patchset
will be posted later today.  :-)

Thanks.

-- 
tejun
