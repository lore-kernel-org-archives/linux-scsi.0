From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Mon, 22 Feb 2010 13:07:17 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002221305220.1251-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1002221232160.1251-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41815 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753811Ab0BVSHT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2010 13:07:19 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002221232160.1251-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ramya Desai <ramya.desai@gmail.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

On Mon, 22 Feb 2010, Alan Stern wrote:

> The value can be changed by writing to 
> /sys/block/sdX/device/max_sectors (where X is the drive letter).  Note 
> that this value is in 512-byte blocks, not in KB.  However it is 
> limited to SCSI_DEFAULT_MAX_SECTORS, which is 1024, corresponding to 
> 512 MB.  If larger transfers are needed then 

------^ Typo: this should be 512 KB.

Alan Stern

