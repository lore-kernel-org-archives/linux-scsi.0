From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/29] ncr5380: Fix compiler warnings and __setup options
Date: Mon, 06 Oct 2014 11:19:55 +0200
Message-ID: <54325EBB.60602@suse.de>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065628.986182766@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065628.986182766@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/02/2014 08:56 AM, Finn Thain wrote:
> Some __setup() options mentioned in Documentation/scsi don't work bec=
ause
> a few lines of code went missing sometime since Linux 2.4. Fix the op=
tions
> and thus fix some compiler warnings for both the non-modular case,
>=20
>     CC      drivers/scsi/dtc.o
> drivers/scsi/dtc.c:176:20: warning: 'dtc_setup' defined but not used =
[-Wunused-function]
>=20
> and the modular case,
>=20
>     CC [M]  drivers/scsi/pas16.o
> drivers/scsi/pas16.c:335:20: warning: 'pas16_setup' defined but not u=
sed [-Wunused-function]
>     CC [M]  drivers/scsi/t128.o
> drivers/scsi/t128.c:147:20: warning: 't128_setup' defined but not use=
d [-Wunused-function]
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
