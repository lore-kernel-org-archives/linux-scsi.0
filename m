From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/7] smartpqi updates
Date: Thu, 10 Aug 2017 13:46:33 -0500
Message-ID: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0055.outbound.protection.outlook.com ([104.47.32.55]:27125
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752953AbdHJSqz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 14:46:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:

 - smartpqi-add-pqi-reset-quiesce-support
   - allow driver to confirm completion of a reset.
 - smartpqi-enhance-bmic-cache-flush
   - can now distinguish between shutdown and power
     management operation.
 - smartpqi-update-pqi-passthru-ioctl
   - update DMA direction
 - smartpqi-cleanup-doorbell-register-usage
   - change how sis mode is re-enabled
 - smartpqi-update-kexec-power-down-support
   - reset controller on shutdown
 - smartpqi-add-in-new-controller-ids
   - update for latest hw
 - smartpqi-change-driver-version-to-1.1.2-125

---

Kevin Barnett (7):
      smartpqi: add pqi reset quiesce support
      smartpqi: enhance BMIC cache flush
      smartpqi: update pqi passthru ioctl
      smartpqi: cleanup doorbell register usage.
      smartpqi: update kexec and power down support
      smartpqi: add in new controller ids
      smartpqi: change driver version to 1.1.2-125


 drivers/scsi/smartpqi/smartpqi.h      |   44 ++++++++++
 drivers/scsi/smartpqi/smartpqi_init.c |  145 ++++++++++++++++++++-------------
 drivers/scsi/smartpqi/smartpqi_sis.c  |  111 ++++++-------------------
 drivers/scsi/smartpqi/smartpqi_sis.h  |    4 -
 4 files changed, 159 insertions(+), 145 deletions(-)

--
Signature
