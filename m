From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/7] bnx2fc: Remove 'NetXtreme II' from source files.
Date: Wed, 21 Oct 2015 12:22:02 +0200
Message-ID: <5627674A.4060104@suse.de>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com> <1445283641-7358-3-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbbJUKWD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2015 06:22:03 -0400
In-Reply-To: <1445283641-7358-3-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 10/19/2015 09:40 PM, Chad Dupuis wrote:
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h  |    2 +-
>  drivers/scsi/bnx2fc/Kconfig            |    5 ++---
>  drivers/scsi/bnx2fc/bnx2fc.h           |    2 +-
>  drivers/scsi/bnx2fc/bnx2fc_constants.h |    2 +-
>  drivers/scsi/bnx2fc/bnx2fc_debug.c     |    2 +-
>  drivers/scsi/bnx2fc/bnx2fc_debug.h     |    2 +-
>  drivers/scsi/bnx2fc/bnx2fc_els.c       |    2 +-
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c      |    6 +++---
>  drivers/scsi/bnx2fc/bnx2fc_hwi.c       |    2 +-
>  drivers/scsi/bnx2fc/bnx2fc_io.c        |    2 +-
>  drivers/scsi/bnx2fc/bnx2fc_tgt.c       |    2 +-
>  11 files changed, 14 insertions(+), 15 deletions(-)
>=20
Well; personally I would have given it some name; 'QLogic Linux FCoE
offload driver' feels a bit too generic.

But who am I to argue ...

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
