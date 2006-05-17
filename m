From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/15]  qla2xxx: updates...
Date: Wed, 17 May 2006 15:06:42 -0700
Message-ID: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:22958 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1751198AbWEQWGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:06:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

For post-2.6.17 consumption...

Highlights include:

  * Removal of firmware-loader modules.
  * Removal of unused RSCN-state handling.
  * General cleanup.

Changeset:

 - Don't wait for loop transition to complete if LOOP_DEAD state is attained.
 - Add support for new flash part.
 - Use FW calculated residual count for underrun handling.
 - Update ISP24xx firwmare loading heuristics.
 - ABBA lock ordering fix.
 - Correct endianess comparisons during ISP24xx NVRAM configuration.
 - Add support for alternate WWN NVRAM setting.
 - Drop unused driver cruft.
 - Remove unused port-type RSCN handling code.
 * Remove obsolete firmware-loader-module support.
 - Use PCI_DEVICE() for pci_device_id definition.
 - Consolidate "qla2xxx" string usage to a #define.
 - Consolidate firmware-dump handling across ISPs.
 - Correct issue where driver improperly issued SNS commands in N2N topologies.
 - Update version number to 8.01.05-k2.

Patch number 10 (of 15) is too large to be sent via email.  Retrieve
the git mailbox patch from:

 * Remove obsolete firmware-loader-module support.
 ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.05k/0010-qla2xxx-Remove-obsolete-firmware-loader-module-support.txt

and apply with git-am.
