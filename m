From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/8] qla4xxx: Update for scsi-misc
Date: Mon, 27 Feb 2012 03:08:50 -0800
Message-ID: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:53981
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751886Ab2B0LW3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2012 06:22:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to scsi-misc for inclusion in mainline.

Manish Rangankar (1):
      qla4xxx: Add support for multiple session per host.

Mike Christie (2):
      scsi_transport: Export CHAP index as sysfs attribute
      qla4xxx: Export CHAP index as sysfs attribute

Nilesh Javali (2):
      iscsi_transport: Add support to display CHAP list and delete CHAP entry
      qla4xxx: Add support to display CHAP list and delete CHAP entry

Vikas Chaudhary (3):
      qla4xxx: Fix sparse warning
      qla4xxx: trivial cleanup
      qla4xxx: Update driver version to 5.02.00-k15

 drivers/scsi/qla4xxx/ql4_def.h      |    4 +-
 drivers/scsi/qla4xxx/ql4_glbl.h     |    2 +
 drivers/scsi/qla4xxx/ql4_iocb.c     |    4 +-
 drivers/scsi/qla4xxx/ql4_mbx.c      |   21 ++-
 drivers/scsi/qla4xxx/ql4_os.c       |  278 +++++++++++++++++++++++++++++++++--
 drivers/scsi/qla4xxx/ql4_version.h  |    2 +-
 drivers/scsi/scsi_transport_iscsi.c |  109 +++++++++++++-
 include/scsi/iscsi_if.h             |   32 ++++
 include/scsi/scsi_transport_iscsi.h |    4 +


Thanks,
Vikas.

