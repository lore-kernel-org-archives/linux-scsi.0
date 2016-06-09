From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V1 0/2] Series short description
Date: Wed, 8 Jun 2016 20:18:47 -0500
Message-ID: <146543503567.10204.3458324982970458038.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0071.outbound.protection.outlook.com ([157.56.111.71]:30743
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161745AbcFIBeS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jun 2016 21:34:18 -0400
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
 drivers/scsi/smartpqi/smartpqi.h               | 1106 ++++
 drivers/scsi/smartpqi/smartpqi_init.c          | 6817 ++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |  350 +
 drivers/scsi/smartpqi/smartpqi_sis.c           |  394 +
 drivers/scsi/smartpqi/smartpqi_sis.h           |   32 
 11 files changed, 8765 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/smartpqi/Kconfig
 create mode 100644 drivers/scsi/smartpqi/Makefile
 create mode 100644 drivers/scsi/smartpqi/smartpqi.h
 create mode 100644 drivers/scsi/smartpqi/smartpqi_init.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sas_transport.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.c
 create mode 100644 drivers/scsi/smartpqi/smartpqi_sis.h

--
Signature
