From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Mon, 29 Oct 2007 11:45:21 -0500
Message-ID: <1193676321.3383.53.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0710291209250.4882-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38923 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754040AbXJ2QpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 12:45:23 -0400
In-Reply-To: <Pine.LNX.4.44L0.0710291209250.4882-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2007-10-29 at 12:38 -0400, Alan Stern wrote:
> No, that's not what happens.  The genhd's parent is the scsi_device
> and 
> the queue's parent is the genhd.  You can see this immediately from
> the 
> directory layout in sysfs.  Thus:

How has this happened?  The scsi_device doesn't know anything about the
genhd; how can it hold a reference to it?  If you grep the code, you'll
see that only the ULD's (that's sd, sr, st, osst et al) know what a
gendisk is.

James




