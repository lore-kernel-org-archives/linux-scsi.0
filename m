Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37065C54EBD
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbjAIXXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbjAIXXB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:23:01 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E651BC14
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:23:00 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id dw9so9003959pjb.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o52mlmG+wYwEzC1C8pOro/22gWkaauNZDgRAB4INKHo=;
        b=QgmX1BieZfahRhos5NgsdYrS+2hkezpWKGy96/mqp8NW/vnrhzJRbR938cNwI6aZEv
         v8BYT6vG7+KJvQh5xJQZdVdmZYHKBF/cLDR8f5z/sAE+csr3baThuCKlJmfPZj7UJ/OR
         7wZe1ZCp9zTg1lxXlNoCpPkSJTaOspCCnGuxWuyhFVrkv5EHg7PjWet1AksnRhAm6x/4
         msjGQXPFu0u/2Z8+sA/yW7FwjDBhRYBvmvCfWLvNk/aVZw9Z1BaFyqwB27ITvMWZPjS/
         BnEaOBfbLIV/UerS3gJF1y0rRO6kfOtScuFPuxXHom69H19gMnQWjr4YHU2L9Aiag6OW
         QajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o52mlmG+wYwEzC1C8pOro/22gWkaauNZDgRAB4INKHo=;
        b=tdZ2LICtAjQQddciH9FA3JgzrfX7SXB6T+jdVl9pwMtzfGwnQDlbfNZOQ+IjbgR6Qg
         1EX0jMR4I2uJciLEfFPSaGD6UIn0FTctTmzojUszAH2BtkHmCaUw6uz+aZTAaicKiyZx
         5vJ0aT9gFRgjkg0yUf698BV2oyaXI27HZ2ABBhTtkbg4lnCnhRBEXJzY3zdBYjOXFnmX
         OuM4TaZ1CW0w24J+hPYAfQuoHTl0DCmgjirKxNhtr2NCrOun953Nshci6h58Hu5Qex1S
         OFi7fgU//w+VtuwJubhtF2rBmrooOZh0XsMyIMaTjRWEMtVmH72iHIha4vev1Lc3gzxz
         14FA==
X-Gm-Message-State: AFqh2kqf6g9UrtjWkGSC0e2DtmlKaW++0pfWTogjbID24JQvWienDChW
        NtrYOr03ay2m2+2GYpeWH4X1PFljaJY=
X-Google-Smtp-Source: AMrXdXv5bGHilCbzbENtLVZmozS7zgCeg2MnYwxnbRG+EFSvQ5CKdK7DhvBFnuH3EMrukbXGRJtTSg==
X-Received: by 2002:a17:903:268a:b0:193:3980:98d5 with SMTP id jf10-20020a170903268a00b00193398098d5mr2972494plb.57.1673306579399;
        Mon, 09 Jan 2023 15:22:59 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:59 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 12/12] Copyright updates for 14.2.0.10 patches
Date:   Mon,  9 Jan 2023 15:33:17 -0800
Message-Id: <20230109233317.54737-13-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2023 for files modified in the 14.2.0.10 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         | 2 +-
 drivers/scsi/lpfc/lpfc_attr.c    | 2 +-
 drivers/scsi/lpfc/lpfc_crtn.h    | 2 +-
 drivers/scsi/lpfc/lpfc_els.c     | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 drivers/scsi/lpfc/lpfc_hw4.h     | 2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 2 +-
 drivers/scsi/lpfc/lpfc_scsi.c    | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c     | 2 +-
 drivers/scsi/lpfc/lpfc_sli4.h    | 2 +-
 drivers/scsi/lpfc/lpfc_version.h | 4 ++--
 drivers/scsi/lpfc/lpfc_vmid.c    | 2 +-
 drivers/scsi/lpfc/lpfc_vport.c   | 2 +-
 13 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 1095595ca3a2..cf55f8e3bd9f 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index c95401225057..76c3434f8976 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index e72a2504163a..976fd5ee7f7e 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 264a3db6cd69..569639dc8b2c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index af0acf55b343..a6df0a5b4006 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 58589eb1a358..58fa39c403a0 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0fef8cd38ecf..faaaeae25d44 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 9b6580eb7ed6..e989f130434e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 55dfab9ae3c9..edbd81c3b643 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index babdf29245d4..3b62c4032c31 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index c06d981cf8c9..0238208cdd11 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -32,6 +32,6 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright (C) 2017-2022 Broadcom. All Rights " \
+#define LPFC_COPYRIGHT "Copyright (C) 2017-2023 Broadcom. All Rights " \
 		"Reserved. The term \"Broadcom\" refers to Broadcom Inc. " \
 		"and/or its subsidiaries."
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index 9175982066f8..cf8ba840d0ea 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 5aeda245369b..6c7559cf1a4b 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

