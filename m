Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1098C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 09:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjCVJ1y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 05:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCVJ1x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 05:27:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6385679C
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 02:27:53 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso23036349pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 02:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20210112.gappssmtp.com; s=20210112; t=1679477272;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FQeTeTFky5skaAol2n4vXrcosGiX/c8ISuilp18ejQ0=;
        b=2cFFI+HLeF4277uuvBjJmfWDZMzz3Rzpj1vHUiKs899y0KieftIQiCLOLKsQ4wmBly
         eruDF9nzddnd/0A1pi/WZqWahAhIjPtt3oZKsv+U0nAeR1cpQq6Lv/CcKVXnPOaaUncb
         NMVxfuf2pGXDD7U7T3qUoJdHc2/76LHQMr3yzB3NbyZe8UsiBSti3laf22KIXW+kjntC
         cmMqRaqo7qZv4W+xu2T7eN0mjIP6PJdAAKGao5cGCoS4L9ikcJDgEwN2qpnRLKLk3KZ8
         svLrwcGP+4XdfsvgO7WAquDtz+eNo6edDEX09BVodkDEQTl4khVXnhhRpaaNetohRbr0
         Rspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679477272;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FQeTeTFky5skaAol2n4vXrcosGiX/c8ISuilp18ejQ0=;
        b=f+NT7KHmDtUO+k4w7BXGZzXFnjEFkZgjZXnF7fYiVhp/CWrzZK1DICTsl/zKWXctgJ
         F/RAMLi2yFMvFx7ecR6Jmeo7jOuxBxWkBVogUYmmik1p+/3lGkj0DxFJ5xhvcRGLVt7X
         Ci9/9sWD4WZ+JKitlKWW3zB1hOB9yzqCST+oyIf754tCEDBj6qE0XNrS6qgdDNUiehNA
         6NY2ibRJSQRstf7Wl7+er+bthR/Iby3+eUp/WnOQEMTqF5LiV+JtXU5yaH6PvXsnNO6v
         juiFgsW31PKl0KEmPGOIReEMs37KZBODG8jHAS3fprmiHv2UsF0zeMu1rWBtnn9fOsaM
         p8wQ==
X-Gm-Message-State: AO0yUKVmoA2C0sFq3Xf9Re+WIetn+VzayEN+q7ma76xLRzxRN8VpBIyY
        XokuqdyKSE/O5iPgapFGZ6k3DA==
X-Google-Smtp-Source: AK7set9vi1Kudu+mfwaGAQzzDqcG6Oi4AzoBF2AJW7EP/W22utNw41IONnw/9PDyo3r41Cec+H1Shw==
X-Received: by 2002:a17:902:c949:b0:19c:e405:4446 with SMTP id i9-20020a170902c94900b0019ce4054446mr2787974pla.30.1679477272647;
        Wed, 22 Mar 2023 02:27:52 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id x8-20020a170902820800b0019a7ef5e9a8sm10203309pln.82.2023.03.22.02.27.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Mar 2023 02:27:52 -0700 (PDT)
Message-ID: <8022803536481106bbeca2f8eb33712668f41217.camel@areca.com.tw>
Subject: [PATCH 5/5] scsi: arcmsr: update driver's version to
 v1.50.00.13-20230206
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Thu, 23 Mar 2023 01:27:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ching Huang <ching2048@areca.com.tw>

This patch update driver's version to v1.50.00.13-20230206

Signed-off-by: ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 6af8ae6..ed8d931 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -50,7 +50,7 @@ struct device_attribute;
 #define ARCMSR_MAX_OUTSTANDING_CMD	1024
 #define ARCMSR_DEFAULT_OUTSTANDING_CMD	128
 #define ARCMSR_MIN_OUTSTANDING_CMD	32
-#define ARCMSR_DRIVER_VERSION		"v1.50.00.05-20210429"
+#define ARCMSR_DRIVER_VERSION		"v1.50.00.13-20230206"
 #define ARCMSR_SCSI_INITIATOR_ID	255
 #define ARCMSR_MAX_XFER_SECTORS		512
 #define ARCMSR_MAX_XFER_SECTORS_B	4096

