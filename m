From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] add sysfs attributes to scan and delete scsi_devices
Date: Tue, 8 Jul 2003 15:36:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708153646.B373@beaverton.ibm.com>
References: <20030708134016.A32161@beaverton.ibm.com> <20030708214727.A13551@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:18876 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S267828AbTGHWWg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2003 18:22:36 -0400
Content-Disposition: inline
In-Reply-To: <20030708214727.A13551@infradead.org>; from hch@infradead.org on Tue, Jul 08, 2003 at 09:47:27PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Tue, Jul 08, 2003 at 09:47:27PM +0100, Christoph Hellwig wrote:

> Looks good so far but please keep the string parsing in scsi_sysfs.c
> instead of scsi_scan.c.  Also doesn't want this some code sharing with
> the old procfs code?

I can change procfs to use scsi_scan_host_selected(), it will be externed
for use in scsi_sysfs.c.

But is it worth propagating through the call chain whether a new device
was found (i.e. scsi_add_device returns -ENODEV)?

-- Patrick Mansfield
