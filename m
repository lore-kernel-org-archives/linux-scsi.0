From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/21] lpfc: Fix Transgression Flag of Optical Element
 descriptor for RDP on Linux
Date: Fri, 15 Jul 2016 15:05:25 +0200
Message-ID: <7df313e8-ccf2-eefd-f6fa-0c98a6d35a89@suse.de>
References: <577d5d9a.tm/ZDaxY8ldAXu0i%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbcGONF1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:05:27 -0400
In-Reply-To: <577d5d9a.tm/ZDaxY8ldAXu0i%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/06/2016 09:35 PM, James Smart wrote:
>=20
> Fix Transgression Flag of Optical Element descriptor for RDP on Linux
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  12 +++++
>  drivers/scsi/lpfc/lpfc_els.c  | 101 ++++++++++++++++++++++++++++++++=
+---------
>  drivers/scsi/lpfc/lpfc_hw.h   |   6 +++
>  drivers/scsi/lpfc/lpfc_hw4.h  |   6 +--
>  drivers/scsi/lpfc/lpfc_init.c |   2 +
>  5 files changed, 101 insertions(+), 26 deletions(-)
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
