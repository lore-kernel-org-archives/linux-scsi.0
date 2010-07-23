From: giridhar.malavali@qlogic.com
Subject: [PATCH 00/17] qla2xxx: Updates for scsi-misc-2.6.
Date: Fri, 23 Jul 2010 15:28:21 +0500
Message-ID: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47922 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753435Ab0GWJ66 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:58:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply these patches. 

Andrew Vasquez (3):
  qla2xxx: Correct extended sense-data handling.
  qla2xxx: Stop firmware before doing init firmware.
  qla2xxx: Cleanup some dead-code and make some functions static.

Arun Easi (1):
  qla2xxx: T10 DIF Type 2 support

Chad Dupuis (2):
  qla2xxx: Use GFF_ID to check FCP-SCSI FC4 type before logging into
    Nx_Ports
  qla2xxx: Add qla2x00_free_fcports() function

Duane Grigsby (1):
  qla2xxx: Propogate transport disrupted status for cable pull
    conditions for faster failover.

Giridhar Malavali (4):
  qla2xxx: Removed dependency for SRB structure for Marker processing
  qla2xxx: Updates for ISP82xx.
  qla2xxx: Rearranged and cleaned up the code for processing the
    pending commands.
  qla2xxx: Update copyright banner.

Harish Zunjarrao (2):
  qla2xxx: Add CT passthru support for ISP23xx adapters
  qla2xxx: Do not allow ELS Passthru commands for ISP23xx adapters

Madhuranath Iyengar (4):
  qla2xxx: Don't issue set or get port param MBC if invalid port loop
    id
  qla2xxx: Appropriately log FCP priority data messages
  qla2xxx: Check for golden firmware and show version if available
  qla2xxx: Don't issue set or get port param MBC if remote port is not
    logged in

 drivers/scsi/qla2xxx/qla_attr.c     |   29 +++-
 drivers/scsi/qla2xxx/qla_bsg.c      |   98 ++++++++---
 drivers/scsi/qla2xxx/qla_bsg.h      |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c      |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.h      |    2 +-
 drivers/scsi/qla2xxx/qla_def.h      |   45 ++++--
 drivers/scsi/qla2xxx/qla_dfs.c      |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h       |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |   23 +--
 drivers/scsi/qla2xxx/qla_gs.c       |   74 ++++++++-
 drivers/scsi/qla2xxx/qla_init.c     |  109 +++---------
 drivers/scsi/qla2xxx/qla_inline.h   |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |  253 ++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_isr.c      |  152 ++++++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c      |    6 +-
 drivers/scsi/qla2xxx/qla_mid.c      |   58 +------
 drivers/scsi/qla2xxx/qla_nx.c       |  322 +++++------------------------------
 drivers/scsi/qla2xxx/qla_nx.h       |    5 +-
 drivers/scsi/qla2xxx/qla_os.c       |   67 +++----
 drivers/scsi/qla2xxx/qla_settings.h |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c      |   49 ++++--
 drivers/scsi/qla2xxx/qla_version.h  |    2 +-
 22 files changed, 588 insertions(+), 718 deletions(-)

