From: madhu.iyengar@qlogic.com
Subject: [PATCH 00/11] qla2xxx: Updates for scsi-misc-2.6
Date: Tue, 10 May 2011 11:30:05 -0700
Message-ID: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39912 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1750911Ab1EJSgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2011 14:36:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

James,

Please add these patches. Thanks.

Andrew Vasquez (2):
  qla2xxx: Allow an override of the registered maximum LUN.
  qla2xxx: Clear complete initialization control block.

Chad Dupuis (2):
  qla2xxx: Log if qla82xx firmware fails to load from flash.
  qla2xxx: Add qla82xx_rom_unlock() function.

Joe Carnuccio (4):
  qla2xxx: Correct buffer start in edc sysfs debug print.
  qla2xxx: Correctly read sfp single byte mailbox register.
  qla2xxx: Unify the read/write sfp mailbox command routines.
  qla2xxx: Refactor call to qla2xxx_read_sfp for thermal temperature.

Madhuranath Iyengar (1):
  qla2xxx: Use passed in host to initialize local scsi_qla_host in
    queuecommand function

Saurav Kashyap (2):
  qla2xxx: Update firmware version after flash update for ISP82xx.
  qla2xxx: Add host number in reset and quiescent message logs.

 drivers/scsi/qla2xxx/qla_attr.c |   14 ++--
 drivers/scsi/qla2xxx/qla_gbl.h  |   13 ++---
 drivers/scsi/qla2xxx/qla_init.c |    9 +++-
 drivers/scsi/qla2xxx/qla_mbx.c  |  127 +++++++++++----------------------------
 drivers/scsi/qla2xxx/qla_mid.c  |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c   |   34 +++++++----
 drivers/scsi/qla2xxx/qla_os.c   |   10 +++-
 7 files changed, 87 insertions(+), 122 deletions(-)

