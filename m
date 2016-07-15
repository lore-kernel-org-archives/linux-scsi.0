From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/21] lpfc: Re-organize source for easier device-id
 management
Date: Fri, 15 Jul 2016 15:17:18 +0200
Message-ID: <cc6c5fc0-74a6-7cb5-d788-550c26c9fffb@suse.de>
References: <577d5da3.VBEk946TGTT57Ek1%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbcGONRU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:17:20 -0400
In-Reply-To: <577d5da3.VBEk946TGTT57Ek1%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Re-organize source for easier device-id management
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_ids.h  | 122 ++++++++++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/lpfc/lpfc_init.c | 101 +-------------------------------=
--
>  2 files changed, 123 insertions(+), 100 deletions(-)
>  create mode 100644 drivers/scsi/lpfc/lpfc_ids.h
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
