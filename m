From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 00/13] qla4xxx: Updates for scsi-misc-2.6
Date: Sun, 13 Mar 2011 22:23:29 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B1506@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:1463 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752207Ab1CNFXr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:23:47 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Prasanna Mumbai <prasanna.mumbai@qlogic.com>, Sarang Radke <sarang.radke@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

James,

Please apply these patches on scsi-misc-2.6 tree.

Karen Higgins (2):
      qla4xxx: cleanup DDB relogin logic during initialization
      qla4xxx: Prevent other port reinitialization during remove_adapter

Prasanna Mumbai (3):
      qla4xxx: Do not send mbox command if FW is in failed state
      qla4xxx: Do not retry ISP82XX initialization if H/W state is failed
      qla4xxx: masking required bits of add_fw_options during initialization

Sarang Radke (1):
      qla4xxx: Use polling mode for disable interrupt mailbox completion

Vikas Chaudhary (7):
      qla4xxx: cleanup qla4xxx_initialize_ddb_list()
      qla4xxx: remove unused ddb flag DF_NO_RELOGIN
      qla4xxx: cleanup function qla4xxx_process_ddb_changed
      qla4xxx: Add support for ql4xmaxqdepth command line parameter
      qla4xxx: add support for ql4xsess_recovery_tmo cmd line param
      qla4xxx: added new function qla4xxx_relogin_all_devices
      qla4xxx: Update driver version to 5.02.00-k6

 drivers/scsi/qla4xxx/ql4_def.h     |   10 +--
 drivers/scsi/qla4xxx/ql4_fw.h      |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h    |    1 -
 drivers/scsi/qla4xxx/ql4_init.c    |  207 ++++++------------------------------
 drivers/scsi/qla4xxx/ql4_isr.c     |   31 +-----
 drivers/scsi/qla4xxx/ql4_mbx.c     |   34 ++++--
 drivers/scsi/qla4xxx/ql4_nx.c      |    3 +-
 drivers/scsi/qla4xxx/ql4_os.c      |  155 ++++++++++++++++++---------
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 9 files changed, 170 insertions(+), 274 deletions(-)

Thanks,
Vikas.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

