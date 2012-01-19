From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/5] qla4xxx: Patches for scsi-misc
Date: Thu, 19 Jan 2012 03:06:52 -0800
Message-ID: <1326971217-14323-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:23399 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2ASLW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2012 06:22:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to scsi-misc for inclusion in mainline.

Vikas Chaudhary (5):
      libiscsi: Added support to show targetalias in sysfs
      qla4xxx: Added support to show targetalias in sysfs
      scsi_transport_iscsi: Added support to show port_state and port_speed in sysfs
      qla4xxx: Added support to show port_state and port_speed in sysfs
      qla4xxx: Update driver version to 5.02.00-k13

 drivers/scsi/libiscsi.c             |    6 +++
 drivers/scsi/qla4xxx/ql4_fw.h       |    4 ++
 drivers/scsi/qla4xxx/ql4_os.c       |   52 ++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_version.h  |    2 +-
 drivers/scsi/scsi_transport_iscsi.c |   63 +++++++++++++++++++++++++++++++++++
 include/scsi/iscsi_if.h             |   17 +++++++++
 include/scsi/libiscsi.h             |    1 +
 include/scsi/scsi_transport_iscsi.h |    4 ++
 8 files changed, 148 insertions(+), 1 deletions(-)

Thanks,
Vikas.

