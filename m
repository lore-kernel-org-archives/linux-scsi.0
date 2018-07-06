From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 1/4] scsi: aacraid: remove AAC_STAT_GOOD define
Date: Fri, 6 Jul 2018 16:55:26 +0000
Message-ID: <a5821f3718a44782a41779fea7e0f6ed@microsemi.com>
References: <20180705110140.19545-1-jthumshirn@suse.de>
 <20180705110140.19545-2-jthumshirn@suse.de>
 <4cd9a8cb64dc4d8aa1e10c3b008c3ba0@microsemi.com>
 <20180706080301.gvjxdd4w5eun2x2h@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706080301.gvjxdd4w5eun2x2h@linux-x5ow.site>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

>=20
> On Thu, Jul 05, 2018 at 05:42:02PM +0000, Dave Carroll wrote:
> > > Remove the AAC_STAT_GOOD definition and open code it in the places
> > > it was used.
> > >
> > > This will make subsequent refactoring in this area easier.
> > >
> > Please don't ... the definition itself was added to make refactoring ea=
sier.
>=20
> Well in the end scsi_cmnd::result as we know it currently will go away, s=
o
> splitting up the define is rather crucial for this. I could do it when ch=
anging the -
> >result from one integer into 4 u8s but doing it in a separate preparatio=
n step
> would be preferable to me and it doesn't hurt accraid at all.
>=20

Thanks for the explanation Johannes, the routine is unwieldy already, and i=
t just=20
didn't feel right adding back all those lines ... Looking forward to the ne=
xt step ...

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
