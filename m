Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7329EE3F3F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 23:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbjILXF6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 19:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjILXF6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 19:05:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8AA10CC
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 16:05:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64618C433C8;
        Tue, 12 Sep 2023 23:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694559954;
        bh=n1Q3V5BSG2rFnWlWtLVDkqZceZKZOCMD6tNn4ZEgoj4=;
        h=From:To:Subject:Date:From;
        b=hcZxlvB84lVzeZhJ9xGX1NvgpKLEZ5lqohBIvobYi1x3oJhYJbycAkv2gErkQSnA/
         J+f/CDFL1bqVxcywf/dKkfYN2ccC7rj3cLUUZ3Gteqp+ebxQwTVosNgPKnW/4A+ser
         8+jpXvZpvc2hbAPwDvxevD+6MeoF5AJeDtSjBXMwFDE4FDmwjJ6UAGLbifH84twQMa
         Nd9QCZs3W2q9lfrVaXthtWY7Yu0kopW1IoMjYEynshjZP4h36V5YkzxGnennXLFtGk
         tcYn4vPT0Br6ddLXcB1eVJOWjwVuBix/aomjmVmeZuqNssKpkB+dlhgSpkCeJYJE36
         xpFkcQv68wSWg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 0/3] Minor cleanups
Date:   Wed, 13 Sep 2023 08:05:48 +0900
Message-ID: <20230912230551.454357-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

3 patches to cleanup libsas functions declarations. No functional
changes.

Changes from v2:
 * Added argument name to sas_discover_event() in patch 1
 * Removed repeated word "used" from commit message of patch 3
 * Added Johannes' review tag

Changes from v1:
 * Added sas_init_dev() declaration change to patch 1
 * Added John's review tag

Damien Le Moal (3):
  scsi: libsas: Move local functions declarations to sas_internal.h
  scsi: libsas: Declare sas_set_phy_speed() static
  scsi: libsas: Declare sas_discover_end_dev() static

 drivers/scsi/libsas/sas_discover.c |  2 +-
 drivers/scsi/libsas/sas_init.c     |  4 ++--
 drivers/scsi/libsas/sas_internal.h | 12 ++++++++++++
 include/scsi/libsas.h              | 17 -----------------
 4 files changed, 15 insertions(+), 20 deletions(-)

-- 
2.41.0

