From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] aic7xxx_old: silence GCC warnings
Date: Tue, 29 Jan 2013 11:05:28 +0100
Message-ID: <1359453928.1345.35.camel@x61.thuisdomein>
References: <1348219723.1581.5.camel@x61.thuisdomein>
	 <1351506978.1339.8.camel@x61.thuisdomein>
	 <1351513026.2480.4.camel@dabdike.sthat4.btopenzone.com>
	 <1351514716.1339.15.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351514716.1339.15.camel@x61.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-10-29 at 13:45 +0100, Paul Bolle wrote:
> On Mon, 2012-10-29 at 12:17 +0000, James Bottomley wrote:
> > mvsas has a maintainer: poke them harder
>=20
> According to MAINTAINERS that's you. Is Xiangliang Yu perhaps the act=
ual
> maintainer?

Building the mvsas driver triggers identical warnings in v3.8-rc5:
    drivers/scsi/mvsas/mv_sas.c: In function =E2=80=98mvs_update_phyinf=
o=E2=80=99:
    drivers/scsi/mvsas/mv_sas.c:1156:34: warning: comparison between =E2=
=80=98enum sas_device_type=E2=80=99 and =E2=80=98enum sas_dev_type=E2=80=
=99 [-Wenum-compare]
    drivers/scsi/mvsas/mv_sas.c:1159:39: warning: comparison between =E2=
=80=98enum sas_device_type=E2=80=99 and =E2=80=98enum sas_dev_type=E2=80=
=99 [-Wenum-compare]

And according to MAINTAINERS you're still the maintainer. So I'd guess
I'm poking the maintainer now.


Paul Bolle
