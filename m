From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/21] lpfc: Remove global lpfc_sli_mode attribute in leiu
 of per-hba lpfc_sli_mode
Date: Fri, 15 Jul 2016 15:21:44 +0200
Message-ID: <adeec534-6154-9588-9d19-86eba7462ae0@suse.de>
References: <577d5da9.H82rs/17pk56kO0d%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbcGONVq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:21:46 -0400
In-Reply-To: <577d5da9.H82rs/17pk56kO0d%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Remove global lpfc_sli_mode attribute in leiu of per-hba lpfc_sli_mod=
e
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  1 +
>  drivers/scsi/lpfc/lpfc_attr.c | 12 ++++++------
>  drivers/scsi/lpfc/lpfc_crtn.h |  1 -
>  drivers/scsi/lpfc/lpfc_sli.c  | 12 ++++++------
>  4 files changed, 13 insertions(+), 13 deletions(-)
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
