From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Mon, 19 May 2003 12:02:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030519190227.GA25948@kroah.com>
References: <20030516182039.A7369@lst.de> <3EC5B3B8.9020308@torque.net> <20030517091352.A13403@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:15063 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262728AbTESSsN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 14:48:13 -0400
Content-Disposition: inline
In-Reply-To: <20030517091352.A13403@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Douglas Gilbert <dougg@torque.net>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, May 17, 2003 at 09:13:52AM +0200, Christoph Hellwig wrote:
> On Sat, May 17, 2003 at 01:59:52PM +1000, Douglas Gilbert wrote:
> > It was my understanding that the device model has been
> > recently modified by Greg KH to cope with the dual nature
> > of the interface that sg causes. Evidently similar situations
> > occur elsewhere in the kernel.
> 
> Greg, any comments on this?  I haven't found any code like that
> in drivers/base/ and I can't understand how this is supposed to work..`

I don't really know what you all are talking about here, but...
In talking with Mike Anderson about the driver class code changes, he
and I agreed that sg could just be made a struct class_device.  It could
go under a "scsi" class if you want, and would point to the scsi devices
(in the device tree) that the sg driver is bound to.

Does that make more sense?

thanks,

greg k-h

