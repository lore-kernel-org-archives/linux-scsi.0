From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 02/10] ufs: sysfs: device descriptor
Date: Sun, 4 Feb 2018 11:44:42 +0100
Message-ID: <20180204104442.GA7519@kroah.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1517501746-19075-3-git-send-email-stanislav.nijnikov@wdc.com>
 <1517531145.2746.26.camel@wdc.com>
 <20180202071735.GC9314@kroah.com>
 <1517589119.2675.19.camel@wdc.com>
 <DM2PR0401MB0975F2D6C2E2CF3E0A3AB6209AFF0@DM2PR0401MB0975.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbeBDL3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Feb 2018 06:29:06 -0500
Content-Disposition: inline
In-Reply-To: <DM2PR0401MB0975F2D6C2E2CF3E0A3AB6209AFF0@DM2PR0401MB0975.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, Alex Lemberg <Alex.Lemberg@wdc.com>

On Sun, Feb 04, 2018 at 09:03:25AM +0000, Stanislav Nijnikov wrote:
> > -----Original Message-----
> > From: Bart Van Assche
> > Sent: Friday, February 2, 2018 6:32 PM
> > To: gregkh@linuxfoundation.org
> > Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> > jaegeuk@kernel.org; Alex Lemberg <Alex.Lemberg@wdc.com>; Stanislav
> > Nijnikov <Stanislav.Nijnikov@wdc.com>
> > Subject: Re: [PATCH v4 02/10] ufs: sysfs: device descriptor
> > 
> > On Fri, 2018-02-02 at 08:17 +0100, gregkh@linuxfoundation.org wrote:
> > > On Fri, Feb 02, 2018 at 12:25:46AM +0000, Bart Van Assche wrote:
> > > > On Thu, 2018-02-01 at 18:15 +0200, Stanislav Nijnikov wrote:
> > > > > +enum ufs_desc_param_size {
> > > > > +	UFS_PARAM_BYTE_SIZE	= 1,
> > > > > +	UFS_PARAM_WORD_SIZE	= 2,
> > > > > +	UFS_PARAM_DWORD_SIZE	= 4,
> > > > > +	UFS_PARAM_QWORD_SIZE	= 8,
> > > > > +};
> > > >
> > > > Please do not copy bad naming choices from the Windows kernel into
> > > > the Linux kernel. Using names like WORD / DWORD / QWORD is much less
> > > > readable than using the numeric constants 2, 4, 8. Hence my proposal
> > > > to leave out the above enum completely.
> > >
> > > Are you sure those do not come from the spec itself?  It's been a
> > > while since I last read it, but for some reason I remember those types
> > > of names being in there.  But I might be confusing specs here.
> > 
> > Hello Greg,
> > 
> > That's a good question. However, a quick search on the Internet for the
> > search phrase "Universal Flash Storage" "qword" did not yield any results
> > about UFS in the first ten search hits. And I haven't found any references to
> > the DWORD / QWORD terminology in the "UNIVERSAL FLASH STORAGE HOST
> > CONTROLLER INTERFACE (UFSHCI), UNIFIED MEMORY EXTENSION, Version
> > 1.1" document either. Maybe that means that I was looking at the wrong
> > document?
> > 
> > Thanks,
> > 
> > Bart.
> > 
> > 
> The UFS spec 2.1 specifies size as first letter in names of the descriptor parameters and attributes (e.g. bDeviceClass, wSpecVersion, dPSAMaxDataSize, qTotalRawDeviceCapacity, ...). But usage of the enum could be easily removed.

It matches the naming scheme of the spec, so in my opinion, it's fine
as-is.  But as I'm not the author here, it's up to you what you want to
use, you have to maintain this, not me :)

thanks,

greg k-h
