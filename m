From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH 0/6] pm80xx updates
Date: Fri, 30 Jan 2015 11:36:39 +0530
Message-ID: <20150130060645.23653-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01hn0220.outbound.protection.outlook.com ([104.47.34.220]:16029
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755687AbdHYRL4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 13:11:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com

This patch set include some big fixes and enhancement for pm80xx driver. 

Viswas G (6):
  pm80xx : redefine sas_identify_frame structure
  pm80xx: ILA and inactive firmware version through sysfs
  pm80xx : Different SAS addresses for phys.
  pm80xx : Corrected SATA abort handling.
  pm80xx : panic on ncq error cleaning up the read log
  pm80xx : corrected linkrate value.

 drivers/scsi/pm8001/pm8001_ctl.c  |  55 +++++++++++++++++
 drivers/scsi/pm8001/pm8001_hwi.c  |  11 +++-
 drivers/scsi/pm8001/pm8001_hwi.h  |   2 +-
 drivers/scsi/pm8001/pm8001_init.c |  13 ++--
 drivers/scsi/pm8001/pm8001_sas.c  | 125 ++++++++++++++++++++++++++------------
 drivers/scsi/pm8001/pm8001_sas.h  | 105 ++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.c  |  61 +++++++++++++++----
 drivers/scsi/pm8001/pm80xx_hwi.h  |   6 +-
 8 files changed, 321 insertions(+), 57 deletions(-)

-- 
2.12.3
