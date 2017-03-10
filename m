From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V3 0/3] hpsa updates
Date: Fri, 10 Mar 2017 14:35:05 -0600
Message-ID: <148917802486.17050.17178463722401202189.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0088.outbound.protection.outlook.com ([104.47.34.88]:28222
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754943AbdCJUfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Mar 2017 15:35:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - add in a new offline volume status
 - limit the number of outstanding rescan operation
 - do not timeout reset operations

Changes since V1:
 - hpsa-update-check-for-volume-status
   - changed return type of hpsa_volume_offline from
     int to unsigned char
   - return more specific values.
   - removed unnecessary code
   Based on review from: Tomas Henzl <thenzl@redhat.com>

Changes since V2:
 - hpsa-limit-outstanding-rescans
   corrected a comment typo (alreay - already)

---

Don Brace (3):
      hpsa: update check for logical volume status
      hpsa: limit outstanding rescans
      hpsa: do not timeout reset operations


 drivers/scsi/hpsa.c     |   53 ++++++++++++++++++++++++++++-------------------
 drivers/scsi/hpsa.h     |    1 +
 drivers/scsi/hpsa_cmd.h |    2 ++
 3 files changed, 35 insertions(+), 21 deletions(-)

--
Signature
