Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10849C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 15:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE76721D7D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 15:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfLSPao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 10:30:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:44600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbfLSPao (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Dec 2019 10:30:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86451B1AD;
        Thu, 19 Dec 2019 15:30:42 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add lists to cdrom driver
Date:   Thu, 19 Dec 2019 16:30:34 +0100
Message-Id: <20191219153034.22344-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kernel maintainers are wondering why people don't send cdrom patches to
any lists they follow.

It is because they added no lists to the cdrom entry in MAINTAINERS,
obviously.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a049abccaa26..9e4eff21ef02 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16923,6 +16923,8 @@ F:	scripts/unifdef.c
 UNIFORM CDROM DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
 W:	http://www.kernel.dk
+L:	linux-scsi@vger.kernel.org
+L:	linux-block@vger.kernel.org
 S:	Maintained
 F:	Documentation/cdrom/
 F:	drivers/cdrom/cdrom.c
-- 
2.23.0

