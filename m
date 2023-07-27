Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A251EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjG0Tqj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjG0Tqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:46:39 -0400
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C3D2D75
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:46:37 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-77acb04309dso55749239f.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487196; x=1691091996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NgP9kTELiaBKghRfMtDGa8iBIceeOq9wmww7zJ0qyNY=;
        b=Okh/hqjGeDhOsDs9oY4bii1lxpHbBY+5kHTO0JKbhFOvUwjJbGRwFIzRRCIHLdRF4X
         AAaewTFuNmdsSvOWz/zWoxOSgAp2tuzg8aFDXp/6HWkO07hUNbHEMjvIfOMYMQOlQecq
         /1dIpBqB3/6xoDWDkZlOXI/Ce9jU4SCg5cO3paBOWrykp8ddPEKMFpM6vVpavEmM5MDp
         0wcuVBKWvvmmaYIZcJoDBTyT7GskcSMXQF54YMppDWnAjJJ8DufEYRAYuKEpugljgQAT
         oxJzL9iqYI4vIY3vpTBF8C2fxpihjnER3ZC5VU9v6IxoM+xhc9tl8tzHWtDPBtyjgcPp
         uzfQ==
X-Gm-Message-State: ABy/qLZmYYpWGCfrtLpy8nRsN0XLTAxVOJb6ToOT9M1+Ci6olAWiN4Na
        DNgxlt67remx60e8WpHz5jo=
X-Google-Smtp-Source: APBJJlFPLcgA72leXFvojULYWXZpZlyKrUySnzJpy2rOw0gr34I0XYhAGEPYlwhTanr5UF+Fy+uNZA==
X-Received: by 2002:a05:6e02:1212:b0:348:f511:549 with SMTP id a18-20020a056e02121200b00348f5110549mr408198ilq.16.1690487196313;
        Thu, 27 Jul 2023 12:46:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:46:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 04/12] scsi: ufs: Rename a function argument
Date:   Thu, 27 Jul 2023 12:41:16 -0700
Message-ID: <20230727194457.3152309-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch suppresses the following W=2 warning:

drivers/ufs/core/ufs-hwmon.c:130:49: warning: declaration of ‘_data’ shadows a global declaration [-Wshadow]

Reviewed-by: Avri Altman <avri.altman@wdc.com>
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
