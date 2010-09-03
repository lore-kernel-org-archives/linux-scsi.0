From: madhu.iyengar@qlogic.com
Subject: [PATCH 0/7] qla2xxx: fixes for 2.6.36-rcX
Date: Fri,  3 Sep 2010 14:56:59 -0700
Message-ID: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42961 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757614Ab0ICWDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:03:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nkmi@yahoo.com

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply these patches.

Arun Easi (2):
  qla2xxx: Fix vport delete issues
  qla2xxx: make rport deletions explicit during vport removal

Giridhar Malavali (2):
  qla2xxx: Correctly set fw hung and complete only waiting mbx.
  qla2xxx: Check for empty slot in request queue before posting Command
    type 6 request.

Lalit Chandivade (2):
  qla2xxx: Reset seconds_since_last_heartbeat correctly.
  qla2xxx: Cover UNDERRUN case where SCSI status is set.

Madhuranath Iyengar (1):
  qla2xxx: Update version number to 8.03.04-k0.

 drivers/scsi/qla2xxx/qla_attr.c    |   23 ++++++---
 drivers/scsi/qla2xxx/qla_dbg.h     |    2 -
 drivers/scsi/qla2xxx/qla_def.h     |   20 ++++++++
 drivers/scsi/qla2xxx/qla_init.c    |   94 +++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_isr.c     |    7 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |    7 ++-
 drivers/scsi/qla2xxx/qla_mid.c     |   68 +++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_nx.c      |   36 ++++++++++----
 drivers/scsi/qla2xxx/qla_os.c      |   30 ++++++++++--
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 10 files changed, 240 insertions(+), 51 deletions(-)

