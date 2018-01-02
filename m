From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/9] ufs: sysfs: device descriptor
Date: Tue, 2 Jan 2018 15:22:33 +0100
Message-ID: <20180102142233.GA2953@kroah.com>
References: <1514467754-24499-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514467754-24499-2-git-send-email-stanislav.nijnikov@wdc.com>
 <20171229092327.GB19402@kroah.com>
 <DM2PR0401MB097521254DF50702E81624219A190@DM2PR0401MB0975.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DM2PR0401MB097521254DF50702E81624219A190@DM2PR0401MB0975.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alex Lemberg <Alex.Lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 02, 2018 at 02:04:39PM +0000, Stanislav Nijnikov wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, December 29, 2017 11:23 AM
> > To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
> > Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Alex Lemberg
> > <Alex.Lemberg@wdc.com>
> > Subject: Re: [PATCH v3 1/9] ufs: sysfs: device descriptor
> > 
> > On Thu, Dec 28, 2017 at 03:29:06PM +0200, Stanislav Nijnikov wrote:
> > > --- /dev/null
> > > +++ b/drivers/scsi/ufs/ufs-sysfs.c
> > > @@ -0,0 +1,170 @@
> > > +/*
> > > +* UFS Device Management sysfs
> > > +*
> > > +* Copyright (C) 2017 Western Digital Corporation
> > > +*
> > > +* This program is free software; you can redistribute it and/or
> > > +* modify it under the terms of the GNU General Public License version
> > > +* 2 as published by the Free Software Foundation.
> > > +*
> > > +* This program is distributed in the hope that it will be useful, but
> > > +* WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > GNU
> > > +* General Public License for more details.
> > 
> > Please use the SPDX format for all of this, like I asked last time :(
> > 
> > thanks,
> > 
> > greg k-h
>  
> Hi Greg.
> Sorry about this.
> Is this the proper legal header?

First off, don't as a developer legal questions, ask your lawyers :)

> 
> /*
> * UFS Device Management sysfs
> *
> *Copyright (C) 2018 Western Digital Corporation
> *This program is free software; you can redistribute it and/or modify it
> *under the terms of the GNU General Public License as published by the
> *Free Software Foundation; version 2.
> *
> *This program is distributed in the hope that it will be useful, but 
> *WITHOUT ANY WARRANTY; without even the implied warranty of
> *MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> *General Public License for more details.
> *
> *You should have received a copy of the GNU General Public License along
> *with this program; if not, write to the Free Software Foundation, Inc.,
> *51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 , USA.
> */
> 
> It was taken from <https://spdx.org/licenses/GPL-2.0-only.html#licenseText>
> 
> Thanks and Happy New Year!

Nope, sorry, see the email thread on lkml from Thomas where he documents
how to properly set the SPDX line and why you don't want any of the
"boiler plate" text in there at all.

thanks,

greg k-h
