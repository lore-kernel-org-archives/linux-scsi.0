From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/7] hpsa driver updates
Date: Wed, 27 Apr 2016 17:13:10 -0500
Message-ID: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0068.outbound.protection.outlook.com ([157.56.111.68]:62424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751553AbcD0W1f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 18:27:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - move call to scsi_scan_host below where interrupts are enabled
 - add in timouts for driver initiated commands.
   - some faulty disks caused initialization hangs.
 - correct ioaccel change events
 - correct ioaccel error checking
 - enhance hot-plug operations for HBA mode
 - add a sysfs attribute for sas addresses
 - bump driver version

---

Don Brace (6):
      hpsa: correct initialization order issue
      hpsa: add timeouts for driver initiated commands
      hpsa: correct ioaccel state change operation
      hpsa: correct ioaccel2 error procecssing.
      hpsa: correct handling of HBA device removal
      hpsa: update driver version

Joseph T Handzik (1):
      hpsa: add sas_address to sysfs device attibute


 drivers/scsi/hpsa.c |  176 ++++++++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/hpsa.h |    1 
 2 files changed, 145 insertions(+), 32 deletions(-)

--
Signature
