From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/8]: qla4xxx: bug fixes and PCI AER support
Date: Fri, 30 Jul 2010 14:25:18 +0530
Message-ID: <20100730085518.GA12252@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:3416
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751906Ab0G3I6n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 04:58:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, ravi.anand@qlogic.com, michaelc@cs.wisc.edu, nilesh.javali@qlogic.com, lalit.chandivade@qlogic.com

James,

Please apply following list of patches which are generated against
latest scsi-misc-2.6 tree.

Vikas Chaudhary (5)
0001-qla4xxx-set-correct-value-in-sess-recovery_tmo.patch
0002-qla4xxx-Use-the-correct-request-queue.patch
0004-qla4xxx-clear-AF_DPC_SCHEDULED-flage-when-exit-from-.patch
0005-qla4xxx-updated-mbx_sys_info-struct-to-sync-with-FW-.patch
0008-qla4xxx-Update-driver-version-to-5.02.00-k3.patch

Lalit Chandivade (2)
0003-qla4xxx-Stop-firmware-before-doing-init-firmware.patch
0007-qla4xxx-Added-AER-support-for-ISP82xx.patch

Nilesh Javali (1)
0006-qla4xxx-Handle-outstanding-mbx-cmds-on-hung-f-w-scen.patch

drivers/scsi/qla4xxx/ql4_def.h     |   36 ++++-
drivers/scsi/qla4xxx/ql4_fw.h      |   20 ++--
drivers/scsi/qla4xxx/ql4_glbl.h    |    2 +
drivers/scsi/qla4xxx/ql4_init.c    |   14 ++-
drivers/scsi/qla4xxx/ql4_iocb.c    |    2 +-
drivers/scsi/qla4xxx/ql4_isr.c     |    3 +
drivers/scsi/qla4xxx/ql4_mbx.c     |   48 ++++++-
drivers/scsi/qla4xxx/ql4_nx.c      |   14 ++-
drivers/scsi/qla4xxx/ql4_os.c      |  315 +++++++++++++++++++++++++++++++++++-
drivers/scsi/qla4xxx/ql4_version.h |    2 +-

Thanks,
Vikas.
