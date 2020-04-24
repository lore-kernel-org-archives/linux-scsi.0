Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B17C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7AEE20700
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 11:37:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=synopsys.com header.i=@synopsys.com header.b="YAHqjp9j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgDXLhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:37:24 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:43894 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726699AbgDXLhX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 07:37:23 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 01EDEC033A;
        Fri, 24 Apr 2020 11:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1587728243; bh=t1u/b9URLHxzkXkdDqsLLKlZ2VysHQq+blYp3IVJB48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=YAHqjp9j9vqUJbss9NrRoNXdDkxh3Qt39HOaGn1P4FILyYfyuvuJ2c9JLPbJ4Tn8l
         27mtj/0ePhPpH2YvVYevSyptLdRupfhyxv3stzt3sfqBcLBID+ba04xKG965VndSAi
         FuJq26K0o0iGsn+NBn/zaELx0ODTOeyokT0mXyPjGXwCTS0PripM6IFRiAj9VMcxeM
         Vd0Iut/Bo76pnRf8T2RdPFQ/CqZphLlKSO20Y0TJrttjhuzFwZTpAreKZeSiNeZauG
         G/6DiCfH3CyevzB6p4HG64IRjjJvr7P2ujRr2WYynDoa6pz8y2zkVuANTbk12vn7V6
         9oSPncOcRwKEQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 78A1AA006E;
        Fri, 24 Apr 2020 11:37:21 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-scsi@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] MAINTAINERS: Change Maintainers for SCSI UFS DWC Drivers
Date:   Fri, 24 Apr 2020 13:37:00 +0200
Message-Id: <d886365758727d313571317938909c66edd37317.1587727756.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1587727756.git.Jose.Abreu@synopsys.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1587727756.git.Jose.Abreu@synopsys.com>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pedro Sousa is no longer with Synopsys. Joao Lima and me have been
working internally with our UFS Controller so we are able to help and
we are volunteering as Maintainers for UFS DWC Drivers.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Joao Lima <Joao.Lima@synopsys.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: linux-kernel@vger.kernel.org
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e64e5db31497..61c6579e7d80 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17307,7 +17307,8 @@ F:	Documentation/scsi/ufs.rst
 F:	drivers/scsi/ufs/
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
-M:	Pedro Sousa <pedrom.sousa@synopsys.com>
+M:	Joao Lima <Joao.Lima@synopsys.com>
+M:	Jose Abreu <Jose.Abreu@synopsys.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ufs/*dwc*
-- 
2.7.4

