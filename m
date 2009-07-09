From: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Thu, 9 Jul 2009 08:27:45 +0200
Message-ID: <8db1092f0907082327vb3805d3id58dc6cbe71a746c@mail.gmail.com>
References: <1247069178.5973.6.camel@desktop>
	 <1247071445.4159.214.camel@mulgrave.site>
	 <20090708165728.GU23611@kernel.dk>
	 <20090709084839G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:52456 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZGIG1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 02:27:47 -0400
In-Reply-To: <20090709084839G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, dwalker@fifo99.com, akpm@linux-foundation.org, tarkan.erimer@turknet.net.tr, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

2009/7/9 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: call blk_scsi_ioctl_init()
>
> Currently, blk_scsi_ioctl_init() is not called so
> blk_default_cmd_filter isn't initalized. Some commands are not blocke=
d
> wrongly.
>
> This fixes a regression introduced:
>
> commit 018e0446890661504783f92388ecce7138c1566d
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date: =C2=A0 Fri Jun 26 16:27:10 2009 +0200
>
> =C2=A0 =C2=A0block: get rid of queue-private command filter
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Works with latest git. Thanks for patch

Tested-by Maciej Rutecki <maciej.rutecki@gmail>


--=20
Maciej Rutecki
http://www.maciek.unixy.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
