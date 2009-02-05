From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi dh alua: add intel Multi-Flex device
Date: Thu, 05 Feb 2009 14:56:57 +0100
Message-ID: <498AF029.8070805@suse.de>
References: <12333564114078-git-send-email-michaelc@cs.wisc.edu> <12333564124151-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:39050 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbZBEN47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2009 08:56:59 -0500
In-Reply-To: <12333564124151-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Ilgu Hong <ilgu.hong@promise.com>

Hi Mike,

michaelc@cs.wisc.edu wrote:
> From: Ilgu Hong <ilgu.hong@promise.com>
>=20
> This adds the Intel Multi-Flex device to scsi_dh_alua's
> scsi_dh_devlist, so the module attaches to these devs.
>=20
> Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index 5096b0b..31e1df5 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -691,6 +691,7 @@ static const struct scsi_dh_devlist alua_dev_list=
[] =3D {
>  	{"IBM", "2107900" },
>  	{"IBM", "2145" },
>  	{"Pillar", "Axiom" },
> +	{"Intel", "Multi-Flex"},
>  	{NULL, NULL}
>  };
> =20
Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
