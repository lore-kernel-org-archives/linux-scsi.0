From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/16]  qla2xxx: update qla2xxx driver to 8.01.00.
Date: Fri, 26 Aug 2005 19:07:50 -0700 (PDT)
Message-ID: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:28007 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1750794AbVH0CHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:07:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

James,

Here's a set of patches which fix a handful of outstanding issues with
the qla2xxx driver.  Please apply.

Summary of patches:

  Use dma_get_required_mask() in determining the 'ideal' DMA mask.
  Export class-of-service (COS) information.
  Correct ISP24xx soft-reset handling.
  Add FDMI support.
  Correct domain/area exclusion logic.
  Simplify redundant target/device reset logic.
  Correct LED scheme definition.
  Remove RISC pause/release barriers during flash manipulation.
  Remove redundant call to pci_unmap_sg().
  Add change_queue_depth/type() API support.
  Add host attributes.
  Generalize WWN to u64 interger conversions.
  Remove bad call to fc_remove_host() during probe failure.
  Stop firmware execution at unintialization time.
  Update version number to 8.01.00-k.
  Replace schedule_timeout().

All patches can be found at the following URL:

        ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.00k/

Regards,
Andrew Vasquez
QLogic Corporation

-- 
Andrew Vasquez
