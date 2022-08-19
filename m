Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5E6C28B2B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Aug 2022 01:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243676AbiHSBS3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Aug 2022 21:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242429AbiHSBSW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Aug 2022 21:18:22 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B1C60E2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:17 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id c5so2005723qvt.11
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2022 18:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=t4arLGO03jP3uKxYAviXQwdnM1PFp+XHQkj2r8AR3mk=;
        b=PvDM5kc1ROGOgk2Eu0ogduGr6FHNZQI3uvjFTEpVgBvhY4/XKXVwsSj/zHsemGEVBA
         2I2wa7VwqzhXeAFxRmnpORUkxa+vpO66k4+ifalHgXazmNPtxYD6jI4JLg2cqN9flkq/
         LX0ZHtVqBn6cIKqpRNG+hful5u8AACrAdg5t7bZqn0QQzUJtSB5sOzfWBuECznuw0G2U
         S3BSH6YasFuTM/lm8aqq9VerszZl4L/Gz50ktAPap+3VjWUX7aYsO0GXVk/tUoYJNZcq
         cMS3a9Fu5CxIlJrrTnNadmQ/fKNEjGSu8BSUQnifgvFU6fu14RbWhyz5F92Z9+BG3GYh
         ct5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=t4arLGO03jP3uKxYAviXQwdnM1PFp+XHQkj2r8AR3mk=;
        b=R5twUQp8szzND8C88E6Rf7fgZhc04qiCneFZhmHJ8wIxpRzrt3HUItTmdThFjXsaRp
         RDjeQNfuHx9o6buUVv1AN23qBdHlZofrYEPxMG+Zk2DoElFuJktyIHKPuopQpgB/Msnn
         cJ7Z1C/ZSaepXW6t/kE4Rzrt3ZfRWyhcpr1bHkRzczrP/Ts/s95HNZLm9GTMKWgk92+M
         cSktm4oZYpzOi/HxlGu5X73GOz1Tp5x/4LU8mzRBEYKfSAo+qBzPRxrpOq9HrfOdO9ly
         i5i8q3+ZRtLCNkF/i9c+oo6CQNuIGha7Kj1ZmenH2UKvG3xkWOC/30RC3HlDRnzpn+G5
         WuRA==
X-Gm-Message-State: ACgBeo3cFER3GHTjdcaaduub/aQD2sIwv9w9NWSW2aWhuy0Mmd1AXMTD
        7XGErrwWg2QFvOyPIIs79lrc0CWviaQ=
X-Google-Smtp-Source: AA6agR6l9xL6ozuwKb48kZGw2lW3SnYArThSFJ7eoZuGSEdzRNmeUqx8GlKb7fpTkCWnYllPyLbFHA==
X-Received: by 2002:a05:6214:20e7:b0:479:6ed5:e5ff with SMTP id 7-20020a05621420e700b004796ed5e5ffmr4730113qvk.69.1660871896670;
        Thu, 18 Aug 2022 18:18:16 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a0c4500b006b5e296452csm2612502qki.54.2022.08.18.18.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 18:18:16 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 7/7] lpfc: Copyright updates for 14.2.0.6 patches
Date:   Thu, 18 Aug 2022 18:17:36 -0700
Message-Id: <20220819011736.14141-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220819011736.14141-1-jsmart2021@gmail.com>
References: <20220819011736.14141-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2022 for files modified in the 14.2.0.6 patch set.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.h | 2 +-
 drivers/scsi/lpfc/lpfc_disc.h    | 2 +-
 drivers/scsi/lpfc/lpfc_mem.c     | 2 +-
 drivers/scsi/lpfc/lpfc_scsi.h    | 2 +-
 drivers/scsi/lpfc/lpfc_vport.h   | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index f71e5b6311ac..8d2e8d05bbc0 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2007-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 5b34838ece16..fb945692d683 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 5d36b3514864..89cbeba06aea 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2014 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 27696b08af0b..eae56944f31b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_vport.h b/drivers/scsi/lpfc/lpfc_vport.h
index 1c4bbda027b6..fa60c146c169 100644
--- a/drivers/scsi/lpfc/lpfc_vport.h
+++ b/drivers/scsi/lpfc/lpfc_vport.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.26.2

