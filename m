From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/5] qla4xxx: Updates for scsi "misc" branch.
Date: Tue,  7 Aug 2012 07:57:12 -0400
Message-ID: <1344340637-25526-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:49041 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754513Ab2HGMPO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2012 08:15:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest
convenience.

Thanks,
Vikas.

Lalit Chandivade (1):
      qla4xxx: Properly handle SCSI underrun while processing status IOCBs.

Manish Rangankar (2):
      qla4xxx: Fix memory corruption issue in qla4xxx_ep_connect.
      qla4xxx: Fix multiple conn login event issue during session recovery.

Vikas Chaudhary (2):
      qla4xxx: Fix gcc warning for x86 system
      qla4xxx: Update driver version to 5.02.00-k19

 drivers/scsi/qla4xxx/ql4_def.h     |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c     |  102 +++++++++++++++++++++---------------
 drivers/scsi/qla4xxx/ql4_mbx.c     |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.c      |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c      |   20 +++++--
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
