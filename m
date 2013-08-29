From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 0/6] SCSI: esas2r: Static check fixes
Date: Thu, 29 Aug 2013 15:55:38 -0400
Message-ID: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:45379 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756227Ab3H2Uny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 16:43:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, dan.carpenter@oracle.com, fengguang.wu@intel.com, Bradley Grove <bgrove@attotech.com>

This series of patches fix errors detected by smatch and coccinelle.

Bradley Grove (6):
  SCSI: esas2r: smatch - Use biwise rather than logical AND for checking
    if any bit set
  SCSI: esas2r: smatch - Fix dereference that occurs prior to check
  SCSI: esas2r: smatch - Fix dereference that occurs prior to check
  SCSI: esas2r: smatch - Fix overrun due to sprintf appending NULL
  SCSI: esas2r: smatch - Remove test for impossible condition (uint8 >
    255)
  SCSI: esas2r: coccinelle - Replace memcpy with struct assignment

 drivers/scsi/esas2r/esas2r_flash.c | 11 ++++++++---
 drivers/scsi/esas2r/esas2r_init.c  |  5 +++--
 drivers/scsi/esas2r/esas2r_ioctl.c |  2 +-
 drivers/scsi/esas2r/esas2r_vda.c   |  7 +++++--
 4 files changed, 17 insertions(+), 8 deletions(-)

-- 
1.8.1.4

