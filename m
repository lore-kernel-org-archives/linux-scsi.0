From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Date: Thu, 26 May 2011 07:14:30 -0700
Message-ID: <20110526141430.GD4164@kroah.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
 <20110526021809.GA22496@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "jslaby@suse.cz" <jslaby@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 26, 2011 at 02:00:21AM -0700, Xiangliang Yu wrote:
> 
> >Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt >coalescing to device attributes in sysfs
> >> 
> >> -- Add support for driver version and interrupt coalescing device attributes.
> 
> >When you add a sysfs file, you must also add a Documentation/ABI file as
> >well.  Please do that here.
> 
> These device attributes are sysft class properties for the scsi host,
> and the sysfs files are within scsi host sysfs directory. so, do you
> think I need add a ABI file?  and , I can't find anything about scsi
> host sysfs file under directory Documentation/ABI.

Yes, again, if you add a sysfs file, you need to add documentation
explaining exactly what it is there for and what it does.

And if there isn't already a file for this device, then please add it.

thanks,

greg k-h
