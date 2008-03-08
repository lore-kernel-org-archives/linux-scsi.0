From: Andrew Lunn <andrew@lunn.ch>
Subject: Replacement for scsi_static_device_list?
Date: Sat, 8 Mar 2008 15:26:02 +0100
Message-ID: <20080308142602.GA3709@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from londo.lunn.ch ([80.238.139.98]:56249 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbYCHOxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 09:53:03 -0500
Received: from lunn by londo.lunn.ch with local (Exim 3.36 #1 (Debian))
	id 1JXzzu-00010j-00
	for <linux-scsi@vger.kernel.org>; Sat, 08 Mar 2008 15:26:02 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Folks

At the top of drivers/scsi/scsi_devinfo.c there is a comment:

/*
 * scsi_static_device_list: deprecated list of devices that require
 * settings that differ from the default, includes black-listed (broken)
 * devices. The entries here are added to the tail of scsi_dev_info_list
 * via scsi_dev_info_list_init.
 *
 * Do not add to this list, use the command line or proc interface to add
 * to the scsi_dev_info_list. This table will eventually go away.
 */

What is the replacement for this? Is there supposed to be some rc
script which cats a black/white list into the proc interface? I could
not find such a mechanism on my machine.

I have a USB device which needs an entry in this table. Now i could
fix it for my with an personal RC script doing an echo, but that does
not fix everybody else with the same hardware. So what is the generic
solution?

Thanks
    Andrew               
