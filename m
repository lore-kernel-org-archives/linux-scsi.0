Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87756C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 575A020709
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343645AbhA0EVR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:21:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390633AbhAZVEO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Jan 2021 16:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAF2622CE3;
        Tue, 26 Jan 2021 21:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611695012;
        bh=pI7NO1G6lbsrKpcVZj2mLy00XIBQq74wDW2Y+mjP0v0=;
        h=From:To:Cc:Subject:Date:From;
        b=BtJ2r8o7NibHvaqosz5qGDDvoC+oNFtQwoGXdMMWf9femfmyJqkz27Bjz6/uonm7d
         7AmgLqls9SrZNFKx42DPQeEjYW+fpJKMyWzN4LhzeZZ+4f3dSHUIcZ0aAlf2s3K6ly
         p3lcQo3uRlLQfB6uGOg53oRrskUagoawNPZsKfa0B2sx9GtspXFw907hmnesrkHlAF
         UgcgTICG53xCHRnYFFyPDtQ/t7mWzQ9XkjfpNuZU/S9xm5B5zeP0wp5wDL/tMIs7f0
         dCc5l1Pzejp3WScWJUOvmbXTefh2mB/u8La+paZN6UrKbss/v7VcGdIDgVnkUsXJCg
         KXAv3glQPAejA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] scsi: message: fusion: fix 'physical' typos
Date:   Tue, 26 Jan 2021 15:03:28 -0600
Message-Id: <20210126210328.2918631-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Fix misspellings of "physical".

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/message/fusion/lsi/mpi_cnfg.h      | 2 +-
 drivers/message/fusion/lsi/mpi_history.txt | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index 178f414ea8f9..3770cb1cff7d 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -313,7 +313,7 @@
  *                      define.
  *                      Added BIOS Page 4 structure.
  *                      Added MPI_RAID_PHYS_DISK1_PATH_MAX define for RAID
- *                      Physcial Disk Page 1.
+ *                      Physical Disk Page 1.
  *  01-15-07  01.05.17  Added additional bit defines for ExtFlags field of
  *                      Manufacturing Page 4.
  *                      Added Solid State Drives Supported bit to IOC Page 6
diff --git a/drivers/message/fusion/lsi/mpi_history.txt b/drivers/message/fusion/lsi/mpi_history.txt
index fa9249b4971a..2f76204fa1b0 100644
--- a/drivers/message/fusion/lsi/mpi_history.txt
+++ b/drivers/message/fusion/lsi/mpi_history.txt
@@ -513,7 +513,7 @@ mpi_cnfg.h
  *                      define.
  *                      Added BIOS Page 4 structure.
  *                      Added MPI_RAID_PHYS_DISK1_PATH_MAX define for RAID
- *                      Physcial Disk Page 1.
+ *                      Physical Disk Page 1.
  *  01-15-07  01.05.17  Added additional bit defines for ExtFlags field of
  *                      Manufacturing Page 4.
  *                      Added Solid State Drives Supported bit to IOC Page 6
-- 
2.25.1

