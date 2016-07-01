From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/2] hpsa update
Date: Fri, 1 Jul 2016 13:37:23 -0500
Message-ID: <146739698564.24478.63853333596746262.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0049.outbound.protection.outlook.com ([104.47.32.49]:16208
	"EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752710AbcGAULW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jul 2016 16:11:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - enhanced check for skipping masked devices
 - corrected hpsa_passthru_ioctl timeouts for fw flash

---

Don Brace (2):
      hpsa: correct skipping masked peripherals
      hpsa: change hpsa_passthru_ioctl timeout


 drivers/scsi/hpsa.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 76 insertions(+), 7 deletions(-)

--
Signature
