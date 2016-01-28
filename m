From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH V1] scsi update
Date: Wed, 27 Jan 2016 20:16:19 -0600
Message-ID: <20160128021338.11129.99989.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37270 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965577AbcA1CRo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 21:17:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

This patch is based on Linus's tree

The change is:
 - export sanitize_inquiry_string

Changes from initial upload:
 - Added prototype to scsi_device.h

---

Don Brace (1):
      scsi: export function scsi_scan.c:sanitize_inquiry_string


 drivers/scsi/scsi_scan.c   |   12 +++++++-----
 include/scsi/scsi_device.h |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

--
Signature
