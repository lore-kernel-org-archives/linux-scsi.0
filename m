From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/10] block: convert to pos and nr_sectors accessors
Date: Wed, 29 Apr 2009 08:48:55 -0600
Message-ID: <fa686aa40904290748q410a055eq209a5382c9a5f3e7@mail.gmail.com>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
	<1240996428-10159-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1240996428-10159-6-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 29, 2009 at 3:13 AM, Tejun Heo <tj@kernel.org> wrote:
> With recent cleanups, there is no place where low level driver
> directly manipulates request fields. =A0This means that the 'hard'
> request fields always equal the !hard fields. =A0Convert all
> rq->sectors, nr_sectors and current_nr_sectors references to
> accessors.
>
> [ Impact: use pos and nr_sectors accessors ]
>
> ---
[...]
> =A0drivers/block/xsysace.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 17 ++++++---=
--

Tested-by: and Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.
