From: <Viswas.G@pmcs.com>
Subject: [PATCH V2 0/8] pm80xx: Driver updates
Date: Tue, 11 Aug 2015 15:06:24 +0530
Message-ID: <1439285792-12030-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:34933 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933709AbbHKJeZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 05:34:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Wang <jinpu.wang@profitbricks.com>, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, Hannes Reinecke <hare@suse.com>

From: Viswas G <Viswas.G@pmcs.com>

This patch set contains bug fixes for pm80xx driver.
Please consider these patches for next kernel release.

Changes From V1:
Corrected device state changes in I_T_Nexus_Reset.


Viswas G (8):
  pm80xx: Updated link rate
  pm80xx: Corrected device state changes in I_T_Nexus_Reset.
  pm80xx: Update For Thermal Page Code
  pm80xx: Fix for Incorrect DMA Unmapping of SG List
  pm80xx: Remove unnecessary phy disconnect while link error
  pm80xx: Add PORT RECOVERY TIMEOUT support
  pm80xx: Handling Invalid SSP Response frame
  pm80xx: Bump pm80xx driver version to 0.1.38

 drivers/scsi/pm8001/pm8001_defs.h |    1 +
 drivers/scsi/pm8001/pm8001_hwi.c  |    4 +
 drivers/scsi/pm8001/pm8001_sas.c  |   19 +++++--
 drivers/scsi/pm8001/pm8001_sas.h  |   12 +++-
 drivers/scsi/pm8001/pm80xx_hwi.c  |  111 +++++++++++++++++++++++++++----------
 drivers/scsi/pm8001/pm80xx_hwi.h  |    5 +-
 6 files changed, 114 insertions(+), 38 deletions(-)

