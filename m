From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/15] qla4xxx: bug_fix, ISP82xx support, BSG support
Date: Fri, 11 Jun 2010 13:12:36 +0530
Message-ID: <20100611074236.GA27658@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:33403
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752868Ab0FKHop (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 03:44:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com

James,

Please apply following list of patches which has been generated
against latest scsi-misc-2.6 tree
	- qla4xx bug fix
	- Support for ISP82XX hardware and
	- BSG support.

This patch set addresses comments outlined in following thread from Mike.C:

http://marc.info/?l=linux-scsi&m=127502766602947&w=2

Vikas Chaudhary (13)
0001-qla4xxx-set-driver-ddb-state-correctly-in-process_dd.patch
0002-qla4xxx-unblock-iscsi-session-after-setting-ddb-stat.patch
0003-qla4xxx-correct-return-status-in-function-qla4xxx_fw.patch
0004-qla4xxx-set-correct-value-in-sess-recovery_tmo.patch
0007-qla4xxx-Added-support-for-ISP82XX.patch
0008-qla4xxx-replace-all-dev_info-dev_warn-dev_err-with-q.patch
0009-qla4xxx-wait-for-device_ready-before-device-discover.patch
0010-iscsi_transport-added-new-iscsi_param-to-display-tar.patch
0011-iscsi_transport-Added-new-iscsi_host_param-for-iSCSI.patch
0012-qla4xxx-added-host-attributes-to-export-host-informa.patch
0013-qla4xxx-Added-bsg-support.patch
0014-iscsi_transport-ping-support-via-BSG.patch
0015-qla4xxx-ping-support-via-BSG-interface.patch

Ravi Anand (1)
0006-qla4xxx-Handle-one-H-W-Interrupt-at-a-time.patch

Prasanna Mumbai (1)
0005-qla4xxx-Fix-the-freeing-of-the-buffer-allocated-for-.patch


drivers/scsi/qla4xxx/Kconfig        |    8 +-
drivers/scsi/qla4xxx/Makefile       |    2 +-
drivers/scsi/qla4xxx/ql4_attr.c     |  166 +++
drivers/scsi/qla4xxx/ql4_def.h      |  192 +++-
drivers/scsi/qla4xxx/ql4_fw.h       |  139 +++-
drivers/scsi/qla4xxx/ql4_glbl.h     |  129 ++-
drivers/scsi/qla4xxx/ql4_init.c     |  250 +++--
drivers/scsi/qla4xxx/ql4_inline.h   |    2 +-
drivers/scsi/qla4xxx/ql4_iocb.c     |   73 +-
drivers/scsi/qla4xxx/ql4_isr.c      |  396 +++++-
drivers/scsi/qla4xxx/ql4_mbx.c      |  570 ++++++++-
drivers/scsi/qla4xxx/ql4_nvram.c    |    2 +-
drivers/scsi/qla4xxx/ql4_nvram.h    |   10 +-
drivers/scsi/qla4xxx/ql4_nx.c       | 2322 +++++++++++++++++++++++++++++++++++
drivers/scsi/qla4xxx/ql4_nx.h       |  779 ++++++++++++
drivers/scsi/qla4xxx/ql4_os.c       |  998 ++++++++++++---
drivers/scsi/scsi_transport_iscsi.c |  471 +++++++-
include/scsi/Kbuild                 |    1 +
include/scsi/iscsi_if.h             |   10 +
include/scsi/scsi_bsg_iscsi.h       |  259 ++++
include/scsi/scsi_transport_iscsi.h |   47 +


Thanks,
Vikas.
