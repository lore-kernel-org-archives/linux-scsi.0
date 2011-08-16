From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 00/12] qla2xxx: Patches for scsi-misc
Date: Tue, 16 Aug 2011 11:31:43 -0700
Message-ID: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26067 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753000Ab1HPSmW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2011 14:42:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to scsi-misc for inclusion in a future mainline release at the earliest convenient opportunity.

Thanks,
Chad

Chad Dupuis (2):
  qla2xxx: Enable write permission to some debug related module
    parameters to be changed dynamically.
  qla2xxx: Fix "active_mask" may be used uninitialized warning.

Giridhar Malavali (2):
  qla2xxx: Add support for ISP82xx to capture dump (minidump) on
    failure.
  qla2xxx: Issue mailbox command only when firmware hung bit is reset
    for ISP82xx.

Joe Carnuccio (3):
  qla2xxx: Correction to sysfs edc interface.
  qla2xxx: Provide method for updating I2C attached VPD.
  qla2xxx: Return sysfs error codes appropriate to conditions.

Saurav Kashyap (5):
  qla2xxx: Implemeted beacon on/off for ISP82XX.
  qla2xxx: Prevent CPU lockups when "ql2xdontresethba" module param is
    set.
  qla2xxx: check for marker IOCB during response queue processing.
  qla2xxx: Fix array out of bound warning.
  qla2xxx: During loopdown perform Diagnostic loopback.

 drivers/scsi/qla2xxx/qla_attr.c |  111 +++--
 drivers/scsi/qla2xxx/qla_bsg.c  |  152 ++++++
 drivers/scsi/qla2xxx/qla_bsg.h  |   42 ++
 drivers/scsi/qla2xxx/qla_dbg.c  |    6 +-
 drivers/scsi/qla2xxx/qla_def.h  |    9 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |   18 +
 drivers/scsi/qla2xxx/qla_init.c |   36 +-
 drivers/scsi/qla2xxx/qla_isr.c  |    5 +
 drivers/scsi/qla2xxx/qla_mbx.c  |  127 +++++
 drivers/scsi/qla2xxx/qla_nx.c   |  971 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_nx.h   |  255 ++++++++++-
 drivers/scsi/qla2xxx/qla_os.c   |   46 ++-
 12 files changed, 1672 insertions(+), 106 deletions(-)


