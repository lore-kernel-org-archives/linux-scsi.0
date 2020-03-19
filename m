Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AF6C4332E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 09:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82E5420767
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 09:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgCSJ3a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 05:29:30 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:10943
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgCSJ3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Mar 2020 05:29:30 -0400
X-IronPort-AV: E=Sophos;i="5.70,571,1574118000"; 
   d="scan'208";a="342902958"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 10:29:26 +0100
Date:   Thu, 19 Mar 2020 10:29:26 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Alim Akhtar <alim.akhtar@samsung.com>
cc:     robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 4/5] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Message-ID: <alpine.DEB.2.21.2003191028360.3010@hadrien>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Perhaps this is intentional, but please check lines 931-935.

julia

---------- Forwarded message ----------
Date: Thu, 19 Mar 2020 09:31:14 +0800
From: kbuild test robot <lkp@intel.com>
To: kbuild@lists.01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 4/5] scsi: ufs-exynos: add UFS host support for Exynos
    SoCs

CC: kbuild-all@lists.01.org
In-Reply-To: <20200318111144.39525-5-alim.akhtar@samsung.com>
References: <20200318111144.39525-5-alim.akhtar@samsung.com>
TO: Alim Akhtar <alim.akhtar@samsung.com>
CC: robh+dt@kernel.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Alim,

I love your patch! Perhaps something to improve:

[auto build test WARNING on phy/next]
[also build test WARNING on scsi/for-next robh/for-next mkp-scsi/for-next v5.6-rc6 next-20200318]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Alim-Akhtar/exynos-ufs-Add-support-for-UFS-HCI/20200319-022156
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git next
:::::: branch date: 7 hours ago
:::::: commit date: 7 hours ago

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>

>> drivers/scsi/ufs/ufs-exynos.c:931:8-10: WARNING: possible condition with no effect (if == else)

# https://github.com/0day-ci/linux/commit/a0a2731081dba4edfad146c501203adb97d5947b
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout a0a2731081dba4edfad146c501203adb97d5947b
vim +931 drivers/scsi/ufs/ufs-exynos.c

a0a2731081dba4 Alim Akhtar 2020-03-18  898
a0a2731081dba4 Alim Akhtar 2020-03-18  899  static void exynos_ufs_specify_pwr_mode(struct device_node *np,
a0a2731081dba4 Alim Akhtar 2020-03-18  900  				struct exynos_ufs *ufs)
a0a2731081dba4 Alim Akhtar 2020-03-18  901  {
a0a2731081dba4 Alim Akhtar 2020-03-18  902  	struct uic_pwr_mode *pwr = &ufs->pwr_req;
a0a2731081dba4 Alim Akhtar 2020-03-18  903  	const char *str = NULL;
a0a2731081dba4 Alim Akhtar 2020-03-18  904
a0a2731081dba4 Alim Akhtar 2020-03-18  905  	if (!of_property_read_string(np, "ufs,pwr-attr-mode", &str)) {
a0a2731081dba4 Alim Akhtar 2020-03-18  906  		if (!strncmp(str, "FAST", sizeof("FAST")))
a0a2731081dba4 Alim Akhtar 2020-03-18  907  			pwr->mode = FAST_MODE;
a0a2731081dba4 Alim Akhtar 2020-03-18  908  		else if (!strncmp(str, "SLOW", sizeof("SLOW")))
a0a2731081dba4 Alim Akhtar 2020-03-18  909  			pwr->mode = SLOW_MODE;
a0a2731081dba4 Alim Akhtar 2020-03-18  910  		else if (!strncmp(str, "FAST_auto", sizeof("FAST_auto")))
a0a2731081dba4 Alim Akhtar 2020-03-18  911  			pwr->mode = FASTAUTO_MODE;
a0a2731081dba4 Alim Akhtar 2020-03-18  912  		else if (!strncmp(str, "SLOW_auto", sizeof("SLOW_auto")))
a0a2731081dba4 Alim Akhtar 2020-03-18  913  			pwr->mode = SLOWAUTO_MODE;
a0a2731081dba4 Alim Akhtar 2020-03-18  914  		else
a0a2731081dba4 Alim Akhtar 2020-03-18  915  			pwr->mode = FAST_MODE;
a0a2731081dba4 Alim Akhtar 2020-03-18  916  	} else {
a0a2731081dba4 Alim Akhtar 2020-03-18  917  		pwr->mode = FAST_MODE;
a0a2731081dba4 Alim Akhtar 2020-03-18  918  	}
a0a2731081dba4 Alim Akhtar 2020-03-18  919
a0a2731081dba4 Alim Akhtar 2020-03-18  920  	if (of_property_read_u32(np, "ufs,pwr-attr-lane", &pwr->lane))
a0a2731081dba4 Alim Akhtar 2020-03-18  921  		pwr->lane = 1;
a0a2731081dba4 Alim Akhtar 2020-03-18  922
a0a2731081dba4 Alim Akhtar 2020-03-18  923  	if (of_property_read_u32(np, "ufs,pwr-attr-gear", &pwr->gear))
a0a2731081dba4 Alim Akhtar 2020-03-18  924  		pwr->gear = 1;
a0a2731081dba4 Alim Akhtar 2020-03-18  925
a0a2731081dba4 Alim Akhtar 2020-03-18  926  	if (IS_UFS_PWR_MODE_HS(pwr->mode)) {
a0a2731081dba4 Alim Akhtar 2020-03-18  927  		if (!of_property_read_string(np,
a0a2731081dba4 Alim Akhtar 2020-03-18  928  					"ufs,pwr-attr-hs-series", &str)) {
a0a2731081dba4 Alim Akhtar 2020-03-18  929  			if (!strncmp(str, "HS_rate_b", sizeof("HS_rate_b")))
a0a2731081dba4 Alim Akhtar 2020-03-18  930  				pwr->hs_series = PA_HS_MODE_B;
a0a2731081dba4 Alim Akhtar 2020-03-18 @931  			else if (!strncmp(str, "HS_rate_a",
a0a2731081dba4 Alim Akhtar 2020-03-18  932  					sizeof("HS_rate_a")))
a0a2731081dba4 Alim Akhtar 2020-03-18  933  				pwr->hs_series = PA_HS_MODE_A;
a0a2731081dba4 Alim Akhtar 2020-03-18  934  			else
a0a2731081dba4 Alim Akhtar 2020-03-18  935  				pwr->hs_series = PA_HS_MODE_A;
a0a2731081dba4 Alim Akhtar 2020-03-18  936  		} else {
a0a2731081dba4 Alim Akhtar 2020-03-18  937  			pwr->hs_series = PA_HS_MODE_A;
a0a2731081dba4 Alim Akhtar 2020-03-18  938  		}
a0a2731081dba4 Alim Akhtar 2020-03-18  939  	}
a0a2731081dba4 Alim Akhtar 2020-03-18  940
a0a2731081dba4 Alim Akhtar 2020-03-18  941  	if (of_property_read_u32_array(
a0a2731081dba4 Alim Akhtar 2020-03-18  942  		np, "ufs,pwr-local-l2-timer", pwr->l_l2_timer, 3)) {
a0a2731081dba4 Alim Akhtar 2020-03-18  943  		pwr->l_l2_timer[0] = FC0PROTTIMEOUTVAL;
a0a2731081dba4 Alim Akhtar 2020-03-18  944  		pwr->l_l2_timer[1] = TC0REPLAYTIMEOUTVAL;
a0a2731081dba4 Alim Akhtar 2020-03-18  945  		pwr->l_l2_timer[2] = AFC0REQTIMEOUTVAL;
a0a2731081dba4 Alim Akhtar 2020-03-18  946  	}
a0a2731081dba4 Alim Akhtar 2020-03-18  947
a0a2731081dba4 Alim Akhtar 2020-03-18  948  	if (of_property_read_u32_array(
a0a2731081dba4 Alim Akhtar 2020-03-18  949  		np, "ufs,pwr-remote-l2-timer", pwr->r_l2_timer, 3)) {
a0a2731081dba4 Alim Akhtar 2020-03-18  950  		pwr->r_l2_timer[0] = FC0PROTTIMEOUTVAL;
a0a2731081dba4 Alim Akhtar 2020-03-18  951  		pwr->r_l2_timer[1] = TC0REPLAYTIMEOUTVAL;
a0a2731081dba4 Alim Akhtar 2020-03-18  952  		pwr->r_l2_timer[2] = AFC0REQTIMEOUTVAL;
a0a2731081dba4 Alim Akhtar 2020-03-18  953  	}
a0a2731081dba4 Alim Akhtar 2020-03-18  954  }
a0a2731081dba4 Alim Akhtar 2020-03-18  955

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
