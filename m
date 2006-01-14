From: andrew.vasquez@qlogic.com
Subject: [PATCH 0/15] qla2xxx: fixes for 2.6.16.
Date: Fri, 13 Jan 2006 17:04:43 -0800
Message-ID: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:7202 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945914AbWANBEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:04:48 -0500
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

James,

Here's a set of bug-fixes for several of the outstanding issues with
the qla2xxx driver.  Please apply.

 drivers/scsi/qla2xxx/Kconfig       |    4 +
 drivers/scsi/qla2xxx/qla_attr.c    |    4 -
 drivers/scsi/qla2xxx/qla_dbg.c     |  105 ++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_dbg.h     |    4 -
 drivers/scsi/qla2xxx/qla_gbl.h     |    6 --
 drivers/scsi/qla2xxx/qla_gs.c      |    8 +-
 drivers/scsi/qla2xxx/qla_init.c    |   24 +++++---
 drivers/scsi/qla2xxx/qla_isr.c     |   14 ++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  107 ++++---------------------------------
 drivers/scsi/qla2xxx/qla_os.c      |    6 ++
 drivers/scsi/qla2xxx/qla_sup.c     |    3 +
 drivers/scsi/qla2xxx/qla_version.h |    4 -
 12 files changed, 114 insertions(+), 175 deletions(-)
 ---

 Reference proper node/port names in fc_host class.
 Correct FC4 feature assignment during RFF_ID.
 Drop noisy 'UNDERRUN' status message.
 Use msleep() as delay during ISP polling.
 Correct excessive delay during LOAD-RISC-RAM mailbox command.
 Re-enable flash-part write protection on ISP24xx boards.
 Update firmware-dump procedure for ISP24xx.
 Correct issue where portstate does not transition during loop-resync.
 Correct swing/emphasis settings for ISP24XX.
 Collapse load RISC RAM implementations.
 Correct execution-throttle setting for ISP24xx.
 Correct setting of FDMI supported/current port speed.
 Kconfig update: Add URL to download firmware images.
 Disable port-type RSCN handling via driver state-machine.
 Update version number to 8.01.04-k.

Regards,
Andrew Vasquez
QLogic Corporation

