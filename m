From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/7] hpsa updates
Date: Tue, 23 Feb 2016 15:16:03 -0600
Message-ID: <20160223210957.5968.6998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:50190 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438AbcBWVQG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 16:16:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - stop requesting enclosure info for external devices
 - add in SMR support
 - correct lun data caching macro definition
 - add abort support for hba devices
 - check for null pointer in ioaccel2 path
 - remove definition for sanitize_inquiry_string
   This patch depends on
   - commit ac10a3e4ed64
       ("Export function scsi_scan.c:sanitize_inquiry_string")
 - update copyright information
---

Don Brace (7):
      hpsa: do not get enclosure info for external devices
      hpsa: add SMR drive support
      hpsa: correct lun data caching bitmap definition
      hpsa: correct abort tmf for hba devices
      hpsa: check for a null phys_disk pointer in ioaccel2 path
      hpsa: remove function definition for sanitize_inquiry_string
      hpsa: update copyright information


 drivers/scsi/hpsa.c     |   52 +++++++++++++++++++++++++----------------------
 drivers/scsi/hpsa.h     |    3 ++-
 drivers/scsi/hpsa_cmd.h |    5 +++--
 3 files changed, 33 insertions(+), 27 deletions(-)

--
Signature
