Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0157DC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 12:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D874320738
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 12:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgFDMEd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 08:04:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:12430 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbgFDMEd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jun 2020 08:04:33 -0400
IronPort-SDR: WSnW5LKSAq70eUiXxccTRPSKLw5S/LwSx7kjovOtA6SOZo8V+hjiyO5aRcyDuXZhebxDYLvEyw
 VtirVJMWgpYQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 05:04:02 -0700
IronPort-SDR: Pm/zQUo3ZntLbjISmq9VGsjjCCSe0oXz97/Ndl6XUqq+s4BdbPziubGq/TAamky+AdOgNViWfy
 xdfqAYn/6SVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="348077938"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga001.jf.intel.com with ESMTP; 04 Jun 2020 05:04:01 -0700
Received: from hasmsx601.ger.corp.intel.com (10.184.107.141) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jun 2020 05:04:01 -0700
Received: from hasmsx602.ger.corp.intel.com (10.184.107.142) by
 HASMSX601.ger.corp.intel.com (10.184.107.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 4 Jun 2020 15:03:58 +0300
Received: from hasmsx602.ger.corp.intel.com ([10.184.107.142]) by
 HASMSX602.ger.corp.intel.com ([10.184.107.142]) with mapi id 15.01.1713.004;
 Thu, 4 Jun 2020 15:03:58 +0300
From:   "Winkler, Tomas" <tomas.winkler@intel.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2
 boilerplate
Thread-Topic: [PATCH v1] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2
 boilerplate
Thread-Index: AQHWOmccNK5AyyBWskmSOMeVSNPPr6jIW4Mg
Date:   Thu, 4 Jun 2020 12:03:58 +0000
Message-ID: <7d00405a1be04f559ac8caebf8bc2b25@intel.com>
References: <20200604115535.16334-1-huobean@gmail.com>
In-Reply-To: <20200604115535.16334-1-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
x-originating-ip: [10.184.70.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> From: Bean Huo <beanhuo@micron.com>
> 
> Add SPDX GPL-2.0 to replace GPL v2 boilerplate, and remove wrapper
> function ufshcd_setup_clocks()

You don't do that in a single patch, please split. 

> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 26 +-------------
>  drivers/scsi/ufs/ufshcd.c        | 62 +++++++-------------------------
>  drivers/scsi/ufs/ufshcd.h        | 27 +-------------
>  3 files changed, 15 insertions(+), 100 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 76f9be71c31b..8b76a2acc80c 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -1,36 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Universal Flash Storage Host controller Platform bus based glue driver
> - *
>   * This code is based on drivers/scsi/ufs/ufshcd-pltfrm.c
>   * Copyright (C) 2011-2013 Samsung India Software Operations
>   *
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> - * without warranty of any kind. You are solely responsible for
> - * determining the appropriateness of using and distributing
> - * the program and assume all risks associated with your exercise
> - * of rights with respect to the program, including but not limited
> - * to infringement of third party rights, the risks and costs of
> - * program errors, damage to or loss of data, programs or equipment,
> - * and unavailability or interruption of operations. Under no
> - * circumstances will the contributor of this Program be liable for
> - * any damages of any kind arising from your use or distribution of
> - * this program.
>   */
> 
>  #include <linux/platform_device.h>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> f283b9eb97ac..e5ec68fc9fc7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1,40 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Universal Flash Storage Host controller driver Core
> - *
> - * This code is based on drivers/scsi/ufs/ufshcd.c
>   * Copyright (C) 2011-2013 Samsung India Software Operations
>   * Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
>   *
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> - * without warranty of any kind. You are solely responsible for
> - * determining the appropriateness of using and distributing
> - * the program and assume all risks associated with your exercise
> - * of rights with respect to the program, including but not limited
> - * to infringement of third party rights, the risks and costs of
> - * program errors, damage to or loss of data, programs or equipment,
> - * and unavailability or interruption of operations. Under no
> - * circumstances will the contributor of this Program be liable for
> - * any damages of any kind arising from your use or distribution of
> - * this program.
> - *
> - * The Linux Foundation chooses to take subject only to the GPLv2
> - * license terms, and distributes only under these terms.
>   */
> 
>  #include <linux/async.h>
> @@ -243,9 +215,7 @@ static int ufshcd_eh_host_reset_handler(struct
> scsi_cmnd *cmd);  static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int
> tag);  static void ufshcd_hba_exit(struct ufs_hba *hba);  static int
> ufshcd_probe_hba(struct ufs_hba *hba, bool async); -static int
> __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
> -				 bool skip_ref_clk);
> -static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
> +static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on, bool
> +skip_ref_clk);
>  static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);  static inline void
> ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);  static int
> ufshcd_host_reset_and_restore(struct ufs_hba *hba); @@ -1525,7 +1495,7
> @@ static void ufshcd_ungate_work(struct work_struct *work)
>  	}
> 
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -	ufshcd_setup_clocks(hba, true);
> +	ufshcd_setup_clocks(hba, true, false);
> 
>  	ufshcd_enable_irq(hba);
> 
> @@ -1683,10 +1653,10 @@ static void ufshcd_gate_work(struct work_struct
> *work)
>  	ufshcd_disable_irq(hba);
> 
>  	if (!ufshcd_is_link_active(hba))
> -		ufshcd_setup_clocks(hba, false);
> +		ufshcd_setup_clocks(hba, false, false);
>  	else
>  		/* If link is active, device ref_clk can't be switched off */
> -		__ufshcd_setup_clocks(hba, false, true);
> +		ufshcd_setup_clocks(hba, false, true);
> 
>  	/*
>  	 * In case you are here to cancel this work the gating state @@ -
> 7600,8 +7570,7 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
>  	return 0;
>  }
> 
> -static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
> -					bool skip_ref_clk)
> +static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on, bool
> +skip_ref_clk)
>  {
>  	int ret = 0;
>  	struct ufs_clk_info *clki;
> @@ -7664,11 +7633,6 @@ static int __ufshcd_setup_clocks(struct ufs_hba
> *hba, bool on,
>  	return ret;
>  }
> 
> -static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on) -{
> -	return  __ufshcd_setup_clocks(hba, on, false);
> -}
> -
>  static int ufshcd_init_clocks(struct ufs_hba *hba)  {
>  	int ret = 0;
> @@ -7775,7 +7739,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
>  	if (err)
>  		goto out_disable_hba_vreg;
> 
> -	err = ufshcd_setup_clocks(hba, true);
> +	err = ufshcd_setup_clocks(hba, true, false);
>  	if (err)
>  		goto out_disable_hba_vreg;
> 
> @@ -7797,7 +7761,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
>  out_disable_vreg:
>  	ufshcd_setup_vreg(hba, false);
>  out_disable_clks:
> -	ufshcd_setup_clocks(hba, false);
> +	ufshcd_setup_clocks(hba, false, false);
>  out_disable_hba_vreg:
>  	ufshcd_setup_hba_vreg(hba, false);
>  out:
> @@ -7813,7 +7777,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
>  		if (ufshcd_is_clkscaling_supported(hba))
>  			if (hba->devfreq)
>  				ufshcd_suspend_clkscaling(hba);
> -		ufshcd_setup_clocks(hba, false);
> +		ufshcd_setup_clocks(hba, false, false);
>  		ufshcd_setup_hba_vreg(hba, false);
>  		hba->is_powered = false;
>  		ufs_put_device_desc(hba);
> @@ -8176,10 +8140,10 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	ufshcd_disable_irq(hba);
> 
>  	if (!ufshcd_is_link_active(hba))
> -		ufshcd_setup_clocks(hba, false);
> +		ufshcd_setup_clocks(hba, false, false);
>  	else
>  		/* If link is active, device ref_clk can't be switched off */
> -		__ufshcd_setup_clocks(hba, false, true);
> +		ufshcd_setup_clocks(hba, false, true);
> 
>  	hba->clk_gating.state = CLKS_OFF;
>  	trace_ufshcd_clk_gating(dev_name(hba->dev), hba-
> >clk_gating.state); @@ -8238,7 +8202,7 @@ static int ufshcd_resume(struct
> ufs_hba *hba, enum ufs_pm_op pm_op)
> 
>  	ufshcd_hba_vreg_set_hpm(hba);
>  	/* Make sure clocks are enabled before accessing controller */
> -	ret = ufshcd_setup_clocks(hba, true);
> +	ret = ufshcd_setup_clocks(hba, true, false);
>  	if (ret)
>  		goto out;
> 
> @@ -8321,7 +8285,7 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	ufshcd_disable_irq(hba);
>  	if (hba->clk_scaling.is_allowed)
>  		ufshcd_suspend_clkscaling(hba);
> -	ufshcd_setup_clocks(hba, false);
> +	ufshcd_setup_clocks(hba, false, false);
>  out:
>  	hba->pm_op_in_progress = 0;
>  	if (ret)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> 2b62869fa459..ee14fb997803 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1,37 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Universal Flash Storage Host controller driver
> - *
> - * This code is based on drivers/scsi/ufs/ufshcd.h
>   * Copyright (C) 2011-2013 Samsung India Software Operations
>   * Copyright (c) 2013-2016, The Linux Foundation. All rights reserved.
>   *
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> - * without warranty of any kind. You are solely responsible for
> - * determining the appropriateness of using and distributing
> - * the program and assume all risks associated with your exercise
> - * of rights with respect to the program, including but not limited
> - * to infringement of third party rights, the risks and costs of
> - * program errors, damage to or loss of data, programs or equipment,
> - * and unavailability or interruption of operations. Under no
> - * circumstances will the contributor of this Program be liable for
> - * any damages of any kind arising from your use or distribution of
> - * this program.
>   */
> 
>  #ifndef _UFSHCD_H
> --
> 2.17.1

