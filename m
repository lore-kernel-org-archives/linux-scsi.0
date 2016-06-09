From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 0/2] initial submit of Microsemi smartpqi driver
Date: Thu, 9 Jun 2016 13:50:49 -0500
Message-ID: <146549801043.16211.9235237852162154026.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0096.outbound.protection.outlook.com ([65.55.169.96]:28384
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbcFISvL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2016 14:51:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

- add smartpqi to kernel.org
- remove PCI IDs from aacraid driver
  - Depends on adoption of smartpqi driver

Changes since initial upload
 - Forgot to give correct ownership to the author.
Changes since V1
 - Corrected make ARCH=i386 kbuild test robot issue.

---

Don Brace (1):
      aacraid: remove wildcard for series 9 controllers

Kevin Barnett (1):
      smartpqi: initial commit of Microsemi smartpqi driver


 drivers/scsi/smartpqi/Kconfig                  |   50 
 drivers/scsi/smartpqi/Makefile                 |    3 
 drivers/scsi/smartpqi/smartpqi.h               | 1135 ++++
 drivers/scsi/smartpqi/smartpqi_init.c          | 6817 ++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |  350 +
 drivers/scsi/smartpqi/smartpqi_sis.c           |  394 +
 drivers/scsi/smartpqi/smartpqi_sis.h           |   32 
 7 files changed, 8781 insertions(+)
 create mode 100644 drivers/scsi/smartpqi/Kconfig
 create mode 100644 drivers/scsi/smartpqi/Makefile
 create mode 100644 drivers/scsi/smartpqi/smartpqi.h
 create mode 100644 drivers/scsi/smartpqi/smartpqi_init.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sas_transport.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.h

--
Signature
