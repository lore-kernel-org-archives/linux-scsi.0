From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 04/10] block: implement blk_rq_pos/[cur_]sectors() and
	convert obvious ones
Date: Wed, 29 Apr 2009 08:49:43 -0600
Message-ID: <fa686aa40904290749v62a3cf70kc2d6b2a437b0bfe4@mail.gmail.com>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
	<1240996428-10159-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34429 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbZD2OuF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 10:50:05 -0400
In-Reply-To: <1240996428-10159-5-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com

On Wed, Apr 29, 2009 at 3:13 AM, Tejun Heo <tj@kernel.org> wrote:
> Implement accessors - blk_rq_pos(), blk_rq_sectors() and
> blk_rq_cur_sectors() which return rq->sector, rq->hard_nr_sectors and
> rq->hard_cur_sectors respectively and convert direct references of th=
e
> said fields to the accessors.
>
> This is in preparation of request data length handling cleanup.
>
> [ Impact: cleanup ]
> ---
[...]
> =A0drivers/block/xsysace.c =A0 =A0 =A0 =A0 | =A0 10 +++++-----

Tested-by: and Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.

--=20
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
