Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC153C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhKXAzv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:51 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:42912 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbhKXAzt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:49 -0500
Received: by mail-pg1-f174.google.com with SMTP id t4so561179pgn.9
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k3aRkXwcHbUrav//xi729orhtu49BIZsPxsJGGDFykc=;
        b=ABQ/X/yyiy9/Mab5d9+3ScYVcI2GEkDdJGAAT9Ry7dOfM6CUO29RrXvdBfYZELJGBt
         QKR3wjW70JE1TwPEo9q6VMaO/ko2M8ngw8I64pEN50TFFCfHB/QjZkQtuJdXs0DqQMQp
         awUIXPAea4H0e9RBw19g8pO2fET93cs71iYVKkm+icNaxXXEtM96HPssEgLszFSt6IgD
         nquqP2bv8aNeviOxUYxClDq+PUmdNHQm0zdQpd0UlejjYVaGpBgGdyvRgnWUXgl6go5F
         Ovd6QilQaUV2suziKb9zZEWCVJQ3l/Ofww2UrbTMU1QUeiPhQGVZ0tpuJI1uox8kvj+X
         kdVw==
X-Gm-Message-State: AOAM531c7tBxuww/P2cD5oObDnRySXfg+/g8yuI1E4GkfJjfztd/Qcj4
        koNy3jNg99OI9Wfo9cNC5FPQhixMzHYnlQ==
X-Google-Smtp-Source: ABdhPJy2iS7whgsCywhlN1n1bvDkree+ItJH2YEBnR337BmHGIrhH0Uu5sDHjALlIyqAwgSo1Ooc5Q==
X-Received: by 2002:aa7:8109:0:b0:4a2:a98e:9020 with SMTP id b9-20020aa78109000000b004a2a98e9020mr1763842pfi.61.1637715160333;
        Tue, 23 Nov 2021 16:52:40 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:39 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        kernel test robot <lkp@intel.com>,
        Radha Ramachandran <radha@google.com>,
        Viswas G <Viswas.G@microchip.com>
Subject: [PATCH 11/13] scsi: pm8001: Fix kernel-doc warnings
Date:   Tue, 23 Nov 2021 16:52:15 -0800
Message-Id: <20211124005217.2300458-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
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
