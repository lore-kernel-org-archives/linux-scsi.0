From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [announce] scsi_id release 0.5
Date: Wed, 23 Jun 2004 13:28:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040623132859.A26994@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:63365 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266652AbUFWU3Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 16:29:16 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

Hi ...

Version 0.5 of scsi_id is available at:

http://www-124.ibm.com/storageio/scsi_id/scsi_id-0.5.tar.gz

scsi_id is a program to generate a unique identifier for a given SCSI
device.

It is primarily for use with the udev program key, or hotplug scripts that
want persistent naming of scsi devices. It could also be used for
automatic multi-path configuration or device mapper configuration.

Version 0.5 requires:

- Linux kernel 2.6
- libsysfs 0.4.0

Major changes since the last release:

	- Ken Brush <ken@cgi101.com> have the command line options
	  override generic options.

	- Fix the gen_scsi_id_udev_rules.sh to handle spaces in the id.

	- Don't supply a makedev() when built with klibc. Also, the
	  scsi_id supplied makedev() was using the old major/minor method.

	- Include compiler.h so we can build against klibc, as recent sg.h
	  changes need a define for __user.

Other changes:

	- Increase the MAX_SERIAL_LEN from 128 to 256, as some (possibly
	  broken devics) are returning very long id's

	- Add spotless target (via Olaf Hering's udev patch)

	- minor wording changes in scsi_id.config

	- Log INQUIRY failure, including the failing page code and vpd
	  values

	- Escape '-' with '\-' in the man page.

-- Patrick Mansfield
