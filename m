From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 00/15] qla4xxx: Updates for scsi-misc-2.6
Date: Wed, 6 Oct 2010 22:44:41 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406783@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37380 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0JGFoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:44:44 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Poornima Vonti <poornima.vonti@qlogic.com>

James,

Please apply these patches on scsi-misc-2.6 tree.

Karen Higgins (1):
     qla4xxx: dump mailbox registers on System Error

Lalit Chandivade (1):
     qla4xxx: Reset seconds_since_last_heartbeat correctly.

Mike Christie (1):
     qla4xxx: grab hardware_lock in eh_abort before accessing srb

Nilesh Javali (1):
     qla4xxx: Do not wait for the outstanding commands to complete

Shyam Sundar (3):
     qla4xxx: Add support for 8130/8131 AENs.
     qla4xxx: CRB Register for Request Queue in-pointer
     qla4xxx: Clear the rom lock if the firmware died while holding it.

Vikas Chaudhary (9):
     qla4xxx: Trivial cleanup
     qla4xxx: honor return status of qla4xxx_hw_reset
     qla4xxx: remove "ha->retry_reset_ha_cnt" from wait_for_hba_online
     qla4xxx: correct data type of sense_len in qla4xxx_status_cont_entry
     qla4xxx: free_irqs on failed initialize_adapter
     qla4xxx: update AER support for ISP82XX
     qla4xxx: remove unwanted check for bad spd
     qla4xxx: Update driver version to 5.02.00-k4

 drivers/scsi/qla4xxx/ql4_dbg.c     |  101 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_def.h     |   20 +------
 drivers/scsi/qla4xxx/ql4_fw.h      |    3 +
 drivers/scsi/qla4xxx/ql4_glbl.h    |    1 +
 drivers/scsi/qla4xxx/ql4_init.c    |   10 +++-
 drivers/scsi/qla4xxx/ql4_iocb.c    |   10 +---
 drivers/scsi/qla4xxx/ql4_isr.c     |   17 ++++++-
 drivers/scsi/qla4xxx/ql4_mbx.c     |   11 ++++-
 drivers/scsi/qla4xxx/ql4_nx.c      |   89 ++++++++++++++++++--------------
 drivers/scsi/qla4xxx/ql4_nx.h      |    5 +-
 drivers/scsi/qla4xxx/ql4_os.c      |  101 ++++++++++++++++++------------------
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 12 files changed, 245 insertions(+), 125 deletions(-)

Thanks,
Vikas.
