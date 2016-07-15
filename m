From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/21] lpfc: Add recovery from adapter parity errors on
 some SLI4 adapters
Date: Fri, 15 Jul 2016 15:08:10 +0200
Message-ID: <b448ac73-7ee0-49cb-456f-6312948691cf@suse.de>
References: <577d5d9c.g/OM5R56OszAE5y0%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbcGONIM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:08:12 -0400
In-Reply-To: <577d5d9c.g/OM5R56OszAE5y0%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/06/2016 09:35 PM, James Smart wrote:
>=20
> Add recovery from adapter parity errors on some SLI4 adapters
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |   2 +
>  drivers/scsi/lpfc/lpfc_hw4.h  |  23 ++++++++
>  drivers/scsi/lpfc/lpfc_init.c | 118 +++++++++++++++++++++++++++++++-=
----------
>  drivers/scsi/lpfc/lpfc_sli.c  |  45 ++++++++++++++--
>  drivers/scsi/lpfc/lpfc_sli4.h |   2 +
>  5 files changed, 155 insertions(+), 35 deletions(-)
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
