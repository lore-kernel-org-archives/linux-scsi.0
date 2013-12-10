From: Viswas G <Viswas.G@pmcs.com>
Subject: [PATCH v2 0/2] pm8001 driver code cleanup
Date: Tue, 10 Dec 2013 10:30:55 +0530
Message-ID: <1386651655-4272-1-git-send-email-Viswas.G@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:59208 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab3LJFGa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 00:06:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

We are resubmitting the following patches in the new patch set

pm80xx : Removing redundant code snippets pm80xx : Fixed return value issue

Please discard the previous patches we submitted for the same.

[PATCH 5/6] pm80xx : Removing redundant code snippets
http://marc.info/?l=linux-scsi&m=138493235925253&w=2

[PATCH 6/6] pm80xx : Fixed return value issue
http://marc.info/?l=linux-scsi&m=138493243028701&w=2

Sorry for the confusion.

This patch set has to be applied after the below patch set submitted by Anand.

http://marc.info/?l=linux-scsi&m=138434875025909&w=2


Viswas G (2):
  pm80xx : Removing redundant code snippets
  pm80xx : Fixed return value issue

 drivers/scsi/pm8001/pm8001_ctl.c |   38 ++++++++++++--------------------------
 drivers/scsi/pm8001/pm8001_hwi.c |   15 +++++----------
 drivers/scsi/pm8001/pm80xx_hwi.c |   15 ++++-----------
 3 files changed, 21 insertions(+), 47 deletions(-)

