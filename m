From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2 00/10]: Support for PMC 8074/76/77 controllers.
Date: Wed, 25 Sep 2013 22:23:22 -0700
Message-ID: <5243C4CA.3090308@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:36366 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab3IZFUv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 01:20:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com, Viswas.G@pmcs.com, xjtuwjp@gmail.com

>From ab1b030500a835eacda3d86e5570366099b21311 Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Thu, 19 Sep 2013 12:29:15 +0530
Subject: [PATCH V2 00/10]: Support for PMC 8074/76/77 controllers.


Anand Kumar Santhanam (10):
  pm80xx: Device id changes to support series 8 controllers.
  pm80xx: IButton feature support for motherboard controllers.
  pm80xx: Indirect SMP request fix.
  pm80xx: Display controller BIOS version.
  pm80xx: Phy settings support for motherboard controller.
  pm80xx: Print SAS address of IO failed device.
  pm80xx: Set device state response logic fix.
  pm80xx: Queue rotation logic for inbound and outbound queues.
  pm80xx: 4G boundary fix.
  pm80xx: Firmware logging support.

 drivers/scsi/pm8001/pm8001_ctl.c  |  163 ++++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |    6 +
 drivers/scsi/pm8001/pm8001_defs.h |    8 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  164 ++++++++++++-
 drivers/scsi/pm8001/pm8001_hwi.h  |    3 +
 drivers/scsi/pm8001/pm8001_init.c |   64 +++++-
 drivers/scsi/pm8001/pm8001_sas.c  |    9 +-
 drivers/scsi/pm8001/pm8001_sas.h  |   74 +++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  |  525 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/pm8001/pm80xx_hwi.h  |   15 +-
 10 files changed, 991 insertions(+), 40 deletions(-)

