From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: block/bsg.c
Date: Mon, 16 Jul 2007 20:00:53 -0700
Message-ID: <469C30E5.9060909@goop.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>	<469C11B1.8000302@garzik.org>	<20070716175347.bea345dd.akpm@linux-foundation.org>	<469C1423.3090908@garzik.org> <20070716180908.e15325bd.akpm@linux-foundation.org> <469C1FA9.3090809@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:33265 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbXGQDBu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 23:01:50 -0400
In-Reply-To: <469C1FA9.3090809@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> + uninitialized_var(ino.partitionReferenceNum);
> +
>                                 if (!UDF_SB_LASTBLOCK(sb))
>
> still yields
>
> fs/udf/super.c: In function =91udf_fill_super=92:
> fs/udf/super.c:1359: warning: =91ino.partitionReferenceNum=92 may be =
used
> uninitialized in this function

It only works on declarations:

	int uninitialized_var(foo);


    J
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
