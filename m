From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 0/4] qla2xxx: Patches for 3.9-rc.
Date: Sat,  9 Mar 2013 06:04:50 -0500
Message-ID: <1362827094-13912-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:24803 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758254Ab3CIL1F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Mar 2013 06:27:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches for 3.9-rc.

Thanks,
~Saurav
 

Arun Easi (1):
  qla2xxx: Fix crash during firmware dump procedure.

Joe Carnuccio (1):
  Revert "qla2xxx: Add setting of driver version string for vendor
    application."

Saurav Kashyap (2):
  qla2xxx: Update copyright information in LICENSE.qla2xxx file.
  qla2xxx: Update the driver version to 8.04.00.13-k.

 Documentation/scsi/LICENSE.qla2xxx |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |    3 +-
 drivers/scsi/qla2xxx/qla_def.h     |    1 -
 drivers/scsi/qla2xxx/qla_gbl.h     |    3 --
 drivers/scsi/qla2xxx/qla_init.c    |    4 +--
 drivers/scsi/qla2xxx/qla_mbx.c     |   58 ------------------------------------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 7 files changed, 5 insertions(+), 68 deletions(-)

-- 
1.7.7

