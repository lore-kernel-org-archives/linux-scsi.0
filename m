From: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 02/10] ide-tape: don't initialize rq->sector for rw
	requests
Date: Thu, 30 Apr 2009 08:14:38 +0200
Message-ID: <20090430061438.GB6725@liondog.tnic>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-3-git-send-email-tj@kernel.org>
Reply-To: petkovbb@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1240996428-10159-3-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 29, 2009 at 06:13:40PM +0900, Tejun Heo wrote:
> rq->sector is set to the tape->first_frame but it's never actually
> used and not even in the correct unit (512 byte sectors).  Don't set
> it.
> 
> [ Impact: cleanup ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
