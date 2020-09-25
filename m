Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD03AC47429
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A3DB20809
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 16:19:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KzhkwtZA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbgIYQT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:19:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729493AbgIYQTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 12:19:43 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601050782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zuPbP3Dh/kHk7MosTe8SMu7B3ELSVFAGeHkzLThiUQY=;
        b=KzhkwtZAS6P+PrK000zAyWGM3gUnZShyreOBT7iSo71CdBzNebJKmdMEXKjkgrlv7ze0fx
        E0u9jIFHVNmeFbQp1upkc+RKQgv8T2HFoIYO5jLfz/DsWlLt7RoZtOe+rEzSpQo1qwv4pe
        OhyjYbyuiXVxdaSE8JaqXF0/rjWTlWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-UiiPqmYmMrCQGJeUQVwRfA-1; Fri, 25 Sep 2020 12:19:40 -0400
X-MC-Unique: UiiPqmYmMrCQGJeUQVwRfA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E617D10BBED3;
        Fri, 25 Sep 2020 16:19:38 +0000 (UTC)
Received: from sulaco.redhat.com (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2807A5D9DC;
        Fri, 25 Sep 2020 16:19:38 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [v5 07/12] libata: Make ata_scsi_durable_name static
Date:   Fri, 25 Sep 2020 11:19:24 -0500
Message-Id: <20200925161929.1136806-8-tasleson@redhat.com>
In-Reply-To: <20200925161929.1136806-1-tasleson@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Tony Asleson <tasleson@redhat.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 194dac7dbdca..13a58ed7184c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1086,7 +1086,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 	return 0;
 }
 
-int ata_scsi_durable_name(const struct device *dev, char *buf, size_t len)
+static int ata_scsi_durable_name(const struct device *dev, char *buf, size_t len)
 {
 	struct ata_device *ata_dev = container_of(dev, struct ata_device, tdev);
 
-- 
2.26.2

