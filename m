From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 0/3]: pm8001 driver bug fixes.
Date: Mon, 11 Nov 2013 08:15:35 -0800
Message-ID: <528102A7.6070100@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:57293 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173Ab3KKQMa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Nov 2013 11:12:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Sangeetha.Gnanasekaran@pmcs.com, Viswas.G@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

>From c3bcd7c02e1fa487edbab4c1d5182daca066db61 Mon Sep 17 00:00:00 2001
From: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Date: Mon, 11 Nov 2013 19:41:51 +0530
Subject: [PATCH 0/3]: pm8001 driver bug fixes.


Nikith Ganigarakoppal (3):
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

