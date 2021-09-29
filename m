Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E61BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 18:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D69ED61465
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 18:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346055AbhI2SZM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 14:25:12 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:33323 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345440AbhI2SZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 14:25:08 -0400
Received: by mail-pf1-f175.google.com with SMTP id s16so2730654pfk.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 11:23:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pq4Xve0qA+tCFA6eu2Au+Jh835nfS9pbHgTbNXcm76Q=;
        b=2JJnDyp3OSfzp3p0ZqBFh572thIVu049+ePxY2vuKjW+ta3FEGgyCOi7Ca2YL2monL
         YX07EnhMl8dPAcBLEZPidNhVevMccDiTFkl5A1Y1wOiMA7Rw6aWXEBOCZiho5Q33h7F+
         yd5a5eBexvRmuiFlmtIV3co/5SvJL9pxpv49kxCc0YfzmpO1OeTXoFDNo+uS2pja7XlH
         wGbuE1iBIwu9SYBm3AKaQX118K4D2yPuejdhX3AZldsQk0XS/Rf5StOtMuftU5wbgKn6
         hUcdfJTW0nH0bnGzPrjn/U0cUWkrEd0yVXumZFcEsrWkGlZ/6vILPnXnRZ9xR1HrshSP
         gW8w==
X-Gm-Message-State: AOAM532ztGYpXOwQGuUlfGJdaIFQGRU42ntxHlcfXTUm6BzxcHqr0jfh
        923ZB4IZFwRjwAr1qCRUx54=
X-Google-Smtp-Source: ABdhPJw6PcVZFAME4WxgkgkRjnf1JyraGnCp5N5vmbMReJk4M/TBrko37J+xJkrN6W+P1p9MhyuL+w==
X-Received: by 2002:a63:684a:: with SMTP id d71mr1154408pgc.175.1632939806482;
        Wed, 29 Sep 2021 11:23:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f36:4e58:55a1:b506])
        by smtp.gmail.com with ESMTPSA id qe17sm372408pjb.39.2021.09.29.11.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 11:23:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: core: Fix spelling in a source code comment
Date:   Wed, 29 Sep 2021 11:23:18 -0700
Message-Id: <20210929182318.2060489-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The typo in this source code comment makes the comment confusing. Clear up
the confusion by fixing the typo.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: bc85dc500f9d ("scsi: remove scsi_end_request")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 572673873ddf..660ca6226f16 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -949,7 +949,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 
 	/*
 	 * If there had been no error, but we have leftover bytes in the
-	 * requeues just queue the command up again.
+	 * request just queue the command up again.
 	 */
 	if (likely(result == 0))
 		scsi_io_completion_reprep(cmd, q);
