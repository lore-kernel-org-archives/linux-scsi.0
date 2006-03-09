From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/10]  qla2xxx: updates...
Date: Thu, 9 Mar 2006 14:24:36 -0800
Message-ID: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:12604 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751947AbWCIWYi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:24:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Highlights include:

  * Support for new ISP54XX parts.
  * Updated firmwares for 2GB and 4GB products
    - The firmware loader qla6312 is no longer needed with the new 2GB
      firmware.

    Original module layout:
  	qla2300.ko supports -- ISP2300 and ISP2312 parts.
  	qla2322.ko supports -- ISP2322.
  	qla6312.ko supports -- ISP6312 and ISP6322 parts.

    New module layout:
  	qla2300.ko supports -- ISP2300, ISP2312 and ISP6312 parts.
  	qla2322.ko supports -- ISP2322 and ISP6322 parts.

    Bottom line: one less firmware blob to manage.

Changeset:

 - qla2xxx: Convert IS_QLA*() defines to bit-operations.
 - qla2xxx: Add ISP54xx support.
 - qla2xxx: Consolidate ISP63xx handling.
 - qla2xxx: NVRAM id-list updates.
 - qla2xxx: Correct swing/emphasis settings on ISP24xx.
 - qla2xxx: Add VPD sysfs attribute.
 - qla2xxx: Further restrict ZIO mode support.
 - qla2xxx: Correct FCAL login retry logic for ISP24xx.
 * qla2xxx: Remove legacy ISP6312 firmware loader.
 * qla2xxx: Firmware updates.

The last two patches are too large to be sent via email.  Retrieve
each git mailbox patch from:

 qla2xxx: Remove legacy ISP6312 firmware loader.
 ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.04k/2009-qla2xxx-Remove-legacy-ISP6312-firmware-loader.txt

 qla2xxx: Firmware updates.
 ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.04k/2010-qla2xxx-Firmware-updates.txt

and apply with git-am.
