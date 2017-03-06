From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/3] hpsa updates
Date: Mon, 6 Mar 2017 15:24:33 -0600
Message-ID: <148883542370.14177.274248778005931414.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0080.outbound.protection.outlook.com ([104.47.38.80]:35804
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753776AbdCFVYi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Mar 2017 16:24:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - add in a new offline volume status
 - limit the number of outstanding rescan operations
 - do not timeout reset operations

---

Don Brace (3):
      hpsa: update check for logical volume status
      hpsa: limit outstanding rescans
      hpsa: do not timeout reset operations


 drivers/scsi/hpsa.c     |   44 +++++++++++++++++++++++++++++---------------
 drivers/scsi/hpsa.h     |    1 +
 drivers/scsi/hpsa_cmd.h |    2 ++
 3 files changed, 32 insertions(+), 15 deletions(-)

--
Signature
