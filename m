From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH V2 0/9] pm80xx updates
Date: Wed, 18 Feb 2015 05:06:41 +0530
Message-ID: <20150217233650.9091-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01hn0200.outbound.protection.outlook.com ([104.47.33.200]:63856
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751148AbdIMKmE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 06:42:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com

This patch set include some bug fixes and enhancement for pm80xx driver.

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
