From: Viswas G <Viswas.G@pmcs.com>
Subject: [PATCH 0/2] pm8001 driver code cleanup
Date: Wed, 27 Nov 2013 11:10:46 +0530
Message-ID: <1385530846-4187-1-git-send-email-Viswas.G@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:56432 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab3K0Fp7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Nov 2013 00:45:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

We are resubmitting the following patches in the new patch set

pm80xx : Removing redundant code snippets
pm80xx : Fixed return value issue 

Please discard the previous patches we submitted for the same.

[PATCH 5/6] pm80xx : Removing redundant code snippets
http://marc.info/?l=linux-scsi&m=138493235925253&w=2

[PATCH 6/6] pm80xx : Fixed return value issue
http://marc.info/?l=linux-scsi&m=138493243028701&w=2

Sorry for the confusion.

This patch set has to be applied after the below patch set 
submitted by Anand.

http://marc.info/?l=linux-scsi&m=138434875025909&w=2


Viswas G (2):
  pm80xx : Removing redundant code snippets
  pm80xx : Fixed return value issue.

 drivers/scsi/pm8001/pm8001_ctl.c |   26 ++++++++++----------------
 drivers/scsi/pm8001/pm8001_hwi.c |   15 +++++----------
 2 files changed, 15 insertions(+), 26 deletions(-)

