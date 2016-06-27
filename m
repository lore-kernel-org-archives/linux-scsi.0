From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V4 0/2] smartpqi: initial commit of Microsemi smartpqi driver
Date: Mon, 27 Jun 2016 16:40:53 -0500
Message-ID: <146706289746.29152.13840476577189238722.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0079.outbound.protection.outlook.com ([157.56.110.79]:53728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751639AbcF0Vk6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2016 17:40:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

This driver is based on Linus's tree

This initial commit contains WIP of Microsemi's smartpqi module.

- add smartpqi to kernel.org
- remove PCI IDs from aacraid driver
  - Depends on adoption of smartpqi driver

Changes since V3
 - removed 'devices' and 'PQI info' sysfs attributes
   according to Hannes's review.
 - changes suggested by Hannes and Johannes Thumshirn:
   - removed statistics
 - fixed issues raised by Johannes Thumshirn
 - answers to other Johannes Thumshirn's review posted in a
   separate reply.

Changes since V2
 - Corrected make ARCH=s390 kbuild test robot issue.
 - Answers to Hannes's Review posted in a separate reply

Changes since V1
 - Corrected make ARCH=i386 kbuild test robot issue.

Changes since initial upload
 - Forgot to give correct ownership to the author.

---

Don Brace (1):
      aacraid: remove wildcard for series 9 controllers

Kevin Barnett (1):
      smartpqi: initial commit of Microsemi smartpqi driver


 MAINTAINERS                                    |   11 
 drivers/scsi/Kconfig                           |    1 
 drivers/scsi/Makefile                          |    1 
 drivers/scsi/aacraid/linit.c                   |    2 
 drivers/scsi/smartpqi/Kconfig                  |   50 
 drivers/scsi/smartpqi/Makefile                 |    3 
 drivers/scsi/smartpqi/smartpqi.h               | 1133 ++++
 drivers/scsi/smartpqi/smartpqi_init.c          | 6306 ++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |  350 +
 drivers/scsi/smartpqi/smartpqi_sis.c           |  394 +
 drivers/scsi/smartpqi/smartpqi_sis.h           |   32 
 11 files changed, 8281 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/smartpqi/Kconfig
 create mode 100644 drivers/scsi/smartpqi/Makefile
 create mode 100644 drivers/scsi/smartpqi/smartpqi.h
 create mode 100644 drivers/scsi/smartpqi/smartpqi_init.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sas_transport.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.h

--
Signature
