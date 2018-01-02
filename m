From: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Subject: RE: [PATCH v3 1/9] ufs: sysfs: device descriptor
Date: Tue, 2 Jan 2018 14:04:39 +0000
Message-ID: <DM2PR0401MB097521254DF50702E81624219A190@DM2PR0401MB0975.namprd04.prod.outlook.com>
References: <1514467754-24499-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514467754-24499-2-git-send-email-stanislav.nijnikov@wdc.com>
 <20171229092327.GB19402@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171229092327.GB19402@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alex Lemberg <Alex.Lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, December 29, 2017 11:23 AM
> To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Alex Lember=
g
> <Alex.Lemberg@wdc.com>
> Subject: Re: [PATCH v3 1/9] ufs: sysfs: device descriptor
>=20
> On Thu, Dec 28, 2017 at 03:29:06PM +0200, Stanislav Nijnikov wrote:
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-sysfs.c
> > @@ -0,0 +1,170 @@
> > +/*
> > +* UFS Device Management sysfs
> > +*
> > +* Copyright (C) 2017 Western Digital Corporation
> > +*
> > +* This program is free software; you can redistribute it and/or
> > +* modify it under the terms of the GNU General Public License version
> > +* 2 as published by the Free Software Foundation.
> > +*
> > +* This program is distributed in the hope that it will be useful, but
> > +* WITHOUT ANY WARRANTY; without even the implied warranty of
> > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU
> > +* General Public License for more details.
>=20
> Please use the SPDX format for all of this, like I asked last time :(
>=20
> thanks,
>=20
> greg k-h
=20
Hi Greg.
Sorry about this.
Is this the proper legal header?

/*
* UFS Device Management sysfs
*
*Copyright (C) 2018 Western Digital Corporation
*This program is free software; you can redistribute it and/or modify it
*under the terms of the GNU General Public License as published by the
*Free Software Foundation; version 2.
*
*This program is distributed in the hope that it will be useful, but=20
*WITHOUT ANY WARRANTY; without even the implied warranty of
*MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
*General Public License for more details.
*
*You should have received a copy of the GNU General Public License along
*with this program; if not, write to the Free Software Foundation, Inc.,
*51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 , USA.
*/

It was taken from <https://spdx.org/licenses/GPL-2.0-only.html#licenseText>

Thanks and Happy New Year!
