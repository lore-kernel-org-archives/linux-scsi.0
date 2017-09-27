From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/3] smartpqi updates
Date: Wed, 27 Sep 2017 16:29:53 -0500
Message-ID: <150654770573.11494.168365142464423047.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0080.outbound.protection.outlook.com ([104.47.34.80]:41777
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751801AbdI0VaA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Sep 2017 17:30:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - update list of controllers
 - cleanup warning message
 - change driver version to 1.1.2-126
---

Don Brace (1):
      smartpqi: update driver version to 1.1.2-126

Kevin Barnett (2):
      smartpqi: update controller ids
      smartpqi: cleanup raid map warning message


 drivers/scsi/smartpqi/smartpqi_init.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--
Signature
