From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2 00/12] Support for PMC 8081/8088/8089 controllers
Date: Thu, 14 Mar 2013 03:57:51 -0700
Message-ID: <5141AD2F.6010105@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:45418 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065Ab3CNK4l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Mar 2013 06:56:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Harry.Yang@pmcs.com, Vishwanath.Maram@pmcs.com, jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Rich.Bono@pmcs.com, sakthivel.sk@hcl.com

Hi,

This is second resubmission for PM8081/88/89 patchset. This handles
comments from James Bottomley and Hannes.

>From 375653061c0db3189e9e5678b11291b7b0195ac3 Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Wed, 13 Mar 2013 14:09:48 +0530
Subject: [PATCH V2 00/12] Support for PMC 8081/8088/8089 controllers

Patchset V2

Resubmission of patchset addressing Hannes comment

1. Patch5 - Implemented a single tasklet to handle all MSI-x 
interrupts

Patchset V1

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
 drivers/scsi/pm8001/pm8001_init.c |  699 ++++++-
 drivers/scsi/pm8001/pm8001_sas.c  |  105 +-
 drivers/scsi/pm8001/pm8001_sas.h  |  174 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 4131 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h  | 1524 ++++++++++++++
 10 files changed, 7163 insertions(+), 385 deletions(-)
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.c
 create mode 100644 drivers/scsi/pm8001/pm80xx_hwi.h

