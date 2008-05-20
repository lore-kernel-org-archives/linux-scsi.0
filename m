From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 5/6] mpt fusion : Setting intial period to 0xFF instead of 0xA
Date: Wed, 21 May 2008 01:01:11 +0530
Message-ID: <20080520193111.GF11542@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42809 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbYETTjt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 15:39:49 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m4KJa3w3020182
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 12:36:04 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

The initial period is set to 0xFF

Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index bd3a3be..dae3936 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -447,6 +447,7 @@ static int mptspi_target_alloc(struct scsi_target *starget)
 	spi_max_offset(starget) = ioc->spi_data.maxSyncOffset;
 
 	spi_offset(starget) = 0;
+	spi_period(starget) = 0xFF;
 	mptspi_write_width(starget, 0);
 
 	return 0;
