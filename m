Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85494C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 13:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6186D61040
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbhJLNCL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 09:02:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:5460 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhJLNCK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 09:02:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="225904418"
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="225904418"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 05:59:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="625934921"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 12 Oct 2021 05:59:15 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 0/1] scsi: ufs-pci: Force a full restore after suspend-to-disk
Date:   Tue, 12 Oct 2021 15:59:13 +0300
Message-Id: <20211012125914.21977-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

This patch ensures suspend-to-disk works with Host Performance Booster.
Since the Host Perfomance Booster feature was added in v5.15, please
consider this for v5.15 fixes.


Adrian Hunter (1):
      scsi: ufs-pci: Force a full restore after suspend-to-disk

 drivers/scsi/ufs/ufshcd-pci.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)


Regards
Adrian
