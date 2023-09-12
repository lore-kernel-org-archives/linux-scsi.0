Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56810CA0ECE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 07:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjILHrZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjILHrW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 03:47:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064F8E79
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 00:47:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76DFC433C8;
        Tue, 12 Sep 2023 07:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694504838;
        bh=2q6u2A7TCMqwPT9xtj6tYuNj0vT4pC/MGwiRbRF1Y90=;
        h=From:To:Subject:Date:From;
        b=Rdcrw3schI4iU5AHBbLb3oKYpJdcgZtt8P/qnh0ju2OAPPhKhxHhXtrt3uFdKBQL5
         v1cA2SnOF1Kkg0rVKl+WGT7WrO0f+3kTYX6tJjZiomahTbNdI1qHx5SJsNkfpPv3sw
         rIx/fD1QY4FzAJuZaVjYqd1tGlaR2VilvVPxLdrPC908K3hucD2m5LjEHBDxtABBpk
         n4YFHNLhKdpvYHvEJZJ0zu+XuN91dvskPxpjsl9hdr1Iqe3/qFfsSqtS5V5tR0MDys
         /uv/jZ83QpPCIFFOR3F57qB+i/3uBNYem/bpJlHiGHXsFpldc6u7VNo9+LH/nX22e6
         heP+NqLh9FLfA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/3] Minor cleanups
Date:   Tue, 12 Sep 2023 16:47:12 +0900
Message-ID: <20230912074715.424062-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

3 patches to cleanup libsas functions declarations. No functional
changes.

Damien Le Moal (3):
  scsi: libsas: Move local functions declarations to sas_internal.h
  scsi: libsas: Declare sas_set_phy_speed() static
  scsi: libsas: Declare sas_discover_end_dev() static

 drivers/scsi/libsas/sas_discover.c |  2 +-
 drivers/scsi/libsas/sas_init.c     |  4 ++--
 drivers/scsi/libsas/sas_internal.h | 11 +++++++++++
 include/scsi/libsas.h              | 15 ---------------
 4 files changed, 14 insertions(+), 18 deletions(-)

-- 
2.41.0

