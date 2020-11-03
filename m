Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8A3C388F9
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD70D22243
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgKCOOv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 09:14:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:29129 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbgKCOOV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 09:14:21 -0500
IronPort-SDR: d+8StmmavBmVRy5EV1VO4kyxBYAjVQegNhCSoSJucDHg5q1RBzHcS+XhHRfmbNaqJ67HzQypmw
 YlBG/V6z6lSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="156045771"
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="156045771"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 06:14:18 -0800
IronPort-SDR: gX7tZmQ02AgW2C/P+qfOd7+kHNNLtbJHQ3TB1rxNhxjQ68EcO+mVCd0rhWwhmQ23JrZdC2gfBq
 5t2kNGikUdNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,448,1596524400"; 
   d="scan'208";a="527170228"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.94])
  by fmsmga006.fm.intel.com with ESMTP; 03 Nov 2020 06:14:16 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH V4 0/2] scsi: ufs: Add DeepSleep feature
Date:   Tue,  3 Nov 2020 16:14:01 +0200
Message-Id: <20201103141403.2142-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Here is V4 of the DeepSleep feature patches.


Changes in V4:
	Rebased
	Added new patch "scsi: ufs: Allow an error return value from ->device_reset()"

Changes in V3:
	Updated sysfs doc for rpm_lvl and spm_lvl

Changes in V2:
	Fix SSU command IMMED setting and consequently drop patch 2.


Adrian Hunter (2):
      scsi: ufs: Add DeepSleep feature
      scsi: ufs: Allow an error return value from ->device_reset()

 Documentation/ABI/testing/sysfs-driver-ufs | 34 +++++++++++++++-----------
 drivers/scsi/ufs/ufs-mediatek.c            |  4 ++-
 drivers/scsi/ufs/ufs-qcom.c                |  6 +++--
 drivers/scsi/ufs/ufs-sysfs.c               |  7 ++++++
 drivers/scsi/ufs/ufs.h                     |  1 +
 drivers/scsi/ufs/ufshcd.c                  | 39 ++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h                  | 28 +++++++++++++++++----
 include/trace/events/ufs.h                 |  3 ++-
 8 files changed, 97 insertions(+), 25 deletions(-)


Regards
Adrian
