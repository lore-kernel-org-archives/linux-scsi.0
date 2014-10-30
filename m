From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 23/36] atari_scsi: Convert to platform device
Date: Thu, 30 Oct 2014 09:17:10 +0100
Message-ID: <5451F406.7030500@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052612.685449600@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaJ3IRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 04:17:12 -0400
In-Reply-To: <20141027052612.685449600@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Convert atari_scsi to platform device and eliminate scsi_register().
>=20
> Validate __setup options later on so that module options are checked =
as well.
>=20
> Remove the comment about the scsi mid-layer disabling the host irq as=
 it
> is no longer true (AFAICT). Also remove the obsolete slow interrupt s=
tuff
> (IRQ_TYPE_SLOW =3D=3D 0 anyway).
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
