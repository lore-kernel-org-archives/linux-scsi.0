From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V5 00/12] Support for PMC 8081/8088/8089 controllers
Date: Mon, 06 May 2013 09:20:28 -0700
Message-ID: <5187D84C.2050901@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57442 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832Ab3EFQSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 12:18:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Sangeetha.Gnanasekaran@pmcs.com, sakthivel.sk@hcl.com, xjtuwjp@gmail.com, Harry.Yang@pmcs.com, Vishwanath.Maram@pmcs.com, rich.Bono@pmcs.com

>From ffe82b1efc42510239046909a7ac0aff10bb4162 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Tue, 19 Mar 2013 18:32:55 +0530
Subject: [PATCH V5 00/12] Support for PMC 8081/8088/8089 controllers

V5

Resubmission of patchset to fix the array out of bounds
error reported by James.

V4

Resubmission of patchset to handle patch apply issue
reported by James.
Fixed dependencies in patch 2 and 6.

V3

Resubmission of patchset addressing Hannes comment
on usage of multiple interrupt handlers for handling
MSI-X.

V2

Resubmission of patchset addressing Hannes comment
on usage of multiple tasklets for handling MSI-X.

1. Patch5 - Implemented a single tasklet to handle all MSI-x
interrupts

V1

Resubmission of pm8001 patchset based on James Bottomley comments

1. The patch permission level corrected to 644.
2. Patches 2 3 and 4 of the original patchset have been merged to a
   single patch (patch 2) to fix compilation error and ensure
   individual functionality.
3. Email id's changed to resolvable ids.

Sakthivel K (12):
  pm80xx: fix for memory region free
  pm80xx: Added SPCv/ve specific ids, variables and modify for SPC
  pm80xx: Multiple inbound/outbound queue configuration
  pm80xx: Updated common functions common for SPC and SPCv/ve
  pm80xx: MSI-X implementation for using 64 interrupts
  pm80xx: Added SPCv/ve specific hardware functionalities and      
    relavent changes in common files
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
 drivers/scsi/pm8001/pm8001_init.c |  384 +++-
 drivers/scsi/pm8001/pm8001_sas.c  |  105 +-
 drivers/scsi/pm8001/pm8001_sas.h  |  177 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 4131 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h  | 1524 ++++++++++++++
 10 files changed, 6845 insertions(+), 391 deletions(-)
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.c
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.h

