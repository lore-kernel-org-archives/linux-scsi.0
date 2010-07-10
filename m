From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 00/10] qla4xxx: Driver fix and ISP82XX support
Date: Sat, 10 Jul 2010 14:46:40 +0530
Message-ID: <20100710091640.GA11191@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:23845
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752059Ab0GJJUV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jul 2010 05:20:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com, karen.higgins@qlogic.com, prasanna.mumbai@qlogic.com

James,

Please apply following list of patches which are generated against
latest scsi-misc-2.6 tree. These are same patches submitted last time
except patch 4 for recovery_tmo. These patches are blessed by Mike.C.

We submitted RFC patch for patch 4 in following mail thread which
addresses Mike.C comments.
http://marc.info/?l=linux-scsi&m=127850859819079&w=2
http://marc.info/?l=linux-scsi&m=127850857819060&w=2

Vikas Chaudhary (7)
0001-qla4xxx-set-driver-ddb-state-correctly-in-process_dd.patch
0002-qla4xxx-unblock-iscsi-session-after-setting-ddb-stat.patch
0003-qla4xxx-correct-return-status-in-function-qla4xxx_fw.patch
0006-qla4xxx-Added-support-for-ISP82XX.patch
0007-qla4xxx-replace-all-dev_info-dev_warn-dev_err-with-q.patch
0009-iscsi_transport-added-new-iscsi_param-to-display-tar.patch
0010-qla4xxx-Update-driver-version-to-5.02.00-k2.patch

Prasanna Mumbai (1)
0004-qla4xxx-Fix-the-freeing-of-the-buffer-allocated-for-.patch

Ravi Anand (1)
0005-qla4xxx-Handle-one-H-W-Interrupt-at-a-time.patch

Karen Higgins (1)
0008-qla4xxx-wait-for-device_ready-before-device-discover.patch

drivers/scsi/qla4xxx/Kconfig        |    8 +-
drivers/scsi/qla4xxx/Makefile       |    2 +-
drivers/scsi/qla4xxx/ql4_def.h      |  143 ++-
drivers/scsi/qla4xxx/ql4_fw.h       |  139 +++-
drivers/scsi/qla4xxx/ql4_glbl.h     |  106 ++-
drivers/scsi/qla4xxx/ql4_init.c     |  239 +++--
drivers/scsi/qla4xxx/ql4_inline.h   |    2 +-
drivers/scsi/qla4xxx/ql4_iocb.c     |   73 +-
drivers/scsi/qla4xxx/ql4_isr.c      |  396 +++++-
drivers/scsi/qla4xxx/ql4_mbx.c      |  190 ++-
drivers/scsi/qla4xxx/ql4_nvram.c    |    2 +-
drivers/scsi/qla4xxx/ql4_nvram.h    |   10 +-
drivers/scsi/qla4xxx/ql4_nx.c       | 2317 +++++++++++++++++++++++++++++++++++
drivers/scsi/qla4xxx/ql4_nx.h       |  779 ++++++++++++
drivers/scsi/qla4xxx/ql4_os.c       |  747 +++++++++---
drivers/scsi/qla4xxx/ql4_version.h  |    2 +-
drivers/scsi/scsi_transport_iscsi.c |    6 +-
include/scsi/iscsi_if.h             |    2 +
18 files changed, 4714 insertions(+), 449 deletions(-)

Thanks,
Vikas.
