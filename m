From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sat, 17 May 2003 09:16:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030517091602.B13403@lst.de>
References: <20030516182039.A7369@lst.de> <20030516235718.GA3260@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:61195 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S261265AbTEQHDL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 03:03:11 -0400
Content-Disposition: inline
In-Reply-To: <20030516235718.GA3260@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, May 16, 2003 at 04:57:18PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Fri, May 16, 2003 at 04:57:18PM -0700, Mike Anderson wrote:
> I ran your patch and I dead locked on st_probe.

Hmm, I loaded st fine here, but st_probe is of course never called when
I have no tapes.`

> This is due to the code
> in st_probe and osst_probe that do device registers on the
> sdev_driverfs_dev.bus which is the bus that the probe is being called
> from already. I had an old patch that removed these before due the driver
> model requirement that objects on the device list must be of one type.
> At the time I did not have a place to move these attributes.

Most of the attrributes should just go away - the code looks like
someone played with the driver model because it looked new and shiny..

