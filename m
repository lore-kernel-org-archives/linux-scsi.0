From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Fri, 02 Sep 2011 12:08:53 +0200
Message-ID: <1314958133.2573.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
	 <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110901160724.GN9189@beardog.cce.hp.com>
	 <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com>
	 <1314903038.3067.27.camel@dabdike>
	 <20110901125938.7cb1da85@jbarnes-desktop>
	 <20110901200349.GO9189@beardog.cce.hp.com>
	 <20110901130930.5caec2d4@jbarnes-desktop>
	 <20110901204419.GY8422@beardog.cce.hp.com>
	 <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com>
	 <1314956388.2573.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1314956388.2573.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: linux-pci-owner@vger.kernel.org
To: Jon Mason <mason@myri.com>
Cc: scameron@beardog.cce.hp.com, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, linux-pci@vger.kernel.org, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

Le vendredi 02 septembre 2011 =C3=A0 11:39 +0200, Eric Dumazet a =C3=A9=
crit :
> Le jeudi 01 septembre 2011 =C3=A0 16:50 -0500, Jon Mason a =C3=A9crit=
 :
>=20
> > I believe modifying the MRRS values is what is causing the issues.
> > Can you try the attached patch and verify that it also resolves the
> > issue?
>=20
> I tested this patch and can confirm this solves the corruption proble=
m.
>=20
> But my disk is _much_ slower than before
>=20
> # hdparm -t /dev/sda1
>=20
> Before :
>=20
>  Timing buffered disk reads: 254 MB in  3.02 seconds =3D  84.16 MB/se=
c
>=20
> After :
>=20
>  Timing buffered disk reads: 120 MB in  3.04 seconds =3D  39.42 MB/se=
c

Hmm, this speed regression is probably old : the 84MB/s was with the
standard debian 6.0.2 kernel (2.6.32-5-amd64)
