From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/6] qla2xxx: fixes for 2.6.34-rcX
Date: Fri, 19 Mar 2010 16:59:15 -0700
Message-ID: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46289 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751942Ab0CSX7W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 19:59:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Can you please apply these patches. 

Andrew Vasquez (1):
  qla2xxx: Correct vp_idx checking during PORT_UPDATE processing.

Ben Hutchings (1):
  qla2xxx: Disable MSI on qla24xx chips other than QLA2432.

Giridhar Malavali (1):
  qla2xxx: Updated version number to 8.03.02-k2.

Michael Hernandez (1):
  qla2xxx: Check to make sure multique and CPU affinity support is not
    enabled at the same time.

Santosh Vernekar (2):
  qla2xxx: Honour "Extended BB credits" bit for CNAs.
  qla2xxx: Prevent sending mbx commands from sysfs during isp reset.

 drivers/scsi/qla2xxx/qla_attr.c    |    6 ++++-
 drivers/scsi/qla2xxx/qla_fw.h      |   18 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c     |   37 ++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_mbx.c     |    8 ++++++-
 drivers/scsi/qla2xxx/qla_os.c      |    4 ++-
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 6 files changed, 49 insertions(+), 28 deletions(-)

