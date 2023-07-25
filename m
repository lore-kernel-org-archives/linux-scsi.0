Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D3FC00528
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 16:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjGYQTl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 12:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjGYQTh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 12:19:37 -0400
Received: from so254-32.mailgun.net (so254-32.mailgun.net [198.61.254.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8E59B
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 09:19:21 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1690301960; x=1690309160; h=Content-Transfer-Encoding: MIME-Version:
 References: In-Reply-To: Message-Id: Date: Subject: Subject: Cc: To: To:
 From: From: Sender: Sender; bh=p4FrMSJtYb7PqmV/oxmGnwwCR88Iaj/wEfwZO+g0Tv8=;
 b=mCmaQKmtA65OfvkAO2bX/pTtpq5Y5em+/AkRnWMEu0ubgTG7Fu7A9KT5EAygQm2IrnAS0jl+KHbuIAKGgPnf/ooc0NIYOZnytOedwlDvcky8y4cuM90gsVthtGZ5+QrtDhtyAFqdlqJERsNqqwrSGrhSFXuP5ZLVfPGa1WN8mF/V/spbLWEB8ycZ8w+dMG25rs1qxZTqfHAXZcnBSO9X68Il+zACskjzDvxoaP7hHIcjeXSHm2oCR4HTaM60RKOTnv9vLoD6cKi2nNyN6RQHG3UbYRRVszkyuP/ORlNvX8rv9aAZZKfuVa7FMT5XXwk/quomDqSkdI1ZKKyx3y+b7g==
X-Mailgun-Sending-Ip: 198.61.254.32
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by d53bb90da10c with SMTP id
 64bff4db13929ab6cbff578a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 25 Jul 2023 16:14:19 GMT
Sender: james@equiv.tech
From:   James Seo <james@equiv.tech>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     James Seo <james@equiv.tech>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] scsi: mpt3sas: Fix an outdated comment
Date:   Tue, 25 Jul 2023 09:13:29 -0700
Message-Id: <20230725161331.27481-5-james@equiv.tech>
In-Reply-To: <20230725161331.27481-1-james@equiv.tech>
References: <20230725161331.27481-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

May reduce confusion for users of MPI2_CONFIG_PAGE_IO_UNIT_3::GPIOVal[].

Fixes: a1c4d7741323 ("scsi: mpt3sas: Replace unnecessary dynamic allocation with a static one")
Signed-off-by: James Seo <james@equiv.tech>
---
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index f07215fbc140..62bde43f64a8 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -974,7 +974,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_1 {
 
 /*
  *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- *one and check the value returned for GPIOCount at runtime.
+ *36 and check the value returned for GPIOCount at runtime.
  */
 #ifndef MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX
 #define MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX    (36)
-- 
2.39.2

