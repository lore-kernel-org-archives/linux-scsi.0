Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91D8C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 06:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8769E610E9
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 06:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbhKHGvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 01:51:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:52820 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234454AbhKHGvb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Nov 2021 01:51:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10161"; a="318373232"
X-IronPort-AV: E=Sophos;i="5.87,217,1631602800"; 
   d="scan'208";a="318373232"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2021 22:48:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,217,1631602800"; 
   d="scan'208";a="451358961"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by orsmga006.jf.intel.com with ESMTP; 07 Nov 2021 22:48:16 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH V2 0/2] scsi: ufs: core: Fix task management completion timeout race
Date:   Mon,  8 Nov 2021 08:48:13 +0200
Message-Id: <20211108064815.569494-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

I though I sent this back on 15 October, but apparently I didn't, so
here it is now.

Please consider this for fixes.


Changes in V2:

      scsi: ufs: core: Fix task management completion timeout race
	Add Bart's Reviewed-by

      scsi: ufs: core: Fix another task management completion race
	New patch


Adrian Hunter (2):
      scsi: ufs: core: Fix task management completion timeout race
      scsi: ufs: core: Fix another task management completion race

 drivers/scsi/ufs/ufshcd.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)


Regards
Adrian
