From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V3 00/10] pm80xx: Support for PMC 8074/76/77 controllers
Date: Mon, 30 Sep 2013 23:33:41 -0700
Message-ID: <524A6CC5.1060907@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:51540 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab3JAGbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2013 02:31:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Viswas.G@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

>From 883408c14e7757557c14f455df8bba934b79c17a Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com> 
Date: Mon, 30 Sep 2013 14:47:05 +0530
Subject: [PATCH V3 00/10] pm80xx: Support for PMC 8074/76/77 controllers.

V3

Resubmission of a patchset addressing review comments from Jack Wang 
and Tomas Henzl.

1. Removed duplicate macros in patch 10.
2. Added description for 4G boundary issue in patch 6.
3. Added extra check for mother board controller in patch 8 and  9.
4. Used SAA_ADDR macro to print sas address of expander SATA drive 
in case of IO failures.

V2

Resubmission of a patchset based on Jack Wang comments.

1. Splited 5 patches into 10 patches based on the functionality.
2. Changed naming convention of 12G macro.

Anand Kumar Santhanam (10):
  pm80xx: Device id changes to support series 8 controllers.
  pm80xx: Indirect SMP request fix.
  pm80xx: Display controller BIOS version.
  pm80xx: Set device state response logic fix.
  pm80xx: Queue rotation logic for inbound and outbound queues.
  pm80xx: 4G boundary fix.
  pm80xx: Print SAS address of IO failed device.
  pm80xx: IButton feature support for motherboard controllers.
  pm80xx: Phy settings support for motherboard controller.
  pm80xx: Firmware logging support.

 drivers/scsi/pm8001/pm8001_ctl.c  |  153 +++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |    6 +
 drivers/scsi/pm8001/pm8001_defs.h |    8 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  152 +++++++++++-
 drivers/scsi/pm8001/pm8001_hwi.h  |    3 +
 drivers/scsi/pm8001/pm8001_init.c |   65 +++++-
 drivers/scsi/pm8001/pm8001_sas.c  |    9 +-
 drivers/scsi/pm8001/pm8001_sas.h  |   74 +++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  |  523 ++++++++++++++++++++++++++++++++++---
 drivers/scsi/pm8001/pm80xx_hwi.h  |   15 +-
 10 files changed, 965 insertions(+), 43 deletions(-)

