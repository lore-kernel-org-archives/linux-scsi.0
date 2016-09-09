From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/5] hpsa updates
Date: Fri, 9 Sep 2016 16:30:11 -0500
Message-ID: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0042.outbound.protection.outlook.com ([104.47.32.42]:51376
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754958AbcIIWDt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Sep 2016 18:03:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

The following changes are based on Linus's tree:
 - correct minor bug created when adding hpsa_skip_device
 - add check for null devices do to configuration changes
 - add check for null devices in ioaccel path
 - add check for vpd support
 - stop sending bmic commands to externals

---

Don Brace (3):
      hpsa: determine device external status earlier
      hpsa: check for null device pointers
      hpsa: check for null devices in ioaccel submission patch

Scott Teel (2):
      hpsa: check for vpd support before sending
      hpsa: prevent sending bmic commands to externals


 drivers/scsi/hpsa.c     |  117 +++++++++++++++++++++++++++++++++++++++--------
 drivers/scsi/hpsa_cmd.h |    1 
 2 files changed, 99 insertions(+), 19 deletions(-)

--
Signature
