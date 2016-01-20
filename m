From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH] scsi update
Date: Wed, 20 Jan 2016 13:41:34 -0600
Message-ID: <20160120194028.23159.25263.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.241.235.117] ([216.241.235.117]:54642 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755379AbcATTnZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 14:43:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

This patch is based on Linus tree

The change is:
 - export sanitize_inquiry_string

---

Don Brace (1):
      scsi: export function scsi_scan.c:sanitize_inquiry_string


 drivers/scsi/scsi_scan.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--
Signature
