From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libfc: correct function name in comment
Date: Mon, 12 Oct 2015 14:34:37 +0200
Message-ID: <561BA8DD.6060306@suse.de>
References: <20151011223518.00000bdb@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbbJLMek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 08:34:40 -0400
In-Reply-To: <20151011223518.00000bdb@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

On 10/11/2015 10:35 PM, Sebastian Herbszt wrote:
> Use the correct function name in kernel-doc comment.
>=20
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> Acked-by: Vasu Dev <vasu.dev@intel.com>
> ---
>=20
> diff -U 5 -rp a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_=
npiv.c
> --- a/drivers/scsi/libfc/fc_npiv.c	2014-09-03 19:30:11.760273300 +020=
0
> +++ b/drivers/scsi/libfc/fc_npiv.c	2015-08-05 00:06:17.927753719 +020=
0
> @@ -23,11 +23,11 @@
> =20
>  #include <scsi/libfc.h>
>  #include <linux/export.h>
> =20
>  /**
> - * fc_vport_create() - Create a new NPIV vport instance
> + * libfc_vport_create() - Create a new NPIV vport instance
>   * @vport: fc_vport structure from scsi_transport_fc
>   * @privsize: driver private data size to allocate along with the Sc=
si_Host
>   */
> =20
>  struct fc_lport *libfc_vport_create(struct fc_vport *vport, int priv=
size)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
