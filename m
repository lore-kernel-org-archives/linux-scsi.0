From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [0/11]   qla2xxx: summary of changes...
Date: Wed, 8 Dec 2004 23:29:40 -0800
Message-ID: <20041209072940.GA22001@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:16605 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261470AbULIH3q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:29:46 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

James,

Here's a set of patches which fix a handful of outstanding issues with
the qla2xxx driver.  Please apply.

All patches can be found at the following URL:

        ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.02b4k/

Regards,
Andrew Vasquez
QLogic Corporation


ChangeSet@1.2235, 2004-12-08 11:34:56-08:00, andrew.vasquez@qlogic.com
  [PATCH] qla2xxx: remove dead code, add missing statics
  (Christoph Hellwig <hch@lst.de>)

ChangeSet@1.2236, 2004-12-08 13:56:26-08:00, andrew.vasquez@qlogic.com
  Add support for new transmit/receive sensitivity settings when
  updating an ISPs serial-link options.

ChangeSet@1.2237, 2004-12-08 14:24:05-08:00, andrew.vasquez@qlogic.com
  Address several NVRAM access issues:
     o Add support for write-protected NVRAM chips used with
       ISP2322 and ISP6322.
     o Correct code to not perform an erase data during NVRAM
       update.
     o Correct issuance of NVRAM delay after PCI posting call.

ChangeSet@1.2238, 2004-12-08 14:30:11-08:00, andrew.vasquez@qlogic.com
  Resync with latest NVRAM subsystem ID list.

ChangeSet@1.2239, 2004-12-08 14:57:28-08:00, andrew.vasquez@qlogic.com
  Small fixes:
  
     o Issue a big-hammer to recover if the driver is unable
       retrieve the host's loop-id.
     o Correct failure to not add an fc_lun_t object for lun
       0.
     o Interrogate only the relevant bits (peripheral
       qualifier and device-type) of INQUIRY data.
     o Correct issue where driver would incorrectly fail-out
       of initializing an ISP if an device-discovery SNS scan
       failed.
     o Correct issue where the qla2x00_fabric_login() would
       return an incorrect error status during mailbox
       command execution.  

ChangeSet@1.2240, 2004-12-08 15:44:22-08:00, andrew.vasquez@qlogic.com
  Interrupt handler fixes:
  
     o Mark HBA offline in case the firmware cannot recover
       after and ISP system-error.
     o Correct issue where the loop-down-timer was not properly
       being cleared during a port-update event.

ChangeSet@1.2241, 2004-12-08 16:00:35-08:00, andrew.vasquez@qlogic.com
  Misc. driver-code scrubbing:
  
     o Correct qla2300 module description.
     o Resync with latest firmware structure definitions.
     o White-space cleanup.
     o Add additional display of driver internals when debug
       is enabled.

ChangeSet@1.2242, 2004-12-08 16:48:25-08:00, andrew.vasquez@qlogic.com
  Add sysfs queue depth override to qla2xxx.
  
ChangeSet@1.2243, 2004-12-08 21:49:42-08:00, andrew.vasquez@qlogic.com
  Recent ISP6312 FLX firmware can support both ISP6312 and
  ISP6322 chips.  Consolidate ISP6322 handling into the
  ISP6312 firmware loader files.
  
  Remove ql6322.c file.

ChangeSet@1.2244, 2004-12-08 22:00:51-08:00, andrew.vasquez@qlogic.com
  Resync with latest released firmware -- 3.03.08.
  
  Remove ql6322_fw.c file.

ChangeSet@1.2245, 2004-12-08 22:04:04-08:00, andrew.vasquez@qlogic.com
  Update version number to 8.00.02b4-k.
