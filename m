From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 33/36] atari_NCR5380: Introduce FLAG_TAGGED_QUEUING
Date: Thu, 30 Oct 2014 09:39:01 +0100
Message-ID: <5451F925.2040101@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052615.105777702@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052615.105777702@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> The static variable setup_use_tagged_queuing is declared in mac_scsi.=
c,
> sun3_scsi.c and atari_scsi.c and doesn't belong in the core driver.
> None of the other NCR5380 drivers suffer from this layering issue whi=
ch
> makes merging the core drivers more difficult and will likely hinder =
plans
> for future use of platform data to configure the driver.
>=20
> Replace the static variable with a host flag. This way it can be repo=
rted
> along with the other flags.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
