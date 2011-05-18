From: vikas.chaudhary@qlogic.com
Subject: [PATCH 00/10] qla4xxx: Updates for scsi-misc-2.6
Date: Tue, 17 May 2011 23:17:02 -0700
Message-ID: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50916 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754500Ab1ERGXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply these patches on scsi-misc-2.6 tree.

Harish Zunjarrao (1):
	qla4xxx: Added vendor specific sysfs attributes

Lalit Chandivade (1):
	qla4xxx: Remove AF_DPC_SCHEDULED flag from ha.

Prasanna Mumbai (2):
	qla4xxx: update function qla4xxx_isr_decode_mailbox()
	qla4xxx: Complete the cmd if sense_len is zero

Vikas Chaudhary (6):
	qla4xxx: Updated the reset sequence for ISP82xx
	qla4xxx: Dump HW/FW reg to figure out what caused FW to be hung for ISP82XX
	qla4xxx: Don't process mbx interrupt unconditionally
	qla4xxx: Don't check FW alive if ISP82XX reset is in progress
	qla4xxx: Remove host_lock in queuecommand function
	qla4xxx: Update driver version to 5.02.00-k7

 drivers/scsi/qla4xxx/Makefile      |    2 +-
 drivers/scsi/qla4xxx/ql4_attr.c    |   69 ++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_def.h     |   11 ++++-
 drivers/scsi/qla4xxx/ql4_fw.h      |   23 +++++++++++
 drivers/scsi/qla4xxx/ql4_glbl.h    |    3 +-
 drivers/scsi/qla4xxx/ql4_init.c    |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c     |   22 +++++++---
 drivers/scsi/qla4xxx/ql4_mbx.c     |   77 +++++++++++++++++++++---------------
 drivers/scsi/qla4xxx/ql4_nx.c      |   19 ++++++++-
 drivers/scsi/qla4xxx/ql4_os.c      |   68 ++++++++++++++++---------------
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-

Thanks,
Vikas.
