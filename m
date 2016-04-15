From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] megaraid_sas: task management code optimizations
Date: Fri, 15 Apr 2016 16:13:21 +0200
Message-ID: <5710F701.9060801@suse.de>
References: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
 <1460705013-6482-4-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbcDOONX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 10:13:23 -0400
In-Reply-To: <1460705013-6482-4-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, hch@infradead.org, thenzl@redhat.com
Cc: kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org

On 04/15/2016 09:23 AM, Sumit Saxena wrote:
> This patch will do code optmization for task management functions.
> Below are key changes-
> 1. Remove reset_device hook as it was not being used and driver was s=
etting this to NULL.
> 2. Create wrapper functions for task abort and target reset and insid=
e these functions
>    adapter specific calls be made. e.g. fusion adapters support task =
abort and target reset
>    so task abort and target reset should be issued to fusion adapters=
 only and for MFI adapters,
>    print a message saying feature not supported.
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 67 +++++++++++++++++++++=
----------
>  1 file changed, 46 insertions(+), 21 deletions(-)
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
