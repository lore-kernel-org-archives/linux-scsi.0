From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] mvsas: add SGPIO support to Marvell 94xx
Date: Fri, 18 Dec 2015 10:19:24 +0100
Message-ID: <5673CF9C.3070909@suse.de>
References: <5645BEE0.3050406@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966812AbbLRJTZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:19:25 -0500
In-Reply-To: <5645BEE0.3050406@gmx.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>, JBottomley@odin.com, linux-scsi@vger.kernel.org

On 11/13/2015 11:43 AM, Wilfried Weissmann wrote:
> add SGPIO support to Marvell 94xx
>
> Signed-off-by: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>
> ---
>
>   drivers/scsi/mvsas/mv_94xx.c |  134 +++++++++++++++++++++++++++++++=
++
>   drivers/scsi/mvsas/mv_94xx.h |   71 +++++++++++++++++
>   drivers/scsi/mvsas/mv_init.c |    2
>   drivers/scsi/mvsas/mv_sas.c  |   13 +++
>   drivers/scsi/mvsas/mv_sas.h  |    5 +
>   5 files changed, 225 insertions(+)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
