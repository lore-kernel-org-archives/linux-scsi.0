From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Mon, 7 Feb 2005 12:29:55 -0600
Message-ID: <20050207182955.GC16526@lists.us.dell.com>
References: <20050207182753.GA16526@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from lists.us.dell.com ([143.166.224.162]:10668 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261225AbVBGS35
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 13:29:57 -0500
Content-Disposition: inline
In-Reply-To: <20050207182753.GA16526@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Mon, Feb 07, 2005 at 12:27:53PM -0600, Matt Domsch wrote:
> In addition, two more infrastructure pieces are necessary:
> udev-050-scsi_topology.patch - adds the subsystem name "scsi_topology"
> to the list of devices *not* to wait for the creation of files in
> sysfs for - scsi_topology devices aren't to be registered in sysfs.

Patch follows.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--- udev-050/udev_sysfs.c.~1~	2004-12-17 23:53:07.000000000 -0600
+++ udev-050/udev_sysfs.c	2005-02-07 10:58:45.000000000 -0600
@@ -56,6 +56,7 @@
 	{ .subsystem = "fc_host",	.file = "port_id" },
 	{ .subsystem = "spi_transport",	.file = "width" },
 	{ .subsystem = "spi_host",	.file = "width" },
+	{ .subsystem = "scsi_topology",	.file = NULL },
 	{ NULL, NULL }
 };
 
