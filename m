Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2D3C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhKXAzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:45 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:42904 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhKXAzp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:45 -0500
Received: by mail-pj1-f53.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so951538pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=echsw8eGcozK4R45uI095Y7j4xXG0m/T3vBvXXi680I=;
        b=fTieeEtbr4PalpJ9OcQX7joy36QGOccWLE8MWnco88VN9ozGfKPZsjXIny6xoBvnyc
         9IqTi9ppC6OodQbXPBvN8iLUWQl8X2v5SQBPD3ir+Z9fzZKQyt1eCJsnUKO02DPsV62v
         8p3BbMG+z3pVUxRYCLwZ7D0zQGkeqxn4aGIgKIR4+JlWhgqPpYB/29/+pEu2l8uSEtfj
         hLJrxl6AXo7/ijp5u05fvNKIzafwRwJNQHNDPDX41/TOBK0wfwa2pg5kKA4jzaTETmH5
         yxuHT00UymcdVp3Pzr/ypfAI2pIOZnZX3z7UPB7xNFnwGY/8ZTByR0AmTG+DoXjHnCdF
         e7IA==
X-Gm-Message-State: AOAM5308GtieoojuaF9ZM0BUniHzPFI2ahy509V9M6cnC5jVunQg/+4M
        U9VJiuH5z0z/FRGoFiGnLZY=
X-Google-Smtp-Source: ABdhPJwY73yUN4yszPlS4X3dO+XPYrAoxR3Jge4yUXSYcIEGxdklsBYDUiwgSj8Cu1rgaJGuqXX9vg==
X-Received: by 2002:a17:90a:312:: with SMTP id 18mr9347537pje.178.1637715156415;
        Tue, 23 Nov 2021 16:52:36 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:35 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 08/13] scsi: dc395x: Fix a kernel-doc warning
Date:   Tue, 23 Nov 2021 16:52:12 -0800
Message-Id: <20211124005217.2300458-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
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
