From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/17] lpfc: Fix the FLOGI discovery logic to comply with
 T11 standards
Date: Thu, 17 Dec 2015 09:10:10 +0100
Message-ID: <56726DE2.4060001@suse.de>
References: <5671efb9.EUONcdfdiSClKLvo%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbbLQIKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:10:12 -0500
In-Reply-To: <5671efb9.EUONcdfdiSClKLvo%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:11 AM, James Smart wrote:
>
> Fix the FLOGI discovery logic to comply with T11 standards
>
> We weren't properly setting fabric parameters, such as R_A_TOV and E_=
D_TOV,
> when we registered the vfi object in default configs and pt2pt config=
s.
> Revise to now pass service params with the values to the firmware and
> ensure they are reset on link bounce. Required reworking the call seq=
uence
> in the discovery threads.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_crtn.h      |   1 +
>   drivers/scsi/lpfc/lpfc_els.c       | 342 +++++++++++++++++---------=
-----------
>   drivers/scsi/lpfc/lpfc_hbadisc.c   |  12 +-
>   drivers/scsi/lpfc/lpfc_nportdisc.c | 124 ++++++++------
>   4 files changed, 240 insertions(+), 239 deletions(-)
>
I hope you know what you're doing ...

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes 'who should be following T-11 more closely' Reinecke
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
