From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 60/77] ncr5380: Implement new eh_abort_handler
Date: Tue, 22 Dec 2015 08:59:15 +0100
Message-ID: <567902D3.4020004@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011754.345477083@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbLVH7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 02:59:17 -0500
In-Reply-To: <20151222011754.345477083@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Introduce a new eh_abort_handler implementation. This one attempts to
> follow all of the rules relating to EH handlers. There is still a kno=
wn
> bug: during selection, a command becomes invisible to the EH handlers
> because it only appears in a pointer on the stack of a different thre=
ad.
> This bug is addressed in a subsequent patch.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |  155 +++++++++++++++++++++++++++++++=
+++++++----
>   drivers/scsi/atari_NCR5380.c |  157 +++++++++++++++++++++++++++++++=
+++++++-----
>   2 files changed, 282 insertions(+), 30 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
