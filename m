From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/21] lpfc: Add MDS Diagnostics Support
Date: Fri, 15 Jul 2016 15:10:54 +0200
Message-ID: <6d7dfe4e-9ceb-8c3d-09d2-de730ee2bb26@suse.de>
References: <577d5da0.TMt6yjHe/yCTv5fJ%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbcGONK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:10:56 -0400
In-Reply-To: <577d5da0.TMt6yjHe/yCTv5fJ%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Add MDS Diagnostics Support
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h      |  4 ++-
>  drivers/scsi/lpfc/lpfc_attr.c | 10 +++++++
>  drivers/scsi/lpfc/lpfc_els.c  |  7 +++++
>  drivers/scsi/lpfc/lpfc_hw4.h  | 14 +++++++++-
>  drivers/scsi/lpfc/lpfc_init.c | 28 +++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_sli.c  | 65 ++++++++++++++++++++++++++++-----=
----------
>  6 files changed, 103 insertions(+), 25 deletions(-)
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
