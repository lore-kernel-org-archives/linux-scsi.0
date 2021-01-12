Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD24C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED03E2311F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbhALLHg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:07:36 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45096 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbhALLHf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:07:35 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610449612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zi87JU1wtYK7u/9EdBeQmfwuSvWpL6Dl6md8k/4q3TA=;
        b=sWIcfkk6tSMZI4gBOWGlu+K/lREk/A+dec4OnnzPh9RZw54e2Jw+JdWM+n8b5uwC8fRDiR
        ZCsZk7mv9V6mIL5SW7QltGJpHxamA1Zw+FXCZFHb3SQiS5RWqm5HDVG93BEf8N411pewfl
        c1mODZat3TWhGTlNgEZ4PIgz1rJtgiwR6aOACI/taNa0URq1iMmqEebLm5qrdTlDSIDwx7
        VEwSrvlT5Mt/GncnmZmWgS4r51YsjeCEBlsYsXDQp8U7H0HQZaU7AaUogphSBh5hIqrxJc
        oJRZNDNiU+Qb+LDzshGqpsNIXxyuvGKeRmH/RlMfP16yApjeKyyBcwZaicjqqA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610449612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zi87JU1wtYK7u/9EdBeQmfwuSvWpL6Dl6md8k/4q3TA=;
        b=W32uKRuQ7uHrg+yyImUFw0k3yGR0OP7kHHgDP9/mx47EipBsuQb5RWLiPxVUKoVyq2D52W
        s35k+H9Umol2FlAw==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, intel-linux-scu@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v2 01/19] Documentation: scsi: libsas: Remove notify_ha_event()
Date:   Tue, 12 Jan 2021 12:06:29 +0100
Message-Id: <20210112110647.627783-2-a.darwish@linutronix.de>
In-Reply-To: <20210112110647.627783-1-a.darwish@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ->notify_ha_event() hook has long been removed from the libsas event
interface.

Remove it from documentation.

Fixes: 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: stable@vger.kernel.org
---
 Documentation/scsi/libsas.rst | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index 7216b5d25800..f9b77c7879db 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -189,7 +189,6 @@ num_phys
 The event interface::
 
 	/* LLDD calls these to notify the class of an event. */
-	void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
 	void (*notify_port_event)(struct sas_phy *, enum port_event);
 	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
 
-- 
2.30.0

