From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 0/5] pm80xx: Support for PMC 8074/76/77 controllers.
Date: Mon, 16 Sep 2013 08:50:35 -0700
Message-ID: <523728CB.10808@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:54202 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237Ab3IPQUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Sep 2013 12:20:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Viswas.G@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com, xjtuwjp@gmail.com

>From f2b2b73a75725d0419a3771c15b323966c018b9e Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Mon, 16 Sep 2013 11:20:29 +0530
Subject: [PATCH 0/5]: Support for PMC 8074/76/77 controllers.


Anand Kumar Santhanam (5):
  pm80xx: Device id changes to support series 8 controllers.
  pm80xx: IButton feature support and Indirect SMP fix.
  pm80xx: Phy settings support for motherboard controller.
  pm80xx: Print SAS address of IO failed device, 4G boundary fix.
  pm80xx: Firmware logging support.

 drivers/scsi/pm8001/pm8001_ctl.c  |  163 ++++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |    6 +
 drivers/scsi/pm8001/pm8001_defs.h |    8 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  164 ++++++++++++-
 drivers/scsi/pm8001/pm8001_hwi.h  |    3 +
 drivers/scsi/pm8001/pm8001_init.c |   68 +++++-
 drivers/scsi/pm8001/pm8001_sas.c  |    9 +-
 drivers/scsi/pm8001/pm8001_sas.h  |   75 ++++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  |  525 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/pm8001/pm80xx_hwi.h  |   15 +-
 10 files changed, 996 insertions(+), 40 deletions(-)

