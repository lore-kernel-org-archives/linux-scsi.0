Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0578BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 20:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD16361A0D
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 20:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbhCXUF0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 16:05:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:26214 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238101AbhCXUFG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 16:05:06 -0400
IronPort-SDR: uDNc1gDTYPc5Wfc+2IDODODWfhE+UkEOOx2t82P4ukToctBfhrGnTn2hm8yXx8Azs8D6DD9BBl
 R+uY6C8A+IBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="178332338"
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="178332338"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 13:05:05 -0700
IronPort-SDR: XGIbAoAednz+FF2k4MaSq4eFZamnvd4ANXu7B3P6TPsCsFtLH92Gg073PzXcVLiSWZU5NWvi95
 r7+DL7zAvdrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="409004048"
Received: from lkp-server01.sh.intel.com (HELO 69d8fcc516b7) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 24 Mar 2021 13:05:03 -0700
Received: from kbuild by 69d8fcc516b7 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lP9kU-0001UR-Sx; Wed, 24 Mar 2021 20:05:02 +0000
Date:   Thu, 25 Mar 2021 04:04:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas.G@microchip.com, Ruksar.devadi@microchip.com,
        vishakhavc@google.com, radha@google.com,
        jinpu.wang@cloud.ionos.com,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        John Garry <john.garry@huawei.com>
Subject: [RFC PATCH] pm80xx: mpiStateText[] can be static
Message-ID: <20210324200407.GA42444@3b6556a627b1>
References: <20210324170357.9765-2-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324170357.9765-2-Viswas.G@microchip.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 pm8001_ctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index ce4846b1377c9..f8fe919133b6e 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -895,7 +895,7 @@ static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
  * A sysfs 'read-only' shost attribute.
  */
 
-char mpiStateText[][80] = {
+static char mpiStateText[][80] = {
 	"MPI is not initialized",
 	"MPI is successfully initialized",
 	"MPI termination is in progress",
