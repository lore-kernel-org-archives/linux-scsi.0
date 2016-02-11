From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: Remove redundant code block in
 lpfc_scsi_cmd_iocb_cmpl
Date: Thu, 11 Feb 2016 12:35:01 +0100
Message-ID: <20160211113500.GB27969@c203.arch.suse.de>
References: <1453302520-10499-1-git-send-email-jthumshirn@suse.de>
 <yq1fux0a2m9.fsf@sermon.lab.mkp.net>
 <CAGx+d6cx7CABJpbzOq4ZkifrhXEs-HyNQdezBb6wX6n0N0HrEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGx+d6cx7CABJpbzOq4ZkifrhXEs-HyNQdezBb6wX6n0N0HrEg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 10, 2016 at 01:32:50PM -0500, Dick Kennedy wrote:
> Martin,=A0
> the FCP_RING_POLLING feature is an old driver option that we would li=
ke to
> remove from the driver. It was put in in 2006 as a feature request.
> What we don't know is if any customers still use it? or ever used it.=
=A0
>=20
> The patch looks fine.=A0
> ACK

Dick, is there any chance you could Ack my lockdep assertion patch as w=
ell?
Bart seemed to like it and I think our support people will do as well a=
s it
screams pretty loud when something isn't golden there.

TIA,
	Johannes

>=20
> On Wed, Feb 10, 2016 at 12:37 PM, Martin K. Petersen <
> martin.petersen@oracle.com> wrote:
>=20
>     >>>>> "Johannes" =3D=3D Johannes Thumshirn <jthumshirn@suse.de> w=
rites:
>=20
>     Johannes> This removes a redundant code block that will either be
>     Johannes> executed if the ENABLE_FCP_RING_POLLING flag is set in
>     Johannes> phba->cfg_poll or not. The code is just duplicated in b=
oth
>     Johannes> cases, hence we unify it again.
>=20
>     James and Dick: Ping!
>=20
>     https://patchwork.kernel.org/patch/8072451/
>   =20
>     --
>     Martin K. Petersen=A0 =A0 =A0 Oracle Linux Engineering
>=20
>=20

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
