Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E33C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353257AbhK2Tvn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:43 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:39589 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347495AbhK2Ttm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:42 -0500
Received: by mail-pf1-f174.google.com with SMTP id i12so18029040pfd.6
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qhobAcdyo1e28tDZZU6//79J1mh/4UC8Q7hU3IoeFhQ=;
        b=k2df5pcuNDMFIYbXfXxhzC/3FDnMZPw9CQO+3rmb2zzwXqNwBOlVXJlKdVc76IELti
         CwR1gitGyNFWx48kpZSbKcU4WPhdsLzfoG3iskwH2LEgwhC8WUQA1QNwb/sO2RSDJz0S
         oS4PH7siscjUcZgcDhh2FwGrKMw1MyAQ8F6w4pGdgmdJ7QCmRSn/jEi3SeN1o2h7vMHu
         fcZR663yxW4zPsaRPZXz7G/jAv7oETDTCdJVX1ou3bPzv2ILwrSl570dXWG8mc3v6mTJ
         IftQqQEBJZWYnYGaOULj/EIIUr9njdcqTS4am3zWt/wgq/kGuSowOCbSppw6x1UHwcZ8
         ftlQ==
X-Gm-Message-State: AOAM533042ZgK/t/x4wdOvJ071W3OgDZAsOQcNzduaD2EBR5e2jUzvRM
        Z1Zg1WM4OG3YGueDDvXGHwTS1Zr1pbk=
X-Google-Smtp-Source: ABdhPJxF1pAwEfbbZyV84Dv7aupnrs16hscRHEIu0mvdfIDT+OQzb8YgYU+kdO49FIoB6Sx6twV3qw==
X-Received: by 2002:a05:6a00:17a4:b0:49f:c0c0:3263 with SMTP id s36-20020a056a0017a400b0049fc0c03263mr41989336pfg.81.1638215184641;
        Mon, 29 Nov 2021 11:46:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:24 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        kernel test robot <lkp@intel.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 06/12] scsi: bfa: Declare 'bfad_im_vport_attrs' static
Date:   Mon, 29 Nov 2021 11:46:03 -0800
Message-Id: <20211129194609.3466071-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

'bfad_im_vport_attrs' is only used in one source file. Hence declare this
array static.

Fixes: e73af234a1a2 ("scsi: bfa: Switch to attribute groups")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index c8b947c16069..f46989bd083c 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -981,7 +981,7 @@ const struct attribute_group *bfad_im_host_groups[] = {
 	NULL
 };
 
-struct attribute *bfad_im_vport_attrs[] = {
+static struct attribute *bfad_im_vport_attrs[] = {
 	&dev_attr_serial_number.attr,
 	&dev_attr_model.attr,
 	&dev_attr_model_description.attr,
