From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 0/2] initial submit of Microsemi smartpqi driver
Date: Wed, 8 Jun 2016 20:05:52 -0500
Message-ID: <146543426006.9934.4017687416436916766.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0053.outbound.protection.outlook.com ([157.56.110.53]:28203
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754431AbcFIBG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jun 2016 21:06:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

This patches are based on Linus's tree

- New smartpqi driver
- removal of smartpqi PCI IDs from aacraid driver
  - this patch depends on adoption of smartpqi driver

---

Don Brace (2):
      smartpqi: initial commit of Microsemi smartpqi driver
      aacraid: remove wildcard for series 9 controllers


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
