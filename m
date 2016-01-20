From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 13/17] scsi_transport_iscsi: Add 25G and 40G speed
 definition
Date: Wed, 20 Jan 2016 11:16:13 +0100
Message-ID: <569F5E6D.2010801@suse.de>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1453279261-659-14-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934653AbcATKQQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 05:16:16 -0500
In-Reply-To: <1453279261-659-14-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 01/20/2016 09:40 AM, Jitendra Bhivare wrote:
> iscsi_port_speed and iscsi_port_speed_names have new entries for
> 25Gbps and 40Gbps link speeds.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 2 ++
>  include/scsi/iscsi_if.h             | 2 ++
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_=
transport_iscsi.c
> index e4b3d8f..4414816 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4308,6 +4308,8 @@ static const struct {
>  	{ISCSI_PORT_SPEED_100MBPS,	"100 Mbps" },
>  	{ISCSI_PORT_SPEED_1GBPS,	"1 Gbps" },
>  	{ISCSI_PORT_SPEED_10GBPS,	"10 Gbps" },
> +	{ISCSI_PORT_SPEED_25GBPS,       "25 Gbps" },
> +	{ISCSI_PORT_SPEED_40GBPS,       "40 Gbps" },
>  };
> =20
>  char *iscsi_get_port_speed_name(struct Scsi_Host *shost)
> diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
> index 95ed942..d66c070 100644
> --- a/include/scsi/iscsi_if.h
> +++ b/include/scsi/iscsi_if.h
> @@ -724,6 +724,8 @@ enum iscsi_port_speed {
>  	ISCSI_PORT_SPEED_100MBPS	=3D 0x4,
>  	ISCSI_PORT_SPEED_1GBPS		=3D 0x8,
>  	ISCSI_PORT_SPEED_10GBPS		=3D 0x10,
> +	ISCSI_PORT_SPEED_25GBPS         =3D 0x20,
> +	ISCSI_PORT_SPEED_40GBPS         =3D 0x40,
>  };
> =20
>  /* iSCSI port state */
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
