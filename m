From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 00/17] smartpqi updates
Date: Fri, 26 Aug 2016 11:44:05 -0500
Message-ID: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0051.outbound.protection.outlook.com ([104.47.36.51]:37417
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752839AbcHZRB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:01:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

These changes are based on Linus's tree

The changes are:
 - simplify aio processing
 - simplify tmf macro names
 - remove workaround for spanning
 - add message for offlined drives
 - enhance reset logic
 - make some functions in-line
 - add support for kdump
 - correct issue with offlined controller
 - change timeout for events
 - reformat function to match svn version
 - correct update time scheduling
 - minor queuecommand cleanup
 - remove timeout on cache flush operation
 - update smartpqi/Kconfig
   - Martin K. Peterson's review
 - updated MAINTAINERS for smartpqi.txt addition
 - add Documentation/scsi/smartpqi.txt
   - Martin K. Peterson's review
 - bump driver version

---

Kevin Barnett (17):
      smartpqi: change aio sg processing
      smartpqi: change tmf macro names
      smartpqi: simplify spanning
      smartpqi: enhance drive offline informational message
      smartpqi: enhance reset logic
      smartpqi: change commonly used function to inline
      smartpqi: add kdump support
      smartpqi: correct controller offline issue
      smartpqi: correct event acknowledgment timeout issue
      smartpqi: minor function reformating
      smartpqi: minor tweaks to update time support
      smartpqi: scsi queuecommand cleanup
      smartpqi: remove timeout for cache flush operations
      smartpqi: update Kconfig
      smartpqi: update maintainers
      smartpqi: add smartpqi.txt
      smartqi: bump driver version


 Documentation/scsi/smartpqi.txt       |   80 ++++++++
 MAINTAINERS                           |    1 
 drivers/scsi/smartpqi/Kconfig         |    8 +
 drivers/scsi/smartpqi/smartpqi.h      |   35 ++--
 drivers/scsi/smartpqi/smartpqi_init.c |  316 ++++++++++++++++-----------------
 drivers/scsi/smartpqi/smartpqi_sis.c  |   10 +
 drivers/scsi/smartpqi/smartpqi_sis.h  |    2 
 7 files changed, 274 insertions(+), 178 deletions(-)
 create mode 100644 Documentation/scsi/smartpqi.txt

--
Signature
