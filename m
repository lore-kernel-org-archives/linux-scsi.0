From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 14:40:16 -0800
Message-ID: <20050119224016.GA5086@kroah.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <20050119213924.GG5508@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:65504 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261953AbVASWoo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 17:44:44 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0JMifRK023035
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 17:44:41 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0JMifGu195692
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 17:44:41 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0JMiekX022289
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 17:44:40 -0500
Content-Disposition: inline
In-Reply-To: <20050119213924.GG5508@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Jan 19, 2005 at 01:39:24PM -0800, Mike Anderson wrote:
> Greg KH [greg@kroah.com] wrote:
> > On Wed, Jan 19, 2005 at 06:13:57PM +0100, Christoph Hellwig wrote:
> > > I think the hardware_version, firmware_version, rom_version and
> > > driver_version don't belong into the FC transport class, there's
> > > nothign specific to FC or even SCSI specific in them.
> > 
> > Then put them in the individual driver (not the driver_version one
> > though, that belongs as a MODULE_VERSION() paramater).
> 
> Are there plans to export MODULE_VERSION info in /sys/module/*/ ? I
> believe the intent was to try and use libsysfs to access these attributes
> / info.

I had a patch to do that around here somewhere, but I think it was
rejected as people can get the same info by using 'modinfo' instead.
You know, the old, "use a userspace tool instead of wasting kernel
memory" argument :)

thanks,

greg k-h
