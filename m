Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1036C433E7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 00:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 726E9208B3
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 00:32:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MLDpyQde"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgGSAcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 20:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgGSAcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 20:32:39 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9AEC0619D2;
        Sat, 18 Jul 2020 17:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=X/BeYNHbvuIeQ0ZExsQBR4yZ010bnR0S0gUEMzv44uw=; b=MLDpyQde8mPq/F2me6No8c5r5P
        JYCCM5+1CS1c3iimLosVO+SzIAKU2mvxBYFx5+MITCiTPN7KKsqbvNV4boZqhWEXr9nU1a58mebF4
        NtvKXlq8be1JDCDeCGatbXpXheHC6HUX8KGiLF3Eka2ayI9XVtRXMpe3IaGBl/7ctxnyPFYCKRuqc
        +9URYOOa31k6UwE5J8iTD5Td3CyeKYpxwDM0+Mgal1T/6mzL8NM4lX6PW8753Vr7NXD3pNk6OE2nx
        RXU8mZIWUapIZXMQQJZZodFI+wJF1SLuGyt8TLYjFKlzVrET9m1J/EgbjyMz/460jfV3ouYcx2KFF
        8neXgSVQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwxFs-00033r-E0; Sun, 19 Jul 2020 00:32:37 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] SCSI: scsi_transport_iscsi.h: drop a duplicated word
Date:   Sat, 18 Jul 2020 17:32:32 -0700
Message-Id: <20200719003232.21301-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop the repeated word "the" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 include/scsi/scsi_transport_iscsi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200717.orig/include/scsi/scsi_transport_iscsi.h
+++ linux-next-20200717/include/scsi/scsi_transport_iscsi.h
@@ -57,7 +57,7 @@ struct iscsi_bus_flash_conn;
  *			When not offloading the data path, this is called
  *			from the scsi work queue without the session lock.
  * @xmit_task		Requests LLD to transfer cmd task. Returns 0 or the
- *			the number of bytes transferred on success, and -Exyz
+ *			number of bytes transferred on success, and -Exyz
  *			value on error. When offloading the data path, this
  *			is called from queuecommand with the session lock, or
  *			from the iscsi_conn_send_pdu context with the session
