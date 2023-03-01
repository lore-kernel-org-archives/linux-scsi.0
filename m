Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969C2C7EE33
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCAXHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCAXHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:36 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E1351FB0
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:34 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id w23so16249719qtn.6
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UUk9ojxrg7vzWS/4PKV4bYUzOKrLkaKmA1W4GVN9dI=;
        b=MaPyJgS96UUN0Q+hhhwuDkK2YTQq2ZPyKq2Tn03B7xtxfV6m3To7Pk0Sshzk8aHQnq
         b8nogqnJ/luLe4/FzFjM4NZkJ/6qk6Q+Bg8Wd71IlpyMFeJdLq8RpfoYV0V0/WXQyN3E
         bgO0BvqLV7Heq1MCcpv5EsNiebSF2sIaDogJtDZ0XemgaPpsAYZe1gnvSoxfUL2rFGGU
         S9KIyZ1f2opLBkKQi3wzSVsDFmZ5fWSvjK9hRjqB/ltj9/vIY1WWAiB1T21D0SfeL0Pw
         KaW8NDhum/gRelmkAzxALxwFRDj1TvbG3EDgB1i/Igfjo06mPD+SulFk4DR7X08QqShV
         pVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/UUk9ojxrg7vzWS/4PKV4bYUzOKrLkaKmA1W4GVN9dI=;
        b=bzV/fVlPm9m9WHRnKk5qV1cuxRgwSYokMfsib0AamU0LShe+kVj/OKK4EV+yUwrPKr
         90yEh6int+tRr+g6vUgl15A0HdRTfiXsFEALsyLHGu9wVXKl3n2/hYhe9wNo0myVTa4l
         XUhAq8C1uc0EynkkPU2jl+0YNKPXvtApgMkVVVd0q42vb60ZbaR9+eA+oBX6HHdvgA/H
         avBAdI1eaBDiB68W31t3jdhFMRndKZbdqW/H4gtUsQ94jIobTGkZLmRc4LA+iH872sD+
         6yV02FAFBib3V+41YK6xl26QD/81P/zDcHEmiwtwJxdf3AtZN/qAogDLXNPRZFKJc5/Q
         j38g==
X-Gm-Message-State: AO0yUKVQ+LmgfwX0p3F3YQK0DAmcEyJnXLTiaHywfj+FKWNoQbElt0na
        VMpnUNcdE2w1MwJ3ccLCKzYuy+P0vp4=
X-Google-Smtp-Source: AK7set9m7GwTqIZ8CriMeEwoInY1TJY7XEq/Ms4BiGdktiOXD2lNmu5NIG0XiXoG/Mk9cn3HBrkphg==
X-Received: by 2002:a05:622a:4cb:b0:3bf:d841:f1ee with SMTP id q11-20020a05622a04cb00b003bfd841f1eemr16462167qtx.6.1677712053615;
        Wed, 01 Mar 2023 15:07:33 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:33 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/10] lpfc: Copyright updates for 14.2.0.11 patches
Date:   Wed,  1 Mar 2023 15:16:26 -0800
Message-Id: <20230301231626.9621-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2023 for files modified in the 14.2.0.11 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c     | 2 +-
 drivers/scsi/lpfc/lpfc_ct.c      | 2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 +-
 drivers/scsi/lpfc/lpfc_hw.h      | 2 +-
 drivers/scsi/lpfc/lpfc_nvme.c    | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index d8e86b468ef6..9a322a3a2150 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index c6e10e23f342..f3bdcebe67f5 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 3e365e5e194a..bdf34af4ef36 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2007-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index e9244bedb0f4..19b2d2754f32 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index ae3207e73113..adda70423c77 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

