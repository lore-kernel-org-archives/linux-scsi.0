Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32EDEB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjGXU06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjGXU05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:26:57 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62EA188
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:26:56 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-676f16e0bc4so2784820b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230416; x=1690835216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dYniK7Hw1uTY1UOxsG/9Vs+VpdbIaLHrHsrefb7fFws=;
        b=dLGFK9wLNmhEdElL74ZhFRMIl4/r68H1tcecJTFn6g+a/7et3orqTi4pag7HNY/M+B
         QtThW95B3J9Go7cfqptkW7yxHAVBcm1nyT9Kaclr8LBMlEwKhWFbQYlMbs3Mk0wWUBHa
         OLRD+abks/aaXSBJCCGnmIYHArUOVEcdOTqaPv5lCcaE8UK3XvSY65f14pzm6Su7YJ90
         m1PFhaynSIBZsMX92ypRYFi5hKWPTAAL7vcw7Hd+thv5EVUEmp1H7bbx7a380l4Atnb9
         UwEdJbN+OYKIufreBsk6E5n15Q9uiQUQjkIirrwQUAaOrnAi5Q242qmeAkzZue459HXj
         eBYA==
X-Gm-Message-State: ABy/qLY0nhufSJA2lYyJOsw1dymkfFXoxhMq22UX5eoo2B5N1UjE58e7
        5rNCMZUkW65wOmIvhTKSQ9E=
X-Google-Smtp-Source: APBJJlHFv65dpwdDlXHc1S1do0ox2bI1FqJgnaXuRm9AsUbJavHFC6FylCBkYWlJ4qg1it4qKWftlA==
X-Received: by 2002:a05:6a20:324d:b0:12c:b10d:693d with SMTP id hm13-20020a056a20324d00b0012cb10d693dmr8673964pzc.6.1690230416097;
        Mon, 24 Jul 2023 13:26:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:26:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 04/12] scsi: ufs: Rename a function argument
Date:   Mon, 24 Jul 2023 13:16:39 -0700
Message-ID: <20230724202024.3379114-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch suppresses the following W=2 warning:

drivers/ufs/core/ufs-hwmon.c:130:49: warning: declaration of ‘_data’ shadows a global declaration [-Wshadow]

Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-hwmon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-hwmon.c b/drivers/ufs/core/ufs-hwmon.c
index 101d7082446f..34194064367f 100644
--- a/drivers/ufs/core/ufs-hwmon.c
+++ b/drivers/ufs/core/ufs-hwmon.c
@@ -127,7 +127,8 @@ static int ufs_hwmon_write(struct device *dev, enum hwmon_sensor_types type, u32
 	return err;
 }
 
-static umode_t ufs_hwmon_is_visible(const void *_data, enum hwmon_sensor_types type, u32 attr,
+static umode_t ufs_hwmon_is_visible(const void *data,
+				    enum hwmon_sensor_types type, u32 attr,
 				    int channel)
 {
 	if (type != hwmon_temp)
