Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA92EC43217
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbiDLXgc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiDLXc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:56 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAB4C6260
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id z16so297645pfh.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ENTUlso3vksuPH0adZzIPu/o9WgKRy7UKF1u/nJygWI=;
        b=gurqKsXPPPlQnu874MRL0TWziJtGYR7sBXGP9K/urxELRsJKgJT7u3/UnOUBioQVjX
         Z2GHWYTacrWdFxjRRlHmBadReIwloL2Q/fW/CmfXL7G2Dx2Dq64EyLmUjWSG0bEMeJMn
         +okVyrtv0ZRdU87/KV21i9KNFgqYVJWsaId79703O9SB+oyx5529DRyPEZmqNHlbgxbL
         UHPXGJ5GS/xoq5JM3lw8Ph3SdG71SOgL+jjZDn6tI9gQ/wGWWOj6LjJzSzCiLhPGy+0a
         bY0H1dzY28gPs94o9DtxDT/9vcMaVM5/OOXFs3nk7cH26xTs282OafvxPqPfYvvR8Y6T
         +zsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ENTUlso3vksuPH0adZzIPu/o9WgKRy7UKF1u/nJygWI=;
        b=EbhcB6rus1v1P+g3Q1qOf8K43ux+TdrpU5qV/2kikblOBdK6ybEGHhl3O62AMSD6Gt
         aMV4VM37bLG/nab/p9l0d9zMVnWywVrO/v+tvq9rzDGaqUu9W0j7BGSIKhyhfOAKxJj1
         v6M0MX041iThRWQMXLqrCIQrij3Sv8GLiH6hfG+NoTmw0nXyMj32ujX6c5T+O1mT/ORg
         WfJ+btoOU5hpoP8zRNgc6T70WDRKqM4t0A0944RmKwzAb1Ev3RHTfIb0E+xshOZdZFN8
         0XTeaF3nbvctF12m9M9Nohg1iqK2LvkAcvZTrn7QwG0KgN32rT/nUpAr1Dn1pQQqTbqA
         CBiw==
X-Gm-Message-State: AOAM531yrgYH5F+3Z0TIdtzqUJ/qMXbHgbLDCrMmUQoVGx/67jwsnP3k
        ssWSnNSCeHmD1NG0SKwIv9vi6iGJfXU=
X-Google-Smtp-Source: ABdhPJzLxDivLqehHv20GtoB466PmCCLwD2pKJD75vIJ1EfZQcFSShvhxLuc0C/Li3z3iKa4kF223A==
X-Received: by 2002:a63:4721:0:b0:382:70fa:479d with SMTP id u33-20020a634721000000b0038270fa479dmr33106296pga.259.1649802035559;
        Tue, 12 Apr 2022 15:20:35 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 26/26] lpfc: Copyright updates for 14.2.0.2 patches
Date:   Tue, 12 Apr 2022 15:20:08 -0700
Message-Id: <20220412222008.126521-27-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2022 for files modified in the 14.2.0.2 patch set.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c   | 2 +-
 drivers/scsi/lpfc/lpfc_logmsg.h | 2 +-
 drivers/scsi/lpfc/lpfc_mbox.c   | 2 +-
 drivers/scsi/lpfc/lpfc_vport.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index c8fa579168c6..0c9cd1924918 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index a5aafe230c74..4d455da9cd69 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 712c8f6e4de2..9858b1743769 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index f635eb8e9711..e7efb025ed50 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.26.2

