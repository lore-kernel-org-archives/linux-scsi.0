From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/21] lpfc: Add support for XLane LUN priority
Date: Fri, 15 Jul 2016 15:18:44 +0200
Message-ID: <8fa6794c-c4ea-2f3d-c266-c5dfae25b529@suse.de>
References: <577d5da5.ZeUwNJhNxrqTmzvD%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbcGONSq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:18:46 -0400
In-Reply-To: <577d5da5.ZeUwNJhNxrqTmzvD%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Add support for XLane LUN priority
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  1 +
>  drivers/scsi/lpfc/lpfc_attr.c | 89 +++++++++++++++++++++++++++++++++=
++++------
>  drivers/scsi/lpfc/lpfc_crtn.h |  2 +-
>  drivers/scsi/lpfc/lpfc_scsi.c |  9 ++++-
>  drivers/scsi/lpfc/lpfc_scsi.h |  1 +
>  drivers/scsi/lpfc/lpfc_sli.c  | 21 +++++++---
>  drivers/scsi/lpfc/lpfc_sli.h  |  1 +
>  7 files changed, 104 insertions(+), 20 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
