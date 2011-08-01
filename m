From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 9/9] isci: add version number
Date: Mon, 1 Aug 2011 19:38:06 +0200
Message-ID: <20110801193806.57dc9b58@stein>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
	<20110730001721.28430.28086.stgit@localhost6.localdomain6>
	<20110730185507.7b68c0a7@stein>
	<CAA9_cmfnSVdohf5bkfXjZvsa+O2vjvVdy2RA=f2EfVYeXdkX+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54245 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1HARiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 13:38:15 -0400
In-Reply-To: <CAA9_cmfnSVdohf5bkfXjZvsa+O2vjvVdy2RA=f2EfVYeXdkX+Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org

On Aug 01 Dan Williams wrote:
> On Sat, Jul 30, 2011 at 9:55 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
> > On Jul 29 Dan Williams wrote:
> >> @@ -540,7 +548,8 @@ static __init int isci_init(void)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 int err;
> >>
> >> - =C2=A0 =C2=A0 pr_info("%s: Intel(R) C600 SAS Controller Driver\n=
", DRV_NAME);
> >> + =C2=A0 =C2=A0 pr_info("%s: Intel(R) C600 SAS Controller Driver -=
 version %s\n",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DRV_NAME, DRV_VERSION)=
;
> >
> > Why? =C2=A0There is already a version number. =C2=A0Like 2.6.39, 3.=
0, 3.1.
>=20
> This is for tracking driver versions across distributions and driver
> update packages as they sync with upstream on different cadences.

If they "synced with upstream", they had just the kernel version number=
=2E
You mean they "backport new drivers from current upstream into their br=
anch
with an old core".

The mainline doesn't generally carry stubs and macros that are only the=
re
for backporting.  Well, I guess SCSI drivers are different in that rega=
rd.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D-=3D=3D =3D--- ----=3D
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
