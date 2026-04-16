Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C213E39A071;
	Thu, 16 Apr 2026 16:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776356118; cv=none; b=pBKdHAHAf7gkf2JmWUIU72z/Lj0mMsAdr0Oo6gVhLy4oTVgVSRfXU1bY7nYUTUQJF3kJbHHnQHdt54NVgVnoKoubeYTBLg0wRHh56cH7NAg7vz5cr/71hR/UgyTht9E49TDZvnmTKTm94AEFgl83vrZycnv/6K6goZ45T/9GIAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776356118; c=relaxed/simple;
	bh=gOpuzzmNyZ7Zyzrf3ton4svgIt4GcuvhcUB3qbs0Xzk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TdyPMOLd1c/LpiP9CWjk4Ry1MrVQHQdFdV7aEpKYUMKGawbgJx6KTgqBcHPDuc67Z+oZd6u6ITcUiP8fCmQFnNnC8SzFu/XWzZbfP4sHeOkKTCu/ss1HYjyiLxpaGnM2KcaZol9kdf0RE49Q4p+hIP08uJAqXRwQeBitf0MLKJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=FLYpGpHc; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="FLYpGpHc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1776356116; x=1807892116;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gOpuzzmNyZ7Zyzrf3ton4svgIt4GcuvhcUB3qbs0Xzk=;
  b=FLYpGpHcCJB+FZ/ETaQlSN3jrH/YmRX4VfN+k80g4HgXgBroGli4hnRO
   8RSm8iLiWTxx0xZ71NjDGJHPn1oXYAR44i2P9WU28f0pm7GF1avQ3oViJ
   PnTMh7rPnarUs+pcPP6CaWEmTy3FWbUe6fYEED5AWQuu9OppPviBOlc70
   KDyLIZckQCKgZBCGWgTYT2gau4yzwoqdnnnq+YYABUf1roZ6xA6mLHGtX
   PlZq8+96w30H/xRsbjNqI5le0o50SC0R19WlgmAnvR8cjrYOFzH+xX2tw
   JwfQY4FquwAKWIDGAocqR6YHdkhEqfvhH397P/GVxAKDu2m+bU94AY5tr
   g==;
X-CSE-ConnectionGUID: eOI53zroQ4Gmq0YkhlzsHQ==
X-CSE-MsgGUID: eAeOf/i7RxWis8gcK1moXA==
X-IronPort-AV: E=Sophos;i="6.23,181,1770620400"; 
   d="scan'208";a="223475251"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Apr 2026 09:15:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 16 Apr 2026 09:14:34 -0700
Received: from c34249-workdesk.microsemi.net (10.10.85.11) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Thu, 16 Apr 2026 09:14:33 -0700
From: Sagar Biradar <sagar.biradar@microchip.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley
	<James.Bottomley@HansenPartnership.com>, Jack Wang
	<jinpu.wang@cloud.ionos.com>
CC: linux-scsi <linux-scsi@vger.kernel.org>, <stable@vger.kernel.org>, "Brian
 King" <brking@linux.vnet.ibm.com>, Don Brace <don.brace@microchip.com>, "Raja
 VS" <raja.vs@microchip.com>, Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Abhinav Kuchibhotla <abhinav.kuchibhotla@microchip.com>, Uday kumar Bagam
	<udaykumar.bagam@microchip.com>, Advait Churi <advait.churi@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>
Subject: [PATCH] scsi: pm8001: do not wait for port reset timeout after link down
Date: Thu, 16 Apr 2026 15:54:03 +0000
Message-ID: <20260416155403.416374-1-sagar.biradar@microchip.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Kumar Meiyappan <kumar.meiyappan@microchip.com>

During SATA hot removal with I/O in flight, commands may time out
and enter the abort path. As part of abort handling, the driver
issues a local PHY reset and then waits for the PORT_RESET_TMO
event from firmware.

However, once the link is already down, firmware does not generate
that event. The abort path then waits for a completion that will
never arrive, which can lead to a call trace or stalled recovery
during device removal.

Avoid waiting for port reset completion when the PHY link is
already down.

Signed-off-by: Kumar Meiyappan <kumar.meiyappan@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 36 +++++++++++++++++---------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 645524f3fe2d..5d45c489d7f6 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1148,24 +1148,26 @@ int pm8001_abort_task(struct sas_task *task)
 				phy->reset_completion = NULL;
 			} else {
 				/* 3. Wait for Port Reset complete or
-				 * Port reset TMO
+				 * Port reset TMO, if Phy Link is still up
 				 */
-				pm8001_dbg(pm8001_ha, MSG,
-					   "Waiting for Port reset\n");
-				ret = wait_for_completion_timeout(
-					&completion_reset,
-					PM8001_TASK_TIMEOUT * HZ);
-				if (!ret)
-					phy->reset_completion = NULL;
-				WARN_ON(phy->port_reset_status ==
-						PORT_RESET_TMO);
-				if (phy->port_reset_status == PORT_RESET_TMO) {
-					pm8001_dev_gone_notify(dev);
-					PM8001_CHIP_DISP->hw_event_ack_req(
-						pm8001_ha, 0,
-						0x07, /*HW_EVENT_PHY_DOWN ack*/
-						port_id, phy_id, 0, 0);
-					goto out;
+				if (phy->phy_state != PHY_LINK_DISABLE) {
+					pm8001_dbg(pm8001_ha, MSG,
+						   "Waiting for Port reset\n");
+					ret = wait_for_completion_timeout(
+						&completion_reset,
+						PM8001_TASK_TIMEOUT * HZ);
+					if (!ret)
+						phy->reset_completion = NULL;
+					WARN_ON(phy->port_reset_status ==
+							PORT_RESET_TMO);
+					if (phy->port_reset_status == PORT_RESET_TMO) {
+						pm8001_dev_gone_notify(dev);
+						PM8001_CHIP_DISP->hw_event_ack_req(
+							pm8001_ha, 0,
+							0x07, /*HW_EVENT_PHY_DOWN ack*/
+							port_id, phy_id, 0, 0);
+						goto out;
+					}
 				}
 			}
 
-- 
2.43.0

