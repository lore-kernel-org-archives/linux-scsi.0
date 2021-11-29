Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1759FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353433AbhK2Tvp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:45 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:45985 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378796AbhK2Ttp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:45 -0500
Received: by mail-pl1-f181.google.com with SMTP id b11so13015164pld.12
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=echsw8eGcozK4R45uI095Y7j4xXG0m/T3vBvXXi680I=;
        b=n54o1j9k5sbRI+Q0NZ+XK218EJftCPM7taEjk+9I0zRBokoz2hYYKjL4xmDSXxkSvP
         baMaGmasQ3Q0ZcmjeK+GCR+0lFDbYBB4szaiEJsYz4C2L7XpU8ffIT1g6OjWS9tlmmER
         LDfnnkzdx/XFtTrmybBCYHe4UNk+3nQLdAKLDMpSrf6Z8BGeuRw+HwsGFiD7YA6HWTMv
         ZETOlg7cNmlp0IuozfFBT7/S3KkF8SqYa/8KQwU5/tRqlraak8oJUwZ7rXbrHKlAXzG/
         8edaS3+0QMEOIHQTk8sBqo7D2NivYU+mmEdtXkpSaR3EBsEPj5Uy0JFJNT5Z3y8z217c
         flpg==
X-Gm-Message-State: AOAM530lqe2kDuOjopIjoAEMVqBU+hmDqzjK8/2JhHjSjp2R85Duyssp
        7laE+9L7+fsMisU5dNROB8cDaCLi2yc=
X-Google-Smtp-Source: ABdhPJwEg8wd9W124aHjcW1MrtJKgWVxQqD+CAZG+1h1zZGgvjpf39xhlFEebsOvNwWMyFIormrtQw==
X-Received: by 2002:a17:90b:1c91:: with SMTP id oo17mr134160pjb.193.1638215185942;
        Mon, 29 Nov 2021 11:46:25 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 07/12] scsi: dc395x: Fix a kernel-doc warning
Date:   Mon, 29 Nov 2021 11:46:04 -0800
Message-Id: <20211129194609.3466071-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

drivers/scsi/dc395x.c:964: warning: Excess function parameter 'done' description in 'dc395x_queue_command_lck'

Fixes: af049dfd0b10 ("scsi: core: Remove the 'done' argument from SCSI queuecommand_lck functions")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dc395x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 9b8796c9e634..c11916b8ae00 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -946,7 +946,6 @@ static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
  * layer, invoke 'done' on completion
  *
  * @cmd: pointer to scsi command object
- * @done: function pointer to be invoked on completion
  *
  * Returns 1 if the adapter (host) is busy, else returns 0. One
  * reason for an adapter to be busy is that the number
@@ -959,7 +958,7 @@ static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
  * Locks: struct Scsi_Host::host_lock held on entry (with "irqsave")
  *        and is expected to be held on return.
  *
- **/
+ */
 static int dc395x_queue_command_lck(struct scsi_cmnd *cmd)
 {
 	void (*done)(struct scsi_cmnd *) = scsi_done;
