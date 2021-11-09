Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521C3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 01:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36A2661156
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 01:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241630AbhKIB4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbhKIB4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 20:56:05 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CFAC061570;
        Mon,  8 Nov 2021 17:53:20 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 127so17895024pfu.1;
        Mon, 08 Nov 2021 17:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O2ypJsl1BEeYFDXq3eYu1gdA/Fd9S4/V39NqVVTEc84=;
        b=hIsJPHiLcCNNFp8ydez2IGHAusw+MyyuceIKeOKtDNwCLEu/JHkcTJlN71JZFs1aPl
         v/BvUjGox0CbAx09qXdg1b+JwIW0jvC5xdvfcVllMFDsI18VuzFYUNbwb1JXv0IxvUT6
         4g+LRQfZs2aw9IymifRytVY4aV3tr/pBKHV9i8V1RZg1V/h1nubPMS/HiYDmuBnq3llP
         IGJlOG/OlVHn2YWpttNnxKVO8LdGmyq1q2dTp5cpc2+E3cXLZL8iBS0ZHhxnv7uFVlwv
         ZYDCjPVmLxP9Vzp9ilrrZhz5+Ju9ViYNnP2bCecX3DKOOyxwRuMm7H/YoR8h0jQUt8/F
         HeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O2ypJsl1BEeYFDXq3eYu1gdA/Fd9S4/V39NqVVTEc84=;
        b=6ixExBOlibROjpOD6i8fKpoFnmobkyCXFHH0xez/zWTxsdUbaqGF1FtEYg8MYSpVNq
         mVksD/qzZHXYS9hi2KY5+DY4B8YrcjXOyS9p6mWQIWnxCPeMhxk0Ixlw7uMKIA87wAlT
         LpYjyZytRdHoorb4bmPm8Xwlyf0xc+HabWpMog7oaA/QEKA0/IpwmuKd55SJW2rmKi7J
         +KwFPoJhud7A51diJzfIG5zhhoCP/LV2t/j6uEUg+qq29P8YkswoOiQo5M8Jhq/zmeEZ
         0d2Yw0sJBAAT34RwQ4vcDGKG1twZII12r9FI45S5KZnzbwkHIbZIMJSBJYW/Pw2Ds03N
         bDxA==
X-Gm-Message-State: AOAM533uLQ50o28U1ZfNGe38L9LegeHCn2McHUyy2ULlvPJOybPuraOU
        iS4j452wS81eBCATHSJTLO0=
X-Google-Smtp-Source: ABdhPJxEIWPgaW7Jwe8fUUBWJ+JBn4uHOQgAEm2AqmSRmcvU/BD/yPIajFeslikv/8CKiZpMj7Kzcw==
X-Received: by 2002:a63:d654:: with SMTP id d20mr3148587pgj.122.1636422799739;
        Mon, 08 Nov 2021 17:53:19 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b18sm17566777pfl.24.2021.11.08.17.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 17:53:19 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ran jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi:qlogicpti: remove unneeded semicolon
Date:   Tue,  9 Nov 2021 01:53:11 +0000
Message-Id: <20211109015311.129451-1-ran.jianping@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ran jianping <ran.jianping@zte.com.cn>

Eliminate the following coccinelle check warning:
drivers/scsi/qlogicpti.c:1152:3-4

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
---
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 57f2f4135a06..59c82d740139 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1149,7 +1149,7 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 		case COMMAND_ERROR:
 		case COMMAND_PARAM_ERROR:
 			break;
-		};
+		}
 		sbus_writew(0, qpti->qregs + SBUS_SEMAPHORE);
 	}
 
-- 
2.25.1

