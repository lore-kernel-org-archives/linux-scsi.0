From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [announce] scsi_id 0.6 available
Date: Tue, 21 Sep 2004 11:45:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921184504.GA7057@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:30084 "EHLO
	palm2") by vger.kernel.org with ESMTP id S267958AbUIUSpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 14:45:23 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

Version 0.6 of scsi_id is available at:

http://www-124.ibm.com/storageio/scsi_id/scsi_id-0.6.tar.gz

scsi_id is a program to generate a unique identifier for a given SCSI
device.

It is primarily for use with the udev program key, or hotplug scripts that
want persistent naming of scsi devices. It could also be used for
automatic multi-path configuration or device mapper configuration.

Requires:

- Linux kernel 2.6
- libsysfs 0.4.0

Major changes since the last release:
	
	- add -u option, patch from Christoph Varoqui, to substitute white
	  space with underscores so it is easier to use the output as a
	  device name.

	- Use 254 bytes for SCSI INQUIRY commands, patch from Hannes
	  Reinecke.

See ChangeLog for more details.

-- Patrick Mansfield
