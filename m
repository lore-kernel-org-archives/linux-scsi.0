From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 09:21:06 -0800
Message-ID: <20050119172106.GB32702@kroah.com>
References: <20050119171357.GA16136@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:61887 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261811AbVASRzS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 12:55:18 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0JHtIJX005114
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 12:55:18 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0JHtDGu255176
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 12:55:13 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0JHtCNd001704
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 12:55:12 -0500
Content-Disposition: inline
In-Reply-To: <20050119171357.GA16136@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Jan 19, 2005 at 06:13:57PM +0100, Christoph Hellwig wrote:
> I think the hardware_version, firmware_version, rom_version and
> driver_version don't belong into the FC transport class, there's
> nothign specific to FC or even SCSI specific in them.

Then put them in the individual driver (not the driver_version one
though, that belongs as a MODULE_VERSION() paramater).

> If you want these attributes talk to Greg about fiding a place in
> the common driver model code for them.

No, they don't belong there either, sorry :)

thanks,

greg k-h
