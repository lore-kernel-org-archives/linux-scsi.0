From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 19/37] smartpqi: update copyright
Date: Tue, 25 Apr 2017 14:47:48 -0500
Message-ID: <149314966797.13903.9874417525942577395.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0057.outbound.protection.outlook.com ([104.47.36.57]:53856
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1167899AbdDYTsR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:48:17 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h               |    2 +-
 drivers/scsi/smartpqi/smartpqi_init.c          |    2 +-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    2 +-
 drivers/scsi/smartpqi/smartpqi_sis.c           |    2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h           |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 7a95868..d044a58c 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1,6 +1,6 @@
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2016 Microsemi Corporation
+ *    Copyright (c) 2016-2017 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
  *    This program is free software; you can redistribute it and/or modify
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3ffca17..c5b37bc 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1,6 +1,6 @@
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2016 Microsemi Corporation
+ *    Copyright (c) 2016-2017 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
  *    This program is free software; you can redistribute it and/or modify
diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 52ca4f9..0d89d37 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -1,6 +1,6 @@
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2016 Microsemi Corporation
+ *    Copyright (c) 2016-2017 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
  *    This program is free software; you can redistribute it and/or modify
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index e5a5d50..e1cf280 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -1,6 +1,6 @@
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2016 Microsemi Corporation
+ *    Copyright (c) 2016-2017 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
  *    This program is free software; you can redistribute it and/or modify
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 08ee0ab..983184b 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -1,6 +1,6 @@
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2016 Microsemi Corporation
+ *    Copyright (c) 2016-2017 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
  *    This program is free software; you can redistribute it and/or modify
