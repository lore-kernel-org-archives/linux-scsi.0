From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/4] hpsa updates
Date: Wed, 26 Oct 2016 17:21:40 -0500
Message-ID: <147752001094.813.10247306839794156732.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0079.outbound.protection.outlook.com ([104.47.32.79]:61118
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933838AbcJZWWe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 18:22:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - do not call pci_disable_device on an already
   disabled device.
 - add a new lockup condition to lockup handler.
 - remove coalescing settings for ioaccel2
 - update driver version.

---

Don Brace (4):
      hpsa: correct lockup detector pci_disable_device
      hpsa: add generate controller NMI on lockup
      hpsa: remove coalescing settings for ioaccel2
      hpsa: bump driver version


 drivers/scsi/hpsa.c     |   19 +++++++++++--------
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 12 insertions(+), 8 deletions(-)

--
Signature
