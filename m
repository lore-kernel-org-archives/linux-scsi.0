Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E6FC7EE30
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 21:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjERV2D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 17:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjERV16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 17:27:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C75E7A;
        Thu, 18 May 2023 14:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/dGKOewJAmOcYSjkfhyPC7jXDAV2xPNJS9LK8CSYaDQ=; b=avhYR1FclZw6oA0QtM65kfp8dV
        2M+kO+CjxcaVkepedUSgdL0N58jRshCal/vOSeRtlnzzN/c3DE68AWzbNVjRKeLWMUJZKY6atbbRY
        I8wKec5DKZ1DyEvCDtm78nAXm6Aao7mfSyHoro6BFVKE3kbHBc60yefZG/W6zbErQeLilRpVcQ1rv
        5Q89kosd+eoSwXUhbb9ji515w1uaSfvbGuTbfgxTw+HBgEiKuXRAlKs4yBpgTX1iM/9VRNfjOlYsh
        H0YSNaCurmA9X8pOLoLHY8loeD5GEKx9tE11COaZ0VmZY0Exq/17rp/6RObFScoNW0L+rze7dEMFp
        WIQav5aA==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzlAA-00EFRV-2b;
        Thu, 18 May 2023 21:27:54 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, Gerd Knorr <kraxel@bytesex.org>
Subject: [PATCH 04/11] Docs/scsi: scsi-changer: shorten the chapter heading
Date:   Thu, 18 May 2023 14:27:42 -0700
Message-Id: <20230518212749.18266-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518212749.18266-1-rdunlap@infradead.org>
References: <20230518212749.18266-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the heading be concise yet still descriptive.
This makes the subsystem table of contents more readable (IMO).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Gerd Knorr <kraxel@bytesex.org>
---
 Documentation/scsi/scsi-changer.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -- a/Documentation/scsi/scsi-changer.rst b/Documentation/scsi/scsi-changer.rst
--- a/Documentation/scsi/scsi-changer.rst
+++ b/Documentation/scsi/scsi-changer.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-========================================
-README for the SCSI media changer driver
-========================================
+=========================
+SCSI media changer driver
+=========================
 
 This is a driver for SCSI Medium Changer devices, which are listed
 with "Type: Medium Changer" in /proc/scsi/scsi.
