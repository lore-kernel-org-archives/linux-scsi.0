From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [RESEND] [PATCH 00/13] Support for PMC 8081/8088/8089 controllers
Date: Sat, 02 Mar 2013 08:44:29 -0800
Message-ID: <51322C6D.2020900@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37008 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992Ab3CBQnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Mar 2013 11:43:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jack_wang@usish.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com

James/Linux-scsi,

I am resubmitting the patchset for PM8081/88/89 controllers based on your
feedback

>From dbabb6fd90c87a8664361f5bd92a0375aea546e8 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Thu, 28 Feb 2013 16:10:01 +0530
Subject: [RESEND] [PATCH 00/13] Support for PMC 8081/8088/8089 controllers

Resubmission of pm8001 patchset based on James Bottomley comments

1. The patch permission level corrected to 644.
2. Patches 2 3 and 4 of the original patchset have been merged to a 
   single patch (patch 2) to fix compilation error and ensure
   individual functionality.
3. Email id's changed to resolvable ids.

Sakthivel K (13):
  pm80xx: fix for memory region free
  pm80xx: Added SPCv/ve specific ids, variables and modify for SPC
  pm80xx: Multiple inbound/outbound queue configuration
  pm80xx: Updated common functions common for SPC and SPCv/ve
  pm80xx: MSI-X implementation for using 64 interrupts
  pm80xx: Added SPCv/ve specific hardware functionalities
  pm80xx: SPCv/ve specific changes in common files
  pm80xx: SPC new firmware changes for device id 0x8081 alone
  pm80xx: Firmware flash memory free fix, with addition of new memory
    region for it
  pm80xx: Changed module name and debug messages update
  pm80xx: WWN Modification for PM8081/88/89 controllers
  pm80xx: NCQ error handling changes
  pm80xx: thermal, sas controller config and error handling update

 drivers/scsi/pm8001/Makefile      |    7 +-
 drivers/scsi/pm8001/pm8001_ctl.c  |   74 +-
 drivers/scsi/pm8001/pm8001_defs.h |   34 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  796 +++++---
 drivers/scsi/pm8001/pm8001_hwi.h  |    4 +-
 drivers/scsi/pm8001/pm8001_init.c | 1478 +++++++++++++-
 drivers/scsi/pm8001/pm8001_sas.c  |  105 +-
 drivers/scsi/pm8001/pm8001_sas.h  |  176 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 4131 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h  | 1524 ++++++++++++++
 10 files changed, 7937 insertions(+), 392 deletions(-)
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.c
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.h

