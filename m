From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/5] qla2xxx: fixes for 2.6.33-rc1 [8.03.01-k9]
Date: Tue, 15 Dec 2009 21:29:43 -0800
Message-ID: <1260941388-548-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:57209 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751283AbZLPF3u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 00:29:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply following patches..

The patch 2/5 (qla2xxx: Fix for a multiqueue bug in CPU affinity mode) needs
to be backported to stable kernel.

Andrew Vasquez (1):
  qla2xxx: Extend base EEH support in qla2xxx.

Anirban Chakraborty (1):
  qla2xxx: Fix for a multiqueue bug in CPU affinity mode

Duane Grigsby (1):
  qla2xxx: Added to EEH support.

Giridhar Malavali (1):
  qla2xxx: Update version number to 8.03.01-k9.

Michael Hernandez (1):
  qla2xxx: Get the link data rate explicitly during device resync.

 drivers/scsi/qla2xxx/qla_attr.c    |   32 +++++++++++--
 drivers/scsi/qla2xxx/qla_dbg.h     |    9 +++-
 drivers/scsi/qla2xxx/qla_def.h     |    2 +
 drivers/scsi/qla2xxx/qla_gbl.h     |    1 +
 drivers/scsi/qla2xxx/qla_init.c    |   22 +++++++++
 drivers/scsi/qla2xxx/qla_isr.c     |    9 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |   64 ++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mid.c     |    2 +
 drivers/scsi/qla2xxx/qla_os.c      |   90 ++++++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 10 files changed, 211 insertions(+), 22 deletions(-)

