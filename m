From: vikas.chaudhary@qlogic.com
Subject: [PATCH 00/11] qla4xxx: Update for scsi-misc
Date: Mon, 13 Feb 2012 18:30:39 +0530
Message-ID: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:39499
	"HELO magana.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1756596Ab2BMNJl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to scsi-misc for inclusion in mainline.

Lalit Chandivade (3):
      qla4xxx: Fix un-necessary delay on invalid DDB
      qla4xxx: Fix verify boot idx correctly
      qla4xxx: Remove un-necessary print statment

Manish Rangankar (1):
      qla4xxx: Modified debug log messages for boot info.

Vikas Chaudhary (7):
      qla4xxx: Remove unused code
      qla4xxx: Proper detection of firmware abort error code for ISP82xx
      scsi_transport_iscsi: added support for host event
      qla4xxx: added support for host event
      iscsi_transport: Added Ping support
      qla4xxx: added ping support
      qla4xxx: Update driver version to 5.02.00-k14

 drivers/scsi/qla4xxx/ql4_def.h      |   41 ++++++-
 drivers/scsi/qla4xxx/ql4_fw.h       |   20 +++
 drivers/scsi/qla4xxx/ql4_glbl.h     |    7 +
 drivers/scsi/qla4xxx/ql4_init.c     |    5 +
 drivers/scsi/qla4xxx/ql4_iocb.c     |   92 ++++++++++++++
 drivers/scsi/qla4xxx/ql4_isr.c      |   78 ++++++++++++
 drivers/scsi/qla4xxx/ql4_mbx.c      |    2 +
 drivers/scsi/qla4xxx/ql4_nx.c       |   17 +---
 drivers/scsi/qla4xxx/ql4_nx.h       |    1 +
 drivers/scsi/qla4xxx/ql4_os.c       |  235 ++++++++++++++++++++++++++++++++---
 drivers/scsi/qla4xxx/ql4_version.h  |    2 +-
 drivers/scsi/scsi_transport_iscsi.c |   90 +++++++++++++
 include/scsi/iscsi_if.h             |   30 +++++
 include/scsi/scsi_transport_iscsi.h |   14 ++

Thanks,
Vikas.
