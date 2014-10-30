From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 18/36] mac_scsi: Remove header
Date: Thu, 30 Oct 2014 08:39:43 +0100
Message-ID: <5451EB3F.8050506@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052611.475744930@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052611.475744930@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> The #defines in mac_scsi.h are intended to influence subsequent #incl=
udes in
> mac_scsi.c. IMHO, that's too convoluted.
>=20
> Remove mac_scsi.h by moving those macro definitions to mac_scsi.c,
> consistent with other NCR5380 drivers.
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
