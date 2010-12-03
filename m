From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 00/12] qla4xxx: Updates for scsi-misc-2.6
Date: Thu, 2 Dec 2010 22:11:55 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F4116@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3209 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0LCGL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:11:59 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Prasanna Mumbai <prasanna.mumbai@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

James,

Please apply these patches on scsi-misc-2.6 tree.

Karen Higgins (1):
	qla4xxx: use correct fw_ddb_index in abort task

Lalit Chandivade (4):
	qla4xxx: do not process interrupt unconditionally
	qla4xxx: put device in FAILED state for 82XX initialization failure
	qla4xxx: Fail initialization if qla4_8xxx_pci_mem_write_2M fails
	qla4xxx: do not check for fw hung if reset retry is in progress

Prasanna Mumbai (1):
	qla4xxx: cache new IP address acquired via DHCP

Shyam Sundar (1):
	qla4xxx: initialize MSI in correct way

Swapnil Nagle (1):
	qla4xxx: memory wedge with peg_halt test in loop

Vikas Chaudhary (3):
	qla4xxx: Drop use of IRQF_DISABLE
	qla4xxx: do not reset hba if ql4xdontresethba is set
	qla4xxx: Updated the Copyright header
	qla4xxx: Update driver version to 5.02.00-k5

 drivers/scsi/qla4xxx/ql4_dbg.c     |    2 +-
 drivers/scsi/qla4xxx/ql4_dbg.h     |    2 +-
 drivers/scsi/qla4xxx/ql4_def.h     |    5 +--
 drivers/scsi/qla4xxx/ql4_fw.h      |    2 +-
 drivers/scsi/qla4xxx/ql4_glbl.h    |    2 +-
 drivers/scsi/qla4xxx/ql4_init.c    |    2 +-
 drivers/scsi/qla4xxx/ql4_inline.h  |    2 +-
 drivers/scsi/qla4xxx/ql4_iocb.c    |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c     |    9 +++--
 drivers/scsi/qla4xxx/ql4_mbx.c     |   22 ++-----------
 drivers/scsi/qla4xxx/ql4_nvram.c   |    2 +-
 drivers/scsi/qla4xxx/ql4_nvram.h   |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.c      |   62 +++++++++++++++++++++++++++++++----
 drivers/scsi/qla4xxx/ql4_nx.h      |    6 ++--
 drivers/scsi/qla4xxx/ql4_os.c      |   30 ++++++++++++-----
 drivers/scsi/qla4xxx/ql4_version.h |    6 +-
 16 files changed, 100 insertions(+), 56 deletions(-)

Thanks,
Vikas.
