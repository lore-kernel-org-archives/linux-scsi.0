From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 0/5] qla2xxx: Patches for 3.7-rc.
Date: Wed, 21 Nov 2012 02:39:52 -0500
Message-ID: <1353483597-17206-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:61217 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752947Ab2KUH6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches for 3.7-rc.

Thanks,
~Saurav
 


Armen Baloyan (1):
  qla2xxx: Properly set result field of bsg_job reply structure for
    success and failure.

David Jeffery (1):
  qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.

Giridhar Malavali (1):
  qla2xxx: Change in setting UNLOADING flag and FC vports logout
    sequence while unloading qla2xxx driver.

Saurav Kashyap (1):
  qla2xxx: Update the driver version to 8.04.00.08-k.

Steve Hodgson (1):
  qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()

 drivers/scsi/qla2xxx/qla_attr.c    |    3 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   72 ++++++++++++++----------------------
 drivers/scsi/qla2xxx/qla_os.c      |    7 +--
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 4 files changed, 33 insertions(+), 51 deletions(-)

-- 
1.7.7

