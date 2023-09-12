Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683CECA0EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjILIxp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjILIxo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:53:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCB9AA
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 01:53:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97D8C433C8;
        Tue, 12 Sep 2023 08:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694508820;
        bh=8s81+F1ZV92ZBsN/IbDcbV+Oam7TJIT4kSpKS+A8Q7A=;
        h=From:To:Subject:Date:From;
        b=IJiv1j4yafkBLR5D/yI3tDPo0izUGO2zyZvbRPKQQ7r3A1W+r5n0zCBaLxEanlw9p
         ZnNicgDnfCRn6mGtqRF9GD+ETToH8ZrEyWI/adEfNat+cqUF6U31jJ2naCInEEcPn8
         +F7wn9yTyJra4R2Yo43Iubq2LPAPfgYC92kMgHrA/3/4SKEB/EOpdnOK+KLull2WNe
         emgmN6kxIQ9tvQUCP36z1xlAuupexoewNXrEVlf1HzhFmOUnlda0Kn44dHgY6U2pyK
         xgyFa9BFtmwymMYDZ1cyTkyGwb3g3soQxDzqQrtCOuOfp+lyvdzUBL+SjwlRVjqgRt
         eLV/b+t4U5R8g==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 0/3] Minor cleanups
Date:   Tue, 12 Sep 2023 17:53:35 +0900
Message-ID: <20230912085338.434381-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

3 patches to cleanup libsas functions declarations. No functional
changes.

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

