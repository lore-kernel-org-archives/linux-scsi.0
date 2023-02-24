Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70BDC678DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 14:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjBXOoc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 09:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjBXOoR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 09:44:17 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDCF18B0D
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 06:44:15 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id q11so17278939plx.5
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 06:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=uzm+FhP/Z2VI5jxHIYGPSXZA+PlrO22izUAr1vAh4k4=;
        b=ZScSEm27X/MSvPbCpGFCNyMWggtGdH95DFRn4o6WI4r5My7+4fqH7TCGJRQ2GhY76v
         GturbWjvgPpwz6patyfxjWD/hSmLFJjFB3FZwShMPEzpt4y+odL769P/xxqkRnO+eMQT
         oNUCgSG+hb33Ukzn/B1M30Wh9pA2VSkLT7Bw0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uzm+FhP/Z2VI5jxHIYGPSXZA+PlrO22izUAr1vAh4k4=;
        b=QwGmt3J8VrBp3SSF+E/NYYmb3JfkLDdupJDe+T0j9Fk25zyaBl9E1m+6aXSua3nLPV
         BDN7CClwF5I2idELvzm/jTpozVFnvYVenhar3c5OIN0bGcuNVCWP8521FNAdImKgy0xs
         AdC7B3Cm7JLJK7EUPLu79LK/MpX5CTIrLXtjTsGc8Ng/XClIq/dxHFjjQqSQ1S+Fbuo6
         oZtfjkNWFuIlF58mOXiXT+UXchku+Tjy2Dq3ebw7xGGWZQKXleijSX8HGr0YhvigS5ip
         bebRfpbNAUOKwgPu4CzxR5rkdPLum0L0s6tYOZcxt9PvDbjtoQ1s/VJzotUT5BcjxumW
         pxgg==
X-Gm-Message-State: AO0yUKU5BOwT+82Cb36w0imYR7OJrVj3M2QHSuaC/NBDbuFq0L0CUGhl
        trXtHvlTGXRDINnt9Rb5vz3F5vurbJ414IL94uWG2kp2rBgbf3z7R21ElI9SQHSLpSm7Pfidamd
        +/jzIbunAPVkn06+CouYYX6frm7D265YOvllfqYzs7m6x6AQQtw+nFuNmkURE8cu23+RtWGofzF
        LH0X1N8a8=
X-Google-Smtp-Source: AK7set8A7h2CEzYH7mpJChbR13YWD/o+mtf08XEQ6tc2e95M3W4b2z+5LPm9UlcWfJA5COIekK0q+Q==
X-Received: by 2002:a17:902:f549:b0:19c:90d2:c909 with SMTP id h9-20020a170902f54900b0019c90d2c909mr15820023plf.42.1677249854936;
        Fri, 24 Feb 2023 06:44:14 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902a9c500b00186748fe6ccsm8911549plr.214.2023.02.24.06.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 06:44:14 -0800 (PST)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 06/15] mpi3mr: updated copyright year
Date:   Fri, 24 Feb 2023 06:43:11 -0800
Message-Id: <20230224144320.10601-7-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230224144320.10601-1-ranjan.kumar@broadcom.com>
References: <20230224144320.10601-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d4ff2c05f57329c1"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d4ff2c05f57329c1
Content-Transfer-Encoding: 8bit

updated copyright year from 2022 to 2023

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_pci.h       | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h       | 2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h | 2 +-
 drivers/scsi/mpi3mr/mpi3mr.h              | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c          | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_debug.h        | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c    | 2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
index 1adccd2d5c77..2fc196499c89 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2017-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2017-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_CNFG_H
 #define MPI30_CNFG_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_image.h b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
index 64c58815988a..47035b811902 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_image.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_image.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2018-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2018-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_IMAGE_H
 #define MPI30_IMAGE_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
index 9efd4c6de813..af86d12c8e49 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_init.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_INIT_H
 #define MPI30_INIT_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
index 1c6c6730df5c..f5e9c2309ce6 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_IOC_H
 #define MPI30_IOC_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
index 1b2a96325d21..7c15e5851ce4 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  *
  */
 #ifndef MPI30_PCI_H
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
index e587f77ccd68..4a93c67d335f 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_sas.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_SAS_H
 #define MPI30_SAS_H     1
diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
index f0cd203d78fb..441cfc2c7f09 100644
--- a/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_transport.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *  Copyright 2016-2022 Broadcom Inc. All rights reserved.
+ *  Copyright 2016-2023 Broadcom Inc. All rights reserved.
  */
 #ifndef MPI30_TRANSPORT_H
 #define MPI30_TRANSPORT_H     1
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index e8079b380fc8..1cfbf39365d2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 86d9e200f408..935e26afc291 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi3mr_debug.h
index ee6edd8322e6..e94f7520d153 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
+++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5f6c9a8a9e35..83e145494067 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 3677473a0211..e4ae246f4bd2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 3fc897336b5e..6f84760ca85d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -2,7 +2,7 @@
 /*
  * Driver for Broadcom MPI3 Storage Controllers
  *
- * Copyright (C) 2017-2022 Broadcom Inc.
+ * Copyright (C) 2017-2023 Broadcom Inc.
  *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
  *
  */
-- 
2.31.1


--000000000000d4ff2c05f57329c1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIkjgvCprr8ho3QOW0FM1ZFUKBLzvCBu
uZ+6RxtiKfJzMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDIy
NDE0NDQxNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCKnBWASa+iXku4ZPJZELXL1QorT9olkJLok8f2ZLKkY/9CHrLD
K89vfdzWApfQQvtfu2kkLFeJOnWWJ8qgLkmvXVn2ofrNJXJMraVo4tH+uG/C/o8YJ98STyUYWKXz
R4rkeWZU9L6PEY104aT/Qp6a4lruRfr+N3pLtCx3l9NiRmD2ApjARvmphC5WvaGAni9Z/qnMuqMi
Xltd8RKA/mefTigWI64H/sn8QBbHr7v1YVesLvwdb9spz8LyFMD0kQVwYOBVezJEp8aCVr5H+yAo
GvJIbjyFSu6SKzL6bHODnqGYe0/F4U4Y0N09DvDQdeyndVbC1yce+uuwgphQ13Il
--000000000000d4ff2c05f57329c1--
