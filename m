From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Tue, 9 Aug 2016 10:02:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1608090945350.1919-100000@iolanthe.rowland.org>
References: <yq1k2fqu2ke.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51872 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932681AbcHIOCL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 10:02:11 -0400
In-Reply-To: <yq1k2fqu2ke.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Oliver Neukum <oneukum@suse.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, jejb@linux.vnet.ibm.com

On Mon, 8 Aug 2016, Martin K. Petersen wrote:

> >>>>> "Oliver" == Oliver Neukum <oneukum@suse.com> writes:
> 
> Oliver> Some SATA to USB bridges fail to cooperate with some drives
> Oliver> resulting in no cache being present being reported to the
> Oliver> host. That causes the host to skip sending a command to
> Oliver> synchronize caches. That causes data loss when the drive is
> Oliver> powered down.
> 
> Alan?

Oliver originally submitted this at least a month ago.  I don't see any 
changes since then, so:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

