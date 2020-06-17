Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDC7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6195212CC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgFQIf4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:35:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:52106 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgFQIfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 04:35:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8939DAF5A;
        Wed, 17 Jun 2020 08:35:57 +0000 (UTC)
From:   mwilck@suse.com
To:     Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        shane.seymour@hpe.com, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/3] scsi: smartpqi: fixes for scsi device removal
Date:   Wed, 17 Jun 2020 10:35:11 +0200
Message-Id: <20200617083514.19174-1-mwilck@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Hi Don, Martin,

here's a small update for the mini-series I sent yesterday.

Regards
Martin

Changes wrt v1:
 - added patch 3/3.

Martin Wilck (3):
  scsi: smartpqi: grab scsi device ref in slave_configure()
  scsi: smartpqi: check sdev in pqi_scsi_find_entry
  scsi: smartpqi: remove conditional before pqi_remove_device()

 drivers/scsi/smartpqi/smartpqi.h      |   1 +
 drivers/scsi/smartpqi/smartpqi_init.c | 131 +++++++++++++++++++++-----
 2 files changed, 107 insertions(+), 25 deletions(-)

-- 
2.26.2

