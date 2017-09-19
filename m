From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH V3 0/9] pm80xx updates
Date: Tue, 19 Sep 2017 22:39:55 +0530
Message-ID: <20170919171004.10331-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0088.outbound.protection.outlook.com ([104.47.41.88]:35283
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751001AbdISRKe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 13:10:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com

This patch set include some bug fixes and enhancement for pm80xx driver.

Changes from V2:
	- Corrected date.

Changes from V1:
        - sas_identify_frame_local structure moved to pm80xx_hwi.h
        - sata abort handling patch split to four patches.
                - tag allocation for phy control request.
                - cleanup in pm8001_abort_task function.
                - modified port reset timer value for PM8006 card
                - corrected SATA abort handling sequence.


Viswas G (9):
  pm80xx : redefine sas_identify_frame structure
  pm80xx : ILA and inactive firmware version through sysfs
  pm80xx : Different SAS addresses for phys.
  pm80xx : tag allocation for phy control request.
  pm80xx : cleanup in pm8001_abort_task function.
  pm80xx : modified port reset timer value for PM8006 card
  pm80xx : corrected SATA abort handling sequence.
  pm80xx : panic on ncq error cleaning up the read log.
  pm80xx : corrected linkrate value.

 drivers/scsi/pm8001/pm8001_ctl.c  |  54 +++++++++++++++++
 drivers/scsi/pm8001/pm8001_hwi.c  |  11 +++-
 drivers/scsi/pm8001/pm8001_init.c |  13 +++--
 drivers/scsi/pm8001/pm8001_sas.c  | 118 ++++++++++++++++++++++++++------------
 drivers/scsi/pm8001/pm8001_sas.h  |  10 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c  |  61 ++++++++++++++++----
 drivers/scsi/pm8001/pm80xx_hwi.h  | 102 +++++++++++++++++++++++++++++++-
 7 files changed, 313 insertions(+), 56 deletions(-)

-- 
2.12.3
