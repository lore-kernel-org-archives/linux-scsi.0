From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [announce] scsi_id 0.7 available
Date: Fri, 15 Oct 2004 14:51:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041015215107.GA22227@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:13958 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268488AbUJOVvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 17:51:24 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

Version 0.7 of scsi_id is available at:

http://www-124.ibm.com/storageio/scsi_id/scsi_id-0.7.tar.gz

scsi_id is a program to generate a unique identifier for a given SCSI
device.

It is primarily for use with the udev program key, or hotplug scripts that
want persistent naming of scsi devices. It could also be used for
automatic multi-path configuration or device mapper configuration.

Requires:

- Linux kernel 2.6
- libsysfs 0.4.0

Changes since the last release:
	
	- Fix a bug introduced in version 0.6 so that buffer alignement
	  works on 64 bit systems. Without this fix, it crashes on 64 bit
	  systems.

	- Add $(QUIET) to sync up with the udev Makefile

-- Patrick Mansfield
