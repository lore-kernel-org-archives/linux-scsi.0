From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 10:45:34 -0800
Message-ID: <20050119184534.GC1235@kroah.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <41EEA927.7070602@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:52681 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261838AbVASSpk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 13:45:40 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0JIjdZ7276228
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 13:45:39 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0JIjdjI316712
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 11:45:39 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0JIjcme030703
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 11:45:38 -0700
Content-Disposition: inline
In-Reply-To: <41EEA927.7070602@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Jan 19, 2005 at 12:38:31PM -0600, Brian King wrote:
> Greg KH wrote:
> >On Wed, Jan 19, 2005 at 06:13:57PM +0100, Christoph Hellwig wrote:
> >
> >>I think the hardware_version, firmware_version, rom_version and
> >>driver_version don't belong into the FC transport class, there's
> >>nothign specific to FC or even SCSI specific in them.
> >
> >
> >Then put them in the individual driver (not the driver_version one
> >though, that belongs as a MODULE_VERSION() paramater).
> >
> >
> >>If you want these attributes talk to Greg about fiding a place in
> >>the common driver model code for them.
> >
> >
> >No, they don't belong there either, sorry :)
> 
> How about at an attribute on the pci object?

It is a pci specific attribute?  If so, I'll add it to the pci core.
Otherwise you are free to add it yourself to the pci device in your pci
driver to that location.

thanks,

greg k-h
