From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/9] qla4xxx: Patches for scsi-misc
Date: Thu, 1 Dec 2011 22:42:05 -0800
Message-ID: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:13833
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751776Ab1LBGzv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2011 01:55:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to scsi-misc for inclusion in mainline.
These patches are on top of patchset posted by Mike Christie:-
http://marc.info/?l=linux-scsi&m=132279682021696&w=2

Mike Hernandez (1):
      qla4xxx: Fix CPU lockups when ql4xdontresethba set

Nilesh Javali (1):
      qla4xxx: Fix the IDC locking mechanism

Sarang Radke (2):
      qla4xxx: fix call trace on rmmod with ql4xdontresethba=1
      qla4xxx: Don't recover adapter if device state is FAILED

Shyam Sunder (1):
      qla4xxx: check for FW alive before calling chip_reset

Vikas Chaudhary (4):
      qla4xxx: Perform context resets in case of context failures.
      qla4xxx: Wait for disable_acb before doing set_acb
      qla4xxx: Fix qla4xxx_dump_buffer to dump buffer correctly
      qla4xxx: Update driver version to 5.02.00-k10

 drivers/scsi/qla4xxx/ql4_dbg.c     |    6 +-
 drivers/scsi/qla4xxx/ql4_def.h     |    1 +
 drivers/scsi/qla4xxx/ql4_isr.c     |   30 ++++++---
 drivers/scsi/qla4xxx/ql4_nx.c      |   23 ++++--
 drivers/scsi/qla4xxx/ql4_os.c      |  126 +++++++++++++++++++++++++++++-------
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-

Thanks,
Vikas

