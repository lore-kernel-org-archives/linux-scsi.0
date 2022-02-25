Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DA8C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbiBYCYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236789AbiBYCYF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:24:05 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5863C1C74D3
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:33 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i21so3444905pfd.13
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yuR4MoBi6mjsPNZyRf6Jc9EHpDsSZ2xbe57oULx37+Q=;
        b=nCuyLQ+O8kpiglae7ZwK+NVWOJpfveb0kHkJx7lGIj1wX11C8nFCXOEGMbU8+y69yF
         AO0mMb+/4rczJfCEK0kCJuZ/mP30EXZXZxb6ruSvzN9BHSQKU9Ko6DLM6nkg2RDQ6HyO
         L89e+DxBjZXt49fFXb2GDXOo+IgZo/vu+RvEAiYtcd4jluRgQJWVVbZvsaT0ZioJ+jFl
         jzNAJaAjNWKimi/dZcfIpTzC06WKK9FTAe6O8U+KOh7rhfUQ/EvUfNtrqzuSSwlwTkBm
         r4z3WcNN9M91Q+XVn6ddtNFEHwzW+Qo06bCKbUm7xpT1OTdAY7k/K000s7EORWPR3k6l
         +Ixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yuR4MoBi6mjsPNZyRf6Jc9EHpDsSZ2xbe57oULx37+Q=;
        b=l5S0ZyDlHa3Bu5aDgadIUly2U+6Mk+xCYFz1O1yQj2/aa5W8bcgYK6VbC3sfatngV/
         e2vE0S1OIXcNq1BfgrHScNnwFwWjvvZ78fK0fO8p9kRauBlm8eYwGix0QPCZFnbU2XsM
         XURlrmoR9g4sRZ0we6QRfdMc6BX+PmLRol1tff9PQq8jGFpZKsRZtmB9WqVCG0gougao
         MR7Xynn2vuqFqbsAW7Bg8L8U5KVWAkUBlZMauzbeMLeSK/ri1ed9y/AVHtPRKHUkshnB
         EF6liwkfAuWvzRRKfkYPHKp4SmJOhj1MNp9sMQ2CXr+/LwHTTLOja1sw9EmPFBL86Kt0
         H5Ug==
X-Gm-Message-State: AOAM533q94OaFYS76wRznM77yKQGp1EpC60mT2FEx7/HxixMQE9+28Sv
        uqfQrqLe0aA1KFkWAGVYGsCfTccx3+E=
X-Google-Smtp-Source: ABdhPJwaBiqtD+aZnIOVEfzjcQt8eofAf3PKhnyS6KE6wY8LbVTzPpkO67TJFZ7WZ5uE5j7dcnKi+w==
X-Received: by 2002:a05:6a00:1f07:b0:4e1:3335:9dd6 with SMTP id be7-20020a056a001f0700b004e133359dd6mr5358055pfb.76.1645755812400;
        Thu, 24 Feb 2022 18:23:32 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:32 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 17/17] lpfc: Copyright updates for 14.2.0.0 patches
Date:   Thu, 24 Feb 2022 18:23:08 -0800
Message-Id: <20220225022308.16486-18-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2022 for files modified in the 14.2.0.0 patch set.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h           | 2 +-
 drivers/scsi/lpfc/lpfc_bsg.c       | 2 +-
 drivers/scsi/lpfc/lpfc_crtn.h      | 2 +-
 drivers/scsi/lpfc/lpfc_ct.c        | 2 +-
 drivers/scsi/lpfc/lpfc_els.c       | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 2 +-
 drivers/scsi/lpfc/lpfc_hw.h        | 2 +-
 drivers/scsi/lpfc/lpfc_hw4.h       | 2 +-
 drivers/scsi/lpfc/lpfc_init.c      | 2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 drivers/scsi/lpfc/lpfc_nvme.c      | 2 +-
 drivers/scsi/lpfc/lpfc_nvme.h      | 2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     | 2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 2 +-
 drivers/scsi/lpfc/lpfc_sli.h       | 2 +-
 drivers/scsi/lpfc/lpfc_sli4.h      | 2 +-
 drivers/scsi/lpfc/lpfc_version.h   | 4 ++--
 18 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 311b8472d8c6..d8f983fc615d 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index f1bb40fe8206..8b586fa90f70 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 131b7a44f8c7..96408cd6c4c8 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 31f185a11bcb..4b024aa03c1b 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8be071696ad8..ef6e8cd8c26a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index d94435494281..0144da30e3db 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index be4c0e025eeb..d6050f3c9efe 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 01d8f4b241c7..02e230ed6280 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 39bf8af8bcef..28dd259d32af 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 3af58346602a..c4e1a07066a2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 559c5718b495..1213a299f9aa 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index d7698977725e..733c277948c0 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 18f539001e2f..95438265fb16 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c0999256cb19..a74108cce40e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 23dc2cec6bf5..20d40957a385 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index d5c26995ba39..663cc90a8798 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 5962cf508842..e0c25699f4b8 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 6bceb8a0ae30..e52f37e5d896 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -32,6 +32,6 @@
 
 #define LPFC_MODULE_DESC "Emulex LightPulse Fibre Channel SCSI driver " \
 		LPFC_DRIVER_VERSION
-#define LPFC_COPYRIGHT "Copyright (C) 2017-2021 Broadcom. All Rights " \
+#define LPFC_COPYRIGHT "Copyright (C) 2017-2022 Broadcom. All Rights " \
 		"Reserved. The term \"Broadcom\" refers to Broadcom Inc. " \
 		"and/or its subsidiaries."
-- 
2.26.2

