Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D849EC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 15:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B608E6103D
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 15:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhJRPNB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 11:13:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:56543 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232846AbhJRPM5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 11:12:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="228540136"
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="228540136"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 08:10:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="444086369"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by orsmga003.jf.intel.com with ESMTP; 18 Oct 2021 08:10:05 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org
Subject: [PATCH V2 0/1] scsi: ufs-pci: Force a full restore after suspend-to-disk
Date:   Mon, 18 Oct 2021 18:10:03 +0300
Message-Id: <20211018151004.284200-1-adrian.hunter@intel.com>
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


Changes in V2:

      scsi: ufs-pci: Force a full restore after suspend-to-disk

	Add missing #ifdef CONFIG_PM_SLEEP as per
	kernel test robot <lkp@intel.com>

	Add Reviewed-by: Avri Altman <avri.altman@wdc.com>


Adrian Hunter (1):
      scsi: ufs-pci: Force a full restore after suspend-to-disk

 drivers/scsi/ufs/ufshcd-pci.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)


Regards
Adrian
