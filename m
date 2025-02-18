Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8DB1B6D18
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2025 16:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739896482; cv=none; b=KrjzO+cSCXXd0OmCn+1pI6YojyYYP/fl+BHKlz21exlebo+3NRAHII7WpSBwKha3ehdIxxHGpOVnUn7Z+UqaPu+ywyVut8NgbbUSylvv7S8hZaC5aDS8tDPHPU3LG0gE85CXUl0hLnJesoehODfK6uD1T31bCSHsU0DiZgKfUMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739896482; c=relaxed/simple;
	bh=jfEqHLuXOrZxXmshUSWQRpqmKaICZV23N2rJibcpvLo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Hjs62EiIkCkHZyXDbwGkbZ0HP4EjXibznJt70GyHZX8MYkn46RKreNzzzgZE0sXmJGrCWAYcJO/zhT8TMvJ51sfSyy/ykHck97SCeWgpIJitJO/UZ61xCu/oRCzH2Ciji9E3dSgmGD4QMamAPOrK7o1GDjNXASS0ymPUKrXyzDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=pZl504hE; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="pZl504hE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1739896480; x=1771432480;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jfEqHLuXOrZxXmshUSWQRpqmKaICZV23N2rJibcpvLo=;
  b=pZl504hECiWKw1ZHCxF2Wz1cnf7xInBtWec49frnBXArGhu237pr5ePU
   abXZpNXjz3FOGYVXSrKJHkSleb8qzcpio5B+EwGB4PvT6nJNM24A3+yk2
   0QV4CWiGbmuz+Wi16oSHSBO80QM4MDQPElF6Z1R1D+D0E9GczXPIFYG1M
   AAAmSKlabGkY82XYqPMuZSaLar1TxAdWCSG76RS3ID4IbxRnX2pmCrvSw
   njgbNwE+zZ2JhufyzQQy0Ykaat+2GmO8NnGdd+LwSlBUiDthrhBj77ndv
   hcCU1P8rI9HzoLds6AHSgym6b/nWXikjNaBURW3d7eV3B4Oxh/atVjnqU
   Q==;
X-CSE-ConnectionGUID: sOoCRrcITF2oVRZwM8aBag==
X-CSE-MsgGUID: 5CB6SAk1Tgab4hW8rm0Tzw==
X-IronPort-AV: E=Sophos;i="6.13,296,1732604400"; 
   d="scan'208";a="205359265"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Feb 2025 09:34:34 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 18 Feb 2025 09:34:11 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 18 Feb 2025 09:34:11 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
	<mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
	<murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
	<jeremy.reeves@microchip.com>, <hch@infradead.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH] smartpqi: update copyright to 2025
Date: Tue, 18 Feb 2025 10:34:10 -0600
Message-ID: <20250218163410.874309-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.48.1.356.g0394451348
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Align Microchip copyright to current year.

Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/Kconfig                  | 2 +-
 drivers/scsi/smartpqi/smartpqi.h               | 2 +-
 drivers/scsi/smartpqi/smartpqi_init.c          | 2 +-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c | 2 +-
 drivers/scsi/smartpqi/smartpqi_sis.c           | 2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h           | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index 789460b0a342..0700811f86dc 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -1,7 +1,7 @@
 #
 # Kernel configuration file for the SMARTPQI
 #
-# Copyright (c) 2019-2023 Microchip Technology Inc. and its subsidiaries
+# Copyright (c) 2019-2025 Microchip Technology Inc. and its subsidiaries
 # Copyright (c) 2017-2018 Microsemi Corporation
 # Copyright (c) 2016 Microsemi Corporation
 # Copyright (c) 2016 PMC-Sierra, Inc.
diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index fae6db20a6e9..c65236eb7ca0 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2023 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2025 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0da7be40c925..a60641ac38d5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2023 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2025 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 93e96705754e..369585374221 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2023 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2025 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index ae5a264d062d..a619179edb4c 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2023 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2025 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 7e0eac3d07de..8085bec6da36 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2023 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2025 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
-- 
2.48.1.356.g0394451348

