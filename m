Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F36C0C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354785AbhK2Tvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:49 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:40529 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244671AbhK2Tts (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:48 -0500
Received: by mail-pl1-f177.google.com with SMTP id v19so13019883plo.7
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EKggP/kC93g46/vrOUZekUVrmPiltvkzfuihuVvN0rU=;
        b=aBfrysigNSGxNwLmOurzOrCl33oFRgHuAAW4Tai1FUZf8HhFNRgFAqLo4obZQeWuuo
         tIFSWAVNMi01e+1vKIlyJUzVjaI0QZC+Y/zAZhkgCHfvwNDkuAWVbKxI4JQH8hzNrIqs
         RxjAEQKHfu3cSN0Q0JT3jQEXCUHEkWJMGfcwyiUf/qSQ7l06kSJ3HRoABgnCySD7othi
         ejPnrqvd/PMrIsRzsW6IXa6oXmFEoQXF1igBWtWZXt5H9+hxOXoG29Wx1yDDgJ60lIaD
         A7ZjW+5cethbCu8mKoddiCd49cBzWk3mF2iJxf2LcKjVvF+mBPP10rLDIpvi30T9+bV1
         YDBQ==
X-Gm-Message-State: AOAM532gm0apGlQIShEfV7WHmai1JclTTKSMOLGa5B7SMnx9n47E92A8
        qXql63CXgw3yHR+joml7Nd9oLPJDMg4=
X-Google-Smtp-Source: ABdhPJyVGzb8P7H7Mh0C0WZ2KoCT4X2IbO7ZIdY66G8NyU66QnJoGvDzlt9GPx28Uvb3EfZzYEcXkg==
X-Received: by 2002:a17:90b:1a86:: with SMTP id ng6mr200381pjb.142.1638215190269;
        Mon, 29 Nov 2021 11:46:30 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        kernel test robot <lkp@intel.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>
Subject: [PATCH v2 10/12] scsi: pm8001: Fix kernel-doc warnings
Date:   Mon, 29 Nov 2021 11:46:07 -0800
Message-Id: <20211129194609.3466071-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warnings:

drivers/scsi/pm8001/pm8001_ctl.c:900: warning: cannot understand function prototype: 'const char *const mpiStateText[] = '
drivers/scsi/pm8001/pm8001_ctl.c:930: warning: Function parameter or member 'attr' not described in 'ctl_hmi_error_show'
drivers/scsi/pm8001/pm8001_ctl.c:951: warning: Function parameter or member 'attr' not described in 'ctl_raae_count_show'
drivers/scsi/pm8001/pm8001_ctl.c:972: warning: Function parameter or member 'attr' not described in 'ctl_iop0_count_show'
drivers/scsi/pm8001/pm8001_ctl.c:993: warning: Function parameter or member 'attr' not described in 'ctl_iop1_count_show'

Acked-by: Jack Wang <jinpu.wang@ionos.com>
Fixes: 4ddbea1b6f51 ("scsi: pm80xx: Add sysfs attribute to check MPI state")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 397eb9f6a1dd..41a63c9b719b 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -889,14 +889,6 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
 static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
 	pm8001_show_update_fw, pm8001_store_update_fw);
 
-/**
- * ctl_mpi_state_show - controller MPI state check
- * @cdev: pointer to embedded class device
- * @buf: the buffer returned
- *
- * A sysfs 'read-only' shost attribute.
- */
-
 static const char *const mpiStateText[] = {
 	"MPI is not initialized",
 	"MPI is successfully initialized",
@@ -904,6 +896,14 @@ static const char *const mpiStateText[] = {
 	"MPI initialization failed with error in [31:16]"
 };
 
+/**
+ * ctl_mpi_state_show - controller MPI state check
+ * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read-only' shost attribute.
+ */
 static ssize_t ctl_mpi_state_show(struct device *cdev,
 		struct device_attribute *attr, char *buf)
 {
@@ -920,11 +920,11 @@ static DEVICE_ATTR_RO(ctl_mpi_state);
 /**
  * ctl_hmi_error_show - controller MPI initialization fails
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
  */
-
 static ssize_t ctl_hmi_error_show(struct device *cdev,
 		struct device_attribute *attr, char *buf)
 {
@@ -941,11 +941,11 @@ static DEVICE_ATTR_RO(ctl_hmi_error);
 /**
  * ctl_raae_count_show - controller raae count check
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
  */
-
 static ssize_t ctl_raae_count_show(struct device *cdev,
 		struct device_attribute *attr, char *buf)
 {
@@ -962,11 +962,11 @@ static DEVICE_ATTR_RO(ctl_raae_count);
 /**
  * ctl_iop0_count_show - controller iop0 count check
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
  */
-
 static ssize_t ctl_iop0_count_show(struct device *cdev,
 		struct device_attribute *attr, char *buf)
 {
@@ -983,11 +983,11 @@ static DEVICE_ATTR_RO(ctl_iop0_count);
 /**
  * ctl_iop1_count_show - controller iop1 count check
  * @cdev: pointer to embedded class device
+ * @attr: device attribute (unused)
  * @buf: the buffer returned
  *
  * A sysfs 'read-only' shost attribute.
  */
-
 static ssize_t ctl_iop1_count_show(struct device *cdev,
 		struct device_attribute *attr, char *buf)
 {
