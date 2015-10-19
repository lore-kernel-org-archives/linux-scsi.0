From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 0/7] bnx2fc: Update to version 2.9.6.
Date: Mon, 19 Oct 2015 15:40:34 -0400
Message-ID: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:48665 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbbJSUTP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 16:19:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com> 

Hi James,

Please add the following patches to the scsi misc branch at your earliest convenience.

Thanks,
Chad

Chad Dupuis (7):
  bnx2fc: Update copyright for 2015.
  bnx2fc: Remove 'NetXtreme II' from source files.
  bnx2fc: Set ELS transfer length correctly for middle path commands.
  bnx2fc: Fix FCP RSP residual parsing.
  bnx2fc: Remove explicit logouts.
  bnx2fc: Add HZ to task management timeout.
  bnx2fc: Update version number to 2.9.6.

 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h  |    6 +-
 drivers/scsi/bnx2fc/Kconfig            |    5 +-
 drivers/scsi/bnx2fc/bnx2fc.h           |   11 ++--
 drivers/scsi/bnx2fc/bnx2fc_constants.h |    6 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.c     |    6 +-
 drivers/scsi/bnx2fc/bnx2fc_debug.h     |    6 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c       |   10 ++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c      |   12 ++--
 drivers/scsi/bnx2fc/bnx2fc_hwi.c       |    6 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c        |  104 +++++++-------------------------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c       |   12 +---
 11 files changed, 59 insertions(+), 125 deletions(-)

-- 
1.7.7

