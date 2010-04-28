From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 00/11] qla4xxx: Driver Fixes & Enablement of ISP82XX!!
Date: Wed, 28 Apr 2010 11:35:40 +0530
Message-ID: <20100428060540.GA11059@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:40612
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753939Ab0D1GUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:20:02 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

James,

Here is the set of updated patches to address the comments from Mike C.
Additionally it enables the support for 10Gb iSCSI ISP82XX adapter.
It was generated against the scsi-misc tree. Please apply.

Here is the list of changes

Ravi Anand (1):
	Adding MAINTAINERS for qla4xxx iSCSI driver.

Randy Dunlap (1):
	qla4xxx: fix ql4_mbx tcp_source_port_num

Vikas Chaudhary (9)
	qla4xxx: Update driver version to 5.02.00-k1
	qla4xxx: Added support for ISP82XX
	qla4xxx: added support for abort task management command
	qla4xxx: correct use of cmd->host_scribble
	qla4xxx: do not retry login to CHAP auth failed targets
	qla4xxx: Updated firmware ready timeout algorithm
	qla4xxx: Code Clean up - remove "marker_needed"
	qla4xxx: set device state as per Link UP and LINK DOWN
	qla4xxx: added IPv6 support.

MAINTAINERS                        |    8 +
drivers/scsi/qla4xxx/Kconfig       |    4 +-
drivers/scsi/qla4xxx/Makefile      |    2 +-
drivers/scsi/qla4xxx/ql4_def.h     |  191 +++-
drivers/scsi/qla4xxx/ql4_fw.h      |  190 +++-
drivers/scsi/qla4xxx/ql4_glbl.h    |  123 ++-
drivers/scsi/qla4xxx/ql4_init.c    |  549 ++++++--
drivers/scsi/qla4xxx/ql4_inline.h  |    2 +-
drivers/scsi/qla4xxx/ql4_iocb.c    |   75 +-
drivers/scsi/qla4xxx/ql4_isr.c     |  409 +++++-
drivers/scsi/qla4xxx/ql4_mbx.c     |  518 ++++++--
drivers/scsi/qla4xxx/ql4_nvram.c   |    2 +-
drivers/scsi/qla4xxx/ql4_nvram.h   |    6 +-
drivers/scsi/qla4xxx/ql4_nx.c      | 2556 ++++++++++++++++++++++++++++++++++++
drivers/scsi/qla4xxx/ql4_nx.h      |  703 ++++++++++
drivers/scsi/qla4xxx/ql4_os.c      |  814 +++++++++---
drivers/scsi/qla4xxx/ql4_version.h |    3 +-

Thanks,
Vikas.

