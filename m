Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469CFC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 09:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18061610CA
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 09:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhKAJVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhKAJVE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 05:21:04 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34C8C061714;
        Mon,  1 Nov 2021 02:18:31 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id bi29so15879341qkb.5;
        Mon, 01 Nov 2021 02:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zp2Tl/CjuwQMl4Hw6vIct+XQzOdHpUX1ecIrs5lSgyA=;
        b=mJh9H/O8ofpSvEbcqwpthDWpBErOHclwMbcXANgaPCRUXuM3Pq5U/LPsX2ImMnzZhe
         JYirP5lAl62fFKD3OQ/MH1JpF/SwH4aCPAKM2loCY7oKq+aCzhOJn91dWPo2ICIGXLqh
         x0WO6ULFBB6FLCVcDtK9/lxLkBpFaAH8o8AQScXjMW1PYNKXG+d/dVfa2QpllLdPyTmi
         VmPsfzRkvCe1BN8nl+RSVyVkeVEEXubxlQaE3VOhNxoyx55rYYx7/JDPR9W9CJm8mTr1
         givT5JGRqavleI0HG6VDD2KwcoximLp61dt2dDs1ARVwq0TDU9jvdZ4SJnp07UwJImKq
         J9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zp2Tl/CjuwQMl4Hw6vIct+XQzOdHpUX1ecIrs5lSgyA=;
        b=YBfA+RuMxRW+nRGEQjrLwAdlIRSkirbRmFuukoS5MOHWYOOPJYPbP+v6v5Jnmj3d0J
         kXJ7z0jTb1qDrYI4dq//fSrWqIJ8gjYC3WdcT63bA6R/WZvCfn5Ib3/NqiogpCBqoyFW
         Cww6buVm/EXv2I1RXLttmD5i6CMzhWBv4te1Y7pNQP2D4jRKMC/UfeuArp1aW89R8wFy
         z9eNhr8c0x1jFlwbB31RTNqgM37AwFD1ObP67kKxDPK94nU3P5JA2d5t3tqq7AUkq2ql
         LW8YQK++Sh3/853AYEezXbiQiLTmlZXXH/8oQVwRdgLwnuK5EyHBYz3BysmDwlG3+0/Q
         FExQ==
X-Gm-Message-State: AOAM530zq4Kk1LPZ6GZXvqz2pe7rY921rrdMKcRpL3n1ARdZ8k4u7UNz
        F38OZRCRt+wjzXDS5I2ZCWw=
X-Google-Smtp-Source: ABdhPJzEJFOA4NCjhDPwB4K6TQXPQtaic/9JzDn6Q09j0DkaBMQ+/vl8g1jyEG9krZf2CeIT+5eCdA==
X-Received: by 2002:a05:620a:17a3:: with SMTP id ay35mr9929121qkb.476.1635758310981;
        Mon, 01 Nov 2021 02:18:30 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id c3sm10390575qkp.47.2021.11.01.02.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:18:30 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.mingyu@zte.com.cn
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Mingyu <zhang.mingyu@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi:qlogicpti:Remove unneeded semicolon
Date:   Mon,  1 Nov 2021 09:18:19 +0000
Message-Id: <20211101091819.37517-1-zhang.mingyu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zhang Mingyu <zhang.mingyu@zte.com.cn>

Eliminate the following coccinelle check warning:
drivers/scsi/qlogicpti.c:1152:3-4

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
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

