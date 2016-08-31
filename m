From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 00/15] smartpqi update
Date: Wed, 31 Aug 2016 14:54:05 -0500
Message-ID: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0044.outbound.protection.outlook.com ([104.47.33.44]:57321
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752273AbcHaTyL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 15:54:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

These changes are based on Linus's tree

The changes are:
 - simplify aio processing
 - simplify tmf macro names
 - remove workaround for spanning
 - add message for offlined drives
 - enhance reset logic
 - add support for kdump
 - correct issue with offlined controller
 - change timeout for events
 - reformat function to match svn version
 - correct update time scheduling
 - minor queuecommand cleanup
 - remove timeout on cache flush operation
 - update smartpqi/Kconfig
   - Martin K. Peterson's review
 - add Documentation/scsi/smartpqi.txt
   - Martin K. Peterson's review
 - bump driver version

Changes since V1:
 - squashed smartpqi-add-smartpqi.txt and
   smartpqi-update-maintainers
   as per Johannes Thumshirn <jthumshirn@suse.de> review.
 - enhanced patch description for
   smartpqi-correct-controller-offline-issue
   as per Johannes Thumshirn <jthumshirn@suse.de> review.
 - redacted patch smartpqi-change-function-to-inline
   as per Johannes Thumshirn <jthumshirn@suse.de> review.
   - The compiler in-lines small functions automatically.

---

Don Brace (1):
      smartpqi: add smartpqi.txt

Kevin Barnett (14):
      smartpqi: change aio sg processing
      smartpqi: change tmf macro names
      smartpqi: simplify spanning
      smartpqi: enhance drive offline informational message
      smartpqi: enhance reset logic
      smartpqi: add kdump support
      smartpqi: correct controller offline issue
      smartpqi: correct event acknowledgment timeout issue
      smartpqi: minor function reformating
      smartpqi: minor tweaks to update time support
      smartpqi: scsi queuecommand cleanup
      smartpqi: remove timeout for cache flush operations
      smartpqi: update Kconfig
      smartqi: bump driver version


 Documentation/scsi/smartpqi.txt       |   80 ++++++++
 MAINTAINERS                           |    1 
 drivers/scsi/smartpqi/Kconfig         |    8 +
 drivers/scsi/smartpqi/smartpqi.h      |   35 ++--
 drivers/scsi/smartpqi/smartpqi_init.c |  314 ++++++++++++++++-----------------
 drivers/scsi/smartpqi/smartpqi_sis.c  |   10 +
 drivers/scsi/smartpqi/smartpqi_sis.h  |    2 
 7 files changed, 273 insertions(+), 177 deletions(-)
 create mode 100644 Documentation/scsi/smartpqi.txt

--
Signature
