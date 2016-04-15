From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] megaraid_sas: reduce memory footprints in kdump mode
Date: Fri, 15 Apr 2016 16:11:40 +0200
Message-ID: <5710F69C.5070202@suse.de>
References: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
 <1460705013-6482-2-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbcDOOLo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 10:11:44 -0400
In-Reply-To: <1460705013-6482-2-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, hch@infradead.org, thenzl@redhat.com
Cc: kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org

On 04/15/2016 09:23 AM, Sumit Saxena wrote:
> This patch will reduce memory footprints of megaraid_sas driver when =
booted in kdump mode.
> Driver will not allocate memory for optional and perfromance oriented=
 features.
> Below are key changes done in megaraid_sas driver to do this-
> 1. Limit Controller's queue depth to 100 in kdump mode.
> 2. Do not allocate memory for system info buffer and PD info buffer.
> 3. Disable performance oriented features e.g. Disable RDPQ mode, disa=
ble dual queue depth,
>    restrict to single MSI-x vector.=20
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  2 ++
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 48 +++++++++++++++++--=
----------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  3 ++
>  3 files changed, 34 insertions(+), 19 deletions(-)
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
