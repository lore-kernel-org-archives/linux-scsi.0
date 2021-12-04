Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082EFC433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Dec 2021 00:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354448AbhLDAa0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 19:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383701AbhLDAaV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 19:30:21 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9500BC061A83
        for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2021 16:26:56 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id s37so4606488pga.9
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 16:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FUNmraKcoaJkWHut5uSl5vhwQY377caQsEZF5H8QK9E=;
        b=l4xZtjcWPjCHQ7nx/KDUdOXYhTVpssfm1JRSwXTwB9pTRCFyZSAMnWnEmKcUV73H1+
         GiJi+iMiq6cn2QCX47MbgmjHbwwRc7TEnYHmaz9+7DTjCTCCiGH25cQ1l27U9ewCNOuP
         7QkgNp9wNmztNcBQfsvjBRuplNzgjvEFgvmBz//pr2rYsl29PwXQKpZkyy39a1WIqqMC
         /tujak2CT8glbVhO2FPAWxAStZFmFQxu7HUGP065+c00y1hG1kJ7TKY9fMXVagVFF40Z
         BBgL+YhmikslHmyXWRpD2e2s0lf41zPC0wCOkEtFnBQ1RO3Xra6tQa3KCYUYHKi36khL
         pq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FUNmraKcoaJkWHut5uSl5vhwQY377caQsEZF5H8QK9E=;
        b=jwi79NTZ0xIRNLtHmOskhVp/T8rYTtMfGVTwtTA3MwQdpGOwGrpgkrFFFxZgIU1uQJ
         Wmf2w5VvA6+IbYe8gFzUJrcAlbLRxFhIL3suxyb9iensAlxx9LBnL0WcT246ydjdUKqQ
         qTq+L7YPZZKht+BAdvgJI/M1V5Et8bngxl3eP7WFEzwCekMzSx8qXVsrNVDcvDfsQ5tb
         POoI9mrT12GxPL1nzC0r+PU/Zppomc+3GQ/8JwY9ciG7ixJdWp78pdDvTQoTSEY1cwvK
         7Z42jS9u/dBtMfgXbcOpD0ogS1ssWeqHm9B5XpAT/lGYUTBYHX+bPR3clwPLb/Yb/SZ/
         2HXQ==
X-Gm-Message-State: AOAM530SA3JEuRyc1pr+CO+uAaYlpylkCq1dt7xkKw9QkaDxDtWyX663
        E3L0WMzNjPgE5WaCl9lzHMWdPGNuTvA=
X-Google-Smtp-Source: ABdhPJz8cpOQ3ko4Xsijn66pNaXyTrOY6dcD1aJApqxk1r6kqDb48kH6w2dB/VUzreuoaNx36rgojA==
X-Received: by 2002:a05:6a00:1344:b0:49f:f357:ac9 with SMTP id k4-20020a056a00134400b0049ff3570ac9mr22175192pfu.62.1638577616041;
        Fri, 03 Dec 2021 16:26:56 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q17sm4970707pfu.117.2021.12.03.16.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:26:55 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 9/9] lpfc: Update lpfc version to 14.0.0.4
Date:   Fri,  3 Dec 2021 16:26:44 -0800
Message-Id: <20211204002644.116455-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.0.0.4

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 5a4d3b24fbce..2e9348a6897c 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.0.0.3"
+#define LPFC_DRIVER_VERSION "14.0.0.4"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

