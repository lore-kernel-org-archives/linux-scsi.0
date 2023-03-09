Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858D6C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCITcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjCITbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:43 -0500
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7262F31F2
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:45 -0800 (PST)
Received: by mail-pg1-f169.google.com with SMTP id bn17so1708878pgb.10
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0BLcDBB76INQrERMmuujqXhkyY7InYZFQK9oYODTYwQ=;
        b=7t1T03yIpkZEmT32Cy5USUBxX+pV2n/DuHwS3kdXu6k+cbdSBBF3OjFVwi+1VeGjCE
         aoBKlUwXiqqepThr4YSZMvJjgSrgGg04FqNpoYhVBIzvpPqiuKlevQbL/eCeaKJxgolB
         dJOf9+aIAv/5wPgfHjSUnxNjuGBN45YNbJ4MMVNL+XrJ2Zc0SupEsWdcRXcdrfonG0Kp
         5WtQ54AvL1lxI8WqM+g9bGLf6P2MlK1c+mASgfDD+iP7lF0KRDi0+UjFugWliptTfhSt
         EnhNfXGZ133pEFq365ByQwGmy1PhdAlauc/iUuY06GV2GJ4Wnqb1/2H9jIJygFmx5QVq
         xN0w==
X-Gm-Message-State: AO0yUKXtMprXhI6NGwITT65pRTXGbb+n7AqM3RAnF+Q6QsrmbtVNoeLj
        eDiAafO4ktVc5eKhjr4O/cv5QubYUWUEng==
X-Google-Smtp-Source: AK7set/qK5x9sl3Fhwf6v3ApzuzFo3E0/rhcq/E6g4ZNmmY2ijV+2iJPgg0R2IizLMW0Ogrxqf5eUw==
X-Received: by 2002:a62:7b94:0:b0:5ce:ef1b:a80 with SMTP id w142-20020a627b94000000b005ceef1b0a80mr18896249pfc.32.1678390245130;
        Thu, 09 Mar 2023 11:30:45 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 82/82] scsi: core: Update a source code comment
Date:   Thu,  9 Mar 2023 11:26:14 -0800
Message-Id: <20230309192614.2240602-83-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure that the 'proc_name' comment correctly reflects its new role.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0f29799efa02..f3e071fd61bd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -365,7 +365,7 @@ struct scsi_host_template {
 
 
 	/*
-	 * Name of proc directory
+	 * Name reported via the proc_name SCSI host attribute.
 	 */
 	const char *proc_name;
 
