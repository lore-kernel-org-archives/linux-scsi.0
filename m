From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2 0/4]: pm8001 driver bug fixes.
Date: Wed, 13 Nov 2013 05:21:58 -0800
Message-ID: <52837CF6.9030302@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:50309 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683Ab3KMNTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Nov 2013 08:19:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Sangeetha.Gnanasekaran@pmcs.com, Viswas.G@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

>From 9dda7700201be93d4d2b83c2733be3d582859bc7 Mon Sep 17 00:00:00 2001
From: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Date: Wed, 13 Nov 2013 15:38:27 +0530
Subject: [PATCH V2 0/4]: pm8001 driver bug fixes.


Nikith Ganigarakoppal (4):
  pm80xx: Module author updation.
  pm80xx: Fix for direct attached device.
  pm80xx: Resetting the phy state.
  pm80xx: Tasklets synchronization fix.

 drivers/scsi/pm8001/pm8001_hwi.c  |    2 +
 drivers/scsi/pm8001/pm8001_hwi.h  |    4 ++
 drivers/scsi/pm8001/pm8001_init.c |   91 +++++++++++++++++++++---------------
 drivers/scsi/pm8001/pm8001_sas.c  |    4 +-
 drivers/scsi/pm8001/pm8001_sas.h  |    9 +++-
 drivers/scsi/pm8001/pm80xx_hwi.c  |    2 +
 drivers/scsi/pm8001/pm80xx_hwi.h  |    2 +
 7 files changed, 72 insertions(+), 42 deletions(-)

