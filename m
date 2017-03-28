From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/2] hpsa updates
Date: Tue, 28 Mar 2017 16:40:07 -0500
Message-ID: <149073716991.23669.3063211911971326983.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0047.outbound.protection.outlook.com ([104.47.32.47]:36384
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932261AbdC1VkS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Mar 2017 17:40:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

- add some PCI IDs
- update the driver version

---

Don Brace (2):
      hpsa: update pci ids
      hpsa: change driver version


 drivers/scsi/hpsa.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--
Signature
