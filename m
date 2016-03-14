From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/22] ncr5380: Remove REAL_DMA and REAL_DMA_POLL macros
Date: Mon, 14 Mar 2016 08:23:55 +0100
Message-ID: <56E6670B.9010801@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042701.376028915@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463AbcCNHX5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 03:23:57 -0400
In-Reply-To: <20160314042701.376028915@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

On 03/14/2016 05:27 AM, Finn Thain wrote:
> For the NCR5380.c core driver, these macros are never used.
> If REAL_DMA were to be defined, compilation would fail.
>=20
> For the atari_NCR5380.c core driver, REAL_DMA is always defined.
>=20
> Hence these macros are pointless.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c       |  218 +-------------------------------=
-----------
>  drivers/scsi/NCR5380.h       |  112 ----------------------
>  drivers/scsi/atari_NCR5380.c |   62 +-----------
>  drivers/scsi/atari_scsi.c    |   32 ------
>  drivers/scsi/sun3_scsi.c     |   13 --
>  5 files changed, 22 insertions(+), 415 deletions(-)
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
