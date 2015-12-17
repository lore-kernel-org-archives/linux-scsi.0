From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/17] lpfc: Modularize and cleanup FDMI code in driver
Date: Thu, 17 Dec 2015 09:24:12 +0100
Message-ID: <5672712C.6060206@suse.de>
References: <5671efbe.5Ald5TmUcgApALK6%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbbLQIYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:24:14 -0500
In-Reply-To: <5671efbe.5Ald5TmUcgApALK6%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:11 AM, James Smart wrote:
>
> Modularize, cleanup, add comments - for FDMI code in driver
>
> Note: I don't like the comments with leading # - but as we have a lot=
 if
> present, I'm deferring to handle it in one big fix later.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc.h         |   16 +-
>   drivers/scsi/lpfc/lpfc_attr.c    |   46 +-
>   drivers/scsi/lpfc/lpfc_crtn.h    |    5 +-
>   drivers/scsi/lpfc/lpfc_ct.c      | 1794 ++++++++++++++++++++++++---=
-----------
>   drivers/scsi/lpfc/lpfc_els.c     |   99 ++-
>   drivers/scsi/lpfc/lpfc_hbadisc.c |   16 +-
>   drivers/scsi/lpfc/lpfc_hw.h      |  184 +++-
>   drivers/scsi/lpfc/lpfc_init.c    |   27 +-
>   drivers/scsi/lpfc/lpfc_vport.c   |    8 +
>   9 files changed, 1450 insertions(+), 745 deletions(-)
>

I would have loved to have all the attribute functions abstracted=20
away by using a generic one, but still a good improvement over the=20
existing code.

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
