Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0704BC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 18:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C746920656
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 18:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgGTSpA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 14:45:00 -0400
Received: from mga03.intel.com ([134.134.136.65]:40110 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgGTSo7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 14:44:59 -0400
IronPort-SDR: m2G+PZtAl6mKSDxRAEIaNb4mJXEmPoCuNnPQNvxn1Yx5zKccjObQa7pTjtAUPeOGHD/vcnsuk+
 TTC2FSSPWGww==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="149974050"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="gz'50?scan'50,208,50";a="149974050"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 11:44:53 -0700
IronPort-SDR: DoGtJ58qckops/nsSa7zObra+ZqzsmaR2YGeoZnNXfPmbOakckY+OVCI37i4gihs9CaKi5/tS2
 526E/R2Z3DQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="gz'50?scan'50,208,50";a="271507847"
Received: from lkp-server02.sh.intel.com (HELO f58f3bfa75fb) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 20 Jul 2020 11:44:50 -0700
Received: from kbuild by f58f3bfa75fb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jxamP-00004f-RT; Mon, 20 Jul 2020 18:44:49 +0000
Date:   Tue, 21 Jul 2020 02:44:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Deepak Ukey <deepak.ukey@microchip.com>, linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas.G@microchip.com, deepak.ukey@microchip.com,
        jinpu.wang@profitbricks.com, martin.petersen@oracle.com,
        yuuzheng@google.com, auradkar@google.com, vishakhavc@google.com,
        bjashnani@google.com
Subject: Re: [PATCH V3 1/2] pm80xx : Support for get phy profile
 functionality.
Message-ID: <202007210248.bMGutXgz%lkp@intel.com>
References: <20200720135303.6948-2-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20200720135303.6948-2-deepak.ukey@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Deepak,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on v5.8-rc6]
[also build test WARNING on next-20200720]
[cannot apply to mkp-scsi/for-next scsi/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Deepak-Ukey/pm80xx-Updates-for-the-driver-version-0-1-39/20200720-214608
base:    ba47d845d715a010f7b51f6f89bae32845e6acb7
config: x86_64-randconfig-s022-20200719 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-14) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.2-49-g707c5017-dirty
        # save the attached .config to linux build tree
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=x86_64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/pm8001/pm80xx_hwi.c:81:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:81:39: sparse:     expected unsigned int [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:81:39: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:69:6: sparse: sparse: symbol 'pm80xx_pci_mem_copy' was not declared. Should it be static?
   drivers/scsi/pm8001/pm80xx_hwi.c:1213:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 @@     got unsigned int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1213:27: sparse:     expected restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:1213:27: sparse:     got unsigned int
   drivers/scsi/pm8001/pm80xx_hwi.c:1215:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1215:27: sparse:     expected restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:1215:27: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1255:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] pageCode @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1255:39: sparse:     expected restricted __le32 [addressable] [usertype] pageCode
   drivers/scsi/pm8001/pm80xx_hwi.c:1255:39: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1256:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] MST_MSI @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1256:39: sparse:     expected restricted __le32 [addressable] [usertype] MST_MSI
   drivers/scsi/pm8001/pm80xx_hwi.c:1256:39: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1257:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] STP_SSP_MCT_TMO @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1257:39: sparse:     expected restricted __le32 [addressable] [usertype] STP_SSP_MCT_TMO
   drivers/scsi/pm8001/pm80xx_hwi.c:1257:39: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1258:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] STP_FRM_TMO @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1258:39: sparse:     expected restricted __le32 [addressable] [usertype] STP_FRM_TMO
   drivers/scsi/pm8001/pm80xx_hwi.c:1258:39: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1260:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] STP_IDLE_TMO @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1260:39: sparse:     expected restricted __le32 [addressable] [usertype] STP_IDLE_TMO
   drivers/scsi/pm8001/pm80xx_hwi.c:1260:39: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1262:26: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/pm8001/pm80xx_hwi.c:1263:44: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] STP_IDLE_TMO @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1263:44: sparse:     expected restricted __le32 [addressable] [usertype] STP_IDLE_TMO
   drivers/scsi/pm8001/pm80xx_hwi.c:1263:44: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1266:41: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] OPNRJT_RTRY_INTVL @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1266:41: sparse:     expected restricted __le32 [addressable] [usertype] OPNRJT_RTRY_INTVL
   drivers/scsi/pm8001/pm80xx_hwi.c:1266:41: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1268:48: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] Data_Cmd_OPNRJT_RTRY_TMO @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1268:48: sparse:     expected restricted __le32 [addressable] [usertype] Data_Cmd_OPNRJT_RTRY_TMO
   drivers/scsi/pm8001/pm80xx_hwi.c:1268:48: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1270:48: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] Data_Cmd_OPNRJT_RTRY_THR @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1270:48: sparse:     expected restricted __le32 [addressable] [usertype] Data_Cmd_OPNRJT_RTRY_THR
   drivers/scsi/pm8001/pm80xx_hwi.c:1270:48: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1272:31: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [usertype] MAX_AIP @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1272:31: sparse:     expected restricted __le32 [addressable] [usertype] MAX_AIP
   drivers/scsi/pm8001/pm80xx_hwi.c:1272:31: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1425:33: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] new_curidx_ksop @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:1425:33: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] new_curidx_ksop
   drivers/scsi/pm8001/pm80xx_hwi.c:1425:33: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:1869:40: sparse: sparse: invalid assignment: |=
   drivers/scsi/pm8001/pm80xx_hwi.c:1869:40: sparse:    left side has type restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:1869:40: sparse:    right side has type int
   drivers/scsi/pm8001/pm80xx_hwi.c:3037:63: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long long [usertype] address @@     got restricted __le64 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:3037:63: sparse:     expected unsigned long long [usertype] address
   drivers/scsi/pm8001/pm80xx_hwi.c:3037:63: sparse:     got restricted __le64 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:3828:35: sparse: sparse: restricted __le32 degrades to integer
>> drivers/scsi/pm8001/pm80xx_hwi.c:3849:46: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:3851:41: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:3852:43: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:3853:43: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:3854:47: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:3855:44: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:3861:25: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:3863:25: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:3865:25: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:3867:25: sparse: sparse: cast to restricted __le32
   drivers/scsi/pm8001/pm80xx_hwi.c:4359:46: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long long [usertype] address @@     got restricted __le64 [assigned] [usertype] tmp_addr @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4359:46: sparse:     expected unsigned long long [usertype] address
   drivers/scsi/pm8001/pm80xx_hwi.c:4359:46: sparse:     got restricted __le64 [assigned] [usertype] tmp_addr
   drivers/scsi/pm8001/pm80xx_hwi.c:4534:36: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [usertype] start_addr @@     got restricted __le64 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4534:36: sparse:     expected unsigned long long [usertype] start_addr
   drivers/scsi/pm8001/pm80xx_hwi.c:4534:36: sparse:     got restricted __le64 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4535:57: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/pm8001/pm80xx_hwi.c:4536:38: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] end_addr_low @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4536:38: sparse:     expected unsigned int [usertype] end_addr_low
   drivers/scsi/pm8001/pm80xx_hwi.c:4536:38: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4537:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] end_addr_high @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4537:39: sparse:     expected unsigned int [usertype] end_addr_high
   drivers/scsi/pm8001/pm80xx_hwi.c:4537:39: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4538:53: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/pm8001/pm80xx_hwi.c:4564:35: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] key_cmode @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4564:35: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] key_cmode
   drivers/scsi/pm8001/pm80xx_hwi.c:4564:35: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:4593:36: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [usertype] start_addr @@     got restricted __le64 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4593:36: sparse:     expected unsigned long long [usertype] start_addr
   drivers/scsi/pm8001/pm80xx_hwi.c:4593:36: sparse:     got restricted __le64 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4594:57: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/pm8001/pm80xx_hwi.c:4595:38: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] end_addr_low @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4595:38: sparse:     expected unsigned int [usertype] end_addr_low
   drivers/scsi/pm8001/pm80xx_hwi.c:4595:38: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4596:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] end_addr_high @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4596:39: sparse:     expected unsigned int [usertype] end_addr_high
   drivers/scsi/pm8001/pm80xx_hwi.c:4596:39: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4597:53: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/pm8001/pm80xx_hwi.c:4701:47: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_low @@     got unsigned int [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4701:47: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_low
   drivers/scsi/pm8001/pm80xx_hwi.c:4701:47: sparse:     got unsigned int [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4702:48: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_high @@     got unsigned int [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4702:48: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_high
   drivers/scsi/pm8001/pm80xx_hwi.c:4702:48: sparse:     got unsigned int [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4706:47: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_low @@     got unsigned int [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4706:47: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_low
   drivers/scsi/pm8001/pm80xx_hwi.c:4706:47: sparse:     got unsigned int [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4707:48: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_high @@     got unsigned int [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4707:48: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_high
   drivers/scsi/pm8001/pm80xx_hwi.c:4707:48: sparse:     got unsigned int [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4711:36: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [usertype] start_addr @@     got restricted __le64 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4711:36: sparse:     expected unsigned long long [usertype] start_addr
   drivers/scsi/pm8001/pm80xx_hwi.c:4711:36: sparse:     got restricted __le64 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4712:58: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/pm8001/pm80xx_hwi.c:4713:38: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] end_addr_low @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4713:38: sparse:     expected unsigned int [usertype] end_addr_low
   drivers/scsi/pm8001/pm80xx_hwi.c:4713:38: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4714:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] end_addr_high @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4714:39: sparse:     expected unsigned int [usertype] end_addr_high
   drivers/scsi/pm8001/pm80xx_hwi.c:4714:39: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4715:54: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/pm8001/pm80xx_hwi.c:4728:55: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_low @@     got unsigned int [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4728:55: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_low
   drivers/scsi/pm8001/pm80xx_hwi.c:4728:55: sparse:     got unsigned int [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4730:56: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_high @@     got unsigned int [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4730:56: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] enc_addr_high
   drivers/scsi/pm8001/pm80xx_hwi.c:4730:56: sparse:     got unsigned int [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4742:41: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] key_index_mode @@     got int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4742:41: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] key_index_mode
   drivers/scsi/pm8001/pm80xx_hwi.c:4742:41: sparse:     got int
   drivers/scsi/pm8001/pm80xx_hwi.c:4777:36: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [usertype] start_addr @@     got restricted __le64 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4777:36: sparse:     expected unsigned long long [usertype] start_addr
   drivers/scsi/pm8001/pm80xx_hwi.c:4777:36: sparse:     got restricted __le64 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4778:58: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/pm8001/pm80xx_hwi.c:4779:38: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] end_addr_low @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4779:38: sparse:     expected unsigned int [usertype] end_addr_low
   drivers/scsi/pm8001/pm80xx_hwi.c:4779:38: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:4780:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] end_addr_high @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:4780:39: sparse:     expected unsigned int [usertype] end_addr_high
   drivers/scsi/pm8001/pm80xx_hwi.c:4780:39: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:5109:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] ppc_phyid @@     got unsigned int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:5109:27: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] ppc_phyid
   drivers/scsi/pm8001/pm80xx_hwi.c:5109:27: sparse:     got unsigned int
   drivers/scsi/pm8001/pm80xx_hwi.c:5114:37: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:5114:37: sparse:     expected unsigned int
   drivers/scsi/pm8001/pm80xx_hwi.c:5114:37: sparse:     got restricted __le32 [usertype]
   drivers/scsi/pm8001/pm80xx_hwi.c:5094:6: sparse: sparse: symbol 'mpi_set_phy_profile_req' was not declared. Should it be static?
   drivers/scsi/pm8001/pm80xx_hwi.c:5154:27: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [addressable] [assigned] [usertype] ppc_phyid @@     got unsigned int @@
   drivers/scsi/pm8001/pm80xx_hwi.c:5154:27: sparse:     expected restricted __le32 [addressable] [assigned] [usertype] ppc_phyid
   drivers/scsi/pm8001/pm80xx_hwi.c:5154:27: sparse:     got unsigned int
   drivers/scsi/pm8001/pm80xx_hwi.c:5158:37: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int @@     got restricted __le32 [usertype] @@
   drivers/scsi/pm8001/pm80xx_hwi.c:5158:37: sparse:     expected unsigned int
   drivers/scsi/pm8001/pm80xx_hwi.c:5158:37: sparse:     got restricted __le32 [usertype]

vim +3849 drivers/scsi/pm8001/pm80xx_hwi.c

  3811	
  3812	/**
  3813	 * mpi_get_phy_profile_resp - SPCv specific
  3814	 * @pm8001_ha: our hba card information
  3815	 * @piomb: IO message buffer
  3816	 */
  3817	static int mpi_get_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
  3818				void *piomb)
  3819	{
  3820		u32 tag, page_code;
  3821		struct phy_status *phy_status, *phy_stat;
  3822		struct phy_errcnt *phy_err, *phy_err_cnt;
  3823		struct pm8001_ccb_info *ccb;
  3824		struct get_phy_profile_resp *pPayload =
  3825			(struct get_phy_profile_resp *)(piomb + 4);
  3826		u32 status = le32_to_cpu(pPayload->status);
  3827	
  3828		page_code = (u8)((pPayload->ppc_phyid & 0xFF00) >> 8);
  3829	
  3830		PM8001_MSG_DBG(pm8001_ha,
  3831			pm8001_printk(" pm80xx_addition_functionality\n"));
  3832		if (status) {
  3833			/* status is FAILED */
  3834			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
  3835				"mpiGetPhyProfileReq failed  with status 0x%08x\n",
  3836				status));
  3837		}
  3838	
  3839		tag = le32_to_cpu(pPayload->tag);
  3840		ccb = &pm8001_ha->ccb_info[tag];
  3841		if (ccb->completion != NULL) {
  3842			if (status) {
  3843				/* signal fail status */
  3844				memset(&ccb->resp_buf, 0xff, sizeof(ccb->resp_buf));
  3845			} else if (page_code == SAS_PHY_GENERAL_STATUS_PAGE) {
  3846				phy_status = (struct phy_status *)ccb->resp_buf;
  3847				phy_stat =
  3848				(struct phy_status *)pPayload->ppc_specific_rsp;
> 3849				phy_status->phy_id = le32_to_cpu(phy_stat->phy_id);
  3850				phy_status->phy_state =
  3851						le32_to_cpu(phy_stat->phy_state);
  3852				phy_status->plr = le32_to_cpu(phy_stat->plr);
  3853				phy_status->nlr = le32_to_cpu(phy_stat->nlr);
  3854				phy_status->port_id = le32_to_cpu(phy_stat->port_id);
  3855				phy_status->prts = le32_to_cpu(phy_stat->prts);
  3856			} else if (page_code == SAS_PHY_ERR_COUNTERS_PAGE) {
  3857				phy_err = (struct phy_errcnt *)ccb->resp_buf;
  3858				phy_err_cnt =
  3859				(struct phy_errcnt *)pPayload->ppc_specific_rsp;
  3860				phy_err->InvalidDword =
  3861				le32_to_cpu(phy_err_cnt->InvalidDword);
  3862				phy_err->runningDisparityError =
  3863				le32_to_cpu(phy_err_cnt->runningDisparityError);
  3864				phy_err->LossOfSyncDW =
  3865				le32_to_cpu(phy_err_cnt->LossOfSyncDW);
  3866				phy_err->phyResetProblem =
  3867				le32_to_cpu(phy_err_cnt->phyResetProblem);
  3868			}
  3869			complete(ccb->completion);
  3870		}
  3871		pm8001_tag_free(pm8001_ha, tag);
  3872		return 0;
  3873	}
  3874	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--3V7upXqbjpZ4EhLz
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICAraFV8AAy5jb25maWcAlDzLdtw2svt8RR9nkyyckWRZ1zlztABJsBtpkqABsB/a8Chy
29EZPXxb0ox9v/5WAXwAYFHOZOGoqwrveqPAn3/6ecFenh/vr59vb67v7r4vvhweDsfr58On
xefbu8M/F5lcVNIseCbMb0Bc3D68fPvHtw8X7cX54v1vH347eXu8uVisD8eHw90ifXz4fPvl
BdrfPj789PNPqaxysWzTtN1wpYWsWsN35vLNl5ubt78vfskOf95ePyx+/+0ddHN6/qv7643X
TOh2maaX33vQcuzq8veTdycnPaLIBvjZu/MT+9/QT8Gq5YA+8bpPWdUWolqPA3jAVhtmRBrg
Vky3TJftUhpJIkQFTfmIEupju5XKGyFpRJEZUfLWsKTgrZbKjFizUpxl0E0u4R8g0dgUtvLn
xdKezN3i6fD88nXcXFEJ0/Jq0zIF2yBKYS7fnQF5PzdZ1gKGMVybxe3T4uHxGXvoWzesFu0K
huTKkowzKWTKin7T3ryhwC1r/G2wK2s1K4xHv2Ib3q65qnjRLq9EPZL7mAQwZzSquCoZjdld
zbWQc4jzERHOadgvf0L+fsUEOK3X8Lur11vL19HnxFllPGdNYeyJezvcg1dSm4qV/PLNLw+P
D4dfBwK9ZcES9V5vRJ0SI9RSi11bfmx44/GwD8XGqSlG5JaZdNVGLVIltW5LXkq1b5kxLF35
E2g0L0RCjM8aUDPR2TEF/VsEDs0Kb+wIaqUEBG7x9PLn0/en58P9KCVLXnElUiuPtZKJN1kf
pVdyS2N4nvPUCJxQnrelk8uIruZVJior9HQnpVgq0CkgUCRaVH/gGD56xVQGKA2H2CquYQC6
abryRQshmSyZqEKYFiVF1K4EV7jP+5lpM6OAA2CXQfiNVDQVTk9t7PLaUmaREsylSnnW6TfY
pBGra6Y0n9+0jCfNMteWgQ4PnxaPn6NDHvW8TNdaNjCQY8tMesNYPvJJrBh9pxpvWCEyZnhb
MG3adJ8WBLtYFb6Z8GSPtv3xDa+MfhXZJkqyLGW+6qXISjgmlv3RkHSl1G1T45R7MTC394fj
EyUJYNLWraw4sLrXVSXb1RUai9Jy3yCqAKxhDJkJSl+4ViKz+zO0cdC8KQpSx1k00dlKLFfI
RHZnVXDek9WMvdWK87I20GvFyeF6go0smsowtaf0nqPxVF7XKJXQZgJ2Emr3Oa2bf5jrp38t
nmGKi2uY7tPz9fPT4vrm5vHl4fn24Uu089CgZant10nBMNGNUCZC4wmTi0K5sAw40hLL0unK
ihxXJStw8lo3KjiqRGeoDlPAYFeGHAydEPSFNL2/WoTw7sz+xs4MsgeLFloWzN9ZlTYLTbAv
HEELuOlZBUD40fIdsK53ejqgsB1FIFyobdpJFoGagJqMT4eG7SqKUZw8TMXhSDRfpkkhfFlG
XM4q2ZjLi/MpsC04yy9PL8Z9dzhtpvIUkCRSko6fnYtME9x8nyPcqoxiqV1Wa93RMiGPODyi
Qduv3R+e/l8PRyVTH+wcT315P3qX6EbmYIdFbi7PTnw4cknJdh7+9GzkAVEZ8NhZzqM+Tt8F
3kRT6c7ttrJhNWzPcfrmr8Onl7vDcfH5cP38cjw8ORHvnBYII8ra7g+5GUTrwPTopq7B1ddt
1ZSsTRgEJWlgBy3VllUGkMbOrqlKBiMWSZsXjV5NAg5Y8+nZh6iHYZwYOzduCB/cSV7hPnnu
RrpUsqk9a1azJXcaknsuAXh96TL62bugvdYp1l1vce/tVgnDE5auJxh7YCM0Z0K1JCbNwaiy
KtuKzHh7BsqVJnfQWmTal4MOrLIZN7/D56BFrrgiBAzYVXMT9InsjwN1uNf6zfhGpJzq1uGh
B9TX02VwlU+AST2FWa/K040yXQ8oZlhgzyGoACcNjAQ1nxVP17UEZkPbDc6h5yo5GcMgsT9s
PwaBY8o4KG9wKXlG6y9eMMpcI//ABlkPTnlHaX+zEjp2jpwXJKksij4B0Aed43jZJKwbMX60
aQll9Ps8MKxSoveAf9PHnLYSHIlSXHF0je25STDTFX3oEbWGP7xtjkIyp+hEdnoR04BJTLn1
X5yGj9rUqa7XMBcwxDgZT2B9BorNajRSCcpDAHt7KkEvucGIqZ14y44NJuB8BfIbOpUuCHWu
IenBoQHwnQJrEKpS+PkJj+F5kcP5+Nw6v3oG4Qm6s94EG8N30U+QbK/7WgbrFMuKFbnHq3Yl
PsD6+T5Ar0B3espdSH8/hGwbRbt9LNsIzftd9RQ29JcwpYR/Nmsk2Zd6CmmDIxmhCXhqsF5k
Wec7xBR2v1B2MVwOmGh60qPR6+0Okv1hIzM/X6AsMs+o5WIXaA7H5cE4VRodL8SYH/1OrQK0
UFJAoS+eZZwa0MkKTKmN47s6PT05792JLidaH46fH4/31w83hwX/9+EBXGAGHkOKTjAENaNn
G/YYzdMiYR/aTWnDcNIF+ZsjeiFH6QbsrTjt4WMKkcHBqDWJ1gVLZhANleTRhUw8LofWcHIK
XImOAwIzsWryHLw162oM+Qeq0702vLSmCzO9IhdplGgB45uLIvB8rA60tiuINsNEa098cZ74
+YKdTYEHv31DpI1qbCoHVpXKzJc48OZrcOitujeXbw53ny/O3377cPH24tzPsq7BOPbOnLdd
Bnwj551PcGXZRIJVov+oKjB1wqUQLs8+vEbAdpg7Jgl6Jug7muknIIPuIGLp6PpkRaCFPeCg
MVp7Ii4DEJGB7hCJwsxMhq5BtFrUARgkYEc7CsfAH8HUPo8M6EABDAIDt/USmCXOQ4LD5vwr
F6NDXOS50BjU9SirOaArhbmjVePfLgR0lqdJMjcfkXBVuXQaGD8tkiKesm40phzn0Fat2q2D
6H/VgBEuPMG7krAP4N2+8/LuNqFqG88FFZ02gqlbaYzlodVlPde0sXlX71RzMOicqWKfYsbQ
t3X10gVpBWgnMGBDPNzFPZrhEaIk4Dnx1KUkrdKtj483h6enx+Pi+ftXl3bwgrlo6Z5Y+dPG
peScmUZx5/v6GgmRuzNWk/kwRJa1zWf6bZayyHKhV5RjyQ14CsGVEXbi2BhcNlXEg/OdgTNH
PuocFVL3IiVKUdEWtabVOpKwcuyHiDk8b0PnbZkIWs9bN1+WwDo5uN+DAFOmcw/cD94J+LDL
Jrhugk1jmAELfL4O5riOzj71JLoWlU3h0msN82i9xwL2L5qGyxLXDeY0gdcK0/lx44Cb1esT
+XFabiDtsw9DJ38wUawkmnk7LXIglqrqFXS5/kDDa53SCHST6KsusE+yJBYwqGPf/es5TlVg
7jpd61IwFz5JcTqPMzpSKGlZ79LVMrKzmO/ehBCwSKJsSis3OStFsfeyaEhgOQgioFJ7lliA
8rOS3gbxE9Jvyt1EB4yOBOZLMQzjBQ9icBgd1J0TvCkYhG0KXO2XvpfSg1PwylijpoirFZM7
/15nVXPHdCrwGktaVpcM+E5IcBVmTnwHqpDK9FubpVvFKrBaCV+iL0Ej8Y7q/ekE2Xt347l0
GA/iNIkuQx/QAss5fWsvpFtUyBEvSgKouJIYu2AQnSi55pWL1PGKLVa0ZagLnXnxXOv7x4fb
58ejS/GPemD04jsF3FQoYZQemJAqVhdjMnSKTzENz2kKq8rlFtjgfnRlZ+brb8npxcSv5boG
2xxLXX/XBQ5OU0TOtdvwusB/uB87iw/rcbqlSEF23NXgyHI90K2RZsuBBlb5AwqwtU4P5YzM
pdij1WqcVWdvRWY3zgO+t+7HTBeZUCD77TJBX0jH1pu54hFtRBrwFR4SeDogI6na11ReHrOx
cQuEzUwDXC6W1qJv5nWCx+RBYGt0rHOdf2bdFTcpRviYA3oMzwK81YH9XT/e+8bRfYeKbt1F
UfAl3ko5XwHvXBt+efLt0+H604n3X3gkNU4EG6ZUXtDuPeYjIf6QGuN/1dRTRkWJRxtc9lMb
CV3zWGfgvTbeK2xRVY0sZxTl4tg1gybMZBn2o8uwDANhTSnqH/hv4/YZVxzQrvmeSoGNTYze
2ZNoZZ7HI8YU9P0iQYlpXDpTks+4hTzFaJDEra7a05MTykG8as/en/iTBsi7kDTqhe7mEroJ
zcpK4QWs3/Wa7zjtFFkMhoNkNlYxvWqzxo8Z6tVeCzREIPfgxJ58Ow1r0CAmxdxFJ2Bjxtny
CaZ1MWlG2Yi+X4h8lxX0exZ0uwJOLpplfIk3crhHQO2TC+d8Is/jcKH8JtNB4tFJX2wNqLnH
lDtZFfvXupq9w0/LzIbtsC5KHwN/inzfFpmZJhht7F6IDa/xUi0YvQeSubTXAslJ3oBlWRvZ
AYtzGrUX4W6bf0Sj4C8/b4rhgMu1Or1u/WuR0d3ouoAwrEZfwPh3m/Xjfw7HBTgC118O94eH
Z7sgtByLx69YrOlFx5Psg7ul9YJll3aYAPrLsMB561B6LWqblSULP9xYGDUUBV7+efvoTYQE
trpiNdayYPjqyWMJkoiHAkJvwgpGRBWc1yExQsI0AEBR5/W0o4dXtlu25pNgc0AHXfT3bH5z
lm3woid7La4tbTlmv3/kON2kJyNkdoau/oluGF3+9JBWmTSApoVnC7cfnX+JpXAiFXzM2fuD
Y2i47ByBOes4pISQAT0+nvzqNYTVmxossFw3cX6pFMuV6UoFsUmdpVEnXW7YTd560NpLnnqB
NdDazVySuQvXV52q1kR+kp1p7XvRjjbmHDc/8FNz7WYzN4rimxZ0gFIi4352L+wJLFRXGzfX
D4u3ImEGnK19DG2M8cXLAjcwthy9ZAvLWTWZhWG0R+62E4RkbnI2VlccuErraOwxxO4injl0
V3pGIiczFXUYFPu4GUMaDceWSwUcSV9BuN1wxVbRnNJGGwm6QIOFQqfC00ajDXGbiUq8qZeK
ZfHCYhzBuPMHUafIj5KKONwMZWUYmNjprvU74wzUj/ZPyC7oDjvRCZ2Xc21nrv/9rSu5WclX
yBTPGtSoWC+7ZQod22I/Tw5/zW7FJAKzcywZ1WBUO6zmnvIK4d01dNgjIsgJZrXJp+rBswwC
qwGAD8WM894fKPxNqgYXSE1zRjp05Pv6xkV+PPzvy+Hh5vvi6eb6Lihp7GU4zFNZqV7KDZZ+
Y5bMzKDj+rgBiULvz2xA9JfE2PoHJRNkE9xVzTb8h53jlbOteaH9UaqJrDIOs6GZlGwBuK5k
evNfjGOjmcYIyrwG2+tt0MwBvL4fs/tAEfarn+1pbrEU7bDEy7HMdvE5ZsPFp+Ptv4Mr9DFs
rXu7EaYPUpu0xnHmr0Q62/QqEThlPAOvwiVqlajknJyduyw/+EOX924tT39dHw+fpn532G8h
Ej+RR8vhsDfi090hlMq4KLuH2f0tIGCZK1obqUpeNSHjDCjD5Wzn/a0JqS4dqr9hufwertAu
w7t1skeJhHSI9sOYxu5P8vLUAxa/gB1cHJ5vfvvVq7sA0+iyeZ7vC7CydD9GqIPgBcPpySok
Tqvk7AQ24GMj/MdeQjPwroIUIIIyCOPATlIWCNN9Scy3WCZFl+DOLM4t/Pbh+vh9we9f7q4j
XrM3H34eN7zffHdG8YbLB/j3xQ40SRlgdr3BzCTmLICLjH/O01nZyea3x/v/gGAsskGox5gi
o5VqLlRpjT34JiWjM01CpxpcvySnzHe+bdO8q0IbV+FD+9TDiF1KuSz4MLa/dx0K0/32VsF6
bMSwPBfDxXev4czhy/F68bnfBafaLKZ/A0ET9OjJ/gWuyHpT+hPF28cGTufKHj/FhuCPbnbv
T/3aAEwfs9O2EjHs7P1FDDU1a/TwGKUvqLk+3vx1+3y4wSzK20+HrzB1FNuJJuydyegiSLoS
HmpH7SJ7/DiTHoIO2ODvdLj1UI4wXr82JShelpCRq6xNXMDQdQG2r82jkHpS7GBnOEbOTWWF
A8tjUwwuoqAWcz74nNKIqk3C4uk1lgxQnQtgOyzDIWpX1mSD2Z6IpfrdUOu1+LypXIYaIlcM
zqjnbBseFmWOb/xsjysI8SMkKksMT8SykQ1RFKTh0KzxcW/Lop20ZT0Q6WOCsKsKnhKAi9rF
NzPI7ranZPH7VTdz92jX1Xy125UAsyUmVQVYjqPbbF8x9OCNrYe1LeIudYnpk+6NbXwG4PeD
bGJGDetfOu5BYxLTad8rD48HXwrPNlxt2wSW42q6I1wpdsCxI1rb6URE6DJiXUujqraSsPFB
vWlcPElwA8Zw6DPZKnVX3hPVtY+dEOP3pZKq26IwUT+e2ijtr2OJUtaybNolw1i/i8ox80mi
8QkNRdJxl5MG926lK3aIJtNB3TX3DC6TzUz1V2eQRZ227pVl/6CboMWL05Ge2pPuRqcrkyMp
cMcLYI8IOSnW6h2GrqArQNt7gCAwDdCzYbhdiTAr0Jnu5G01UsweqEr4zlh1sw7KQS165hVe
rGun7+9iUZHIin7FR6DpKrxXRUOAdXl4dfB36dq6IftEPBYHx+lRe7QWiZcCYK0VOZSWudVy
Zj9ZR9ZfBPMUy2o9NpdZg2lZNFZYTo9yQuhPi+rvuaixgyLU2GLuhKEVe9hqrGsl+vWKUuc6
8UmIrjq0JcebuilT1fveDJgixjpu7F4VT+0h7JtwlzdDce8kgggVNYqqFsvucuDdxAHv8Cyy
voMHnwhXMkSdBvKQm0ngMQ7Q1yrwwZ4JsIDdVwzU1qvCfQUVN3d8RTanUOPUa9hJiGu6u9bQ
eA5uFdj5wE8a7wPxCZRXDk9m1b23Bn0Rx+DlpnLz9s/rJ4jt/+UK8b8eHz/f3kUFQkjWbcNr
A1iy3n1lXQ1iX6D+ykjBruDnUtCTFhVZ4P4Df7zvChRiiQ9cfK63bzw0vkUYP6jS6QN/T7vz
so//YYMZdZHV0TQV4mPt0jUdkH7PvYdEFwS55lqlw8dKZt6j95QzL7U6NMoOPqCeXwAWRG/B
RdIabcbwaK4Vpb3s8mKDCvgQBHRfJjJ4ntPpU/syOb7rSrrb3OHnugUbZIuwI1FGlA16Ff8Y
Frf27+YSvSSBmHOawDEJs1TCNwwTVGtOg5qNngALrenQvacAnSmNKehCWftOtLv6t+6LigfZ
JlRYP74vhaAIixOqNJr9gE2lNtOZY1FETvOV3V0sd64ZJb+Idt8A6tVDoIFJdJt31969Jqmv
j8+3KIML8/1r+Ap5uNAeLpEphtSZ1N7d9zA8Jh588JhKi0YMuG6S5sFVlB8x7zWBofsk5ASs
gmp7BNprcvfFFjm+nQ7WCu2EdLU7GRhW3DVqsSPVep9wr7CvByf5R7+0D362/fFbAjKxFs5q
TG1Up74gd2eJxedWR6XxK47xqttIDPtU6X1fxmpV1xgOVG4r36lWWw02ZgZpj2UGN1g6+1Ge
bKyMH0nmMXFjtaWbTuCD4apwRqBzC1bXqAhZlqHebK0ypIx+/1SvTXiO/8PQLfx+jEfrCoW2
Cjr31zxWnlgG4t8ONy/P13/eHexXzBa2BvbZyzAlospLg67pxDuiUPAjfExo54uB5fhcHrzc
/nMG36NhdKpEHaoZhwBjQRXEYO9d1Drw49yS7HrLw/3j8fuiHFPhk5zaq3WaY5FnyaqGUZgR
ZB8x2Ve+NWbWsLA0jhn6kkX8YJGhhoEADJwwTqE2Lpk7qUadUMTZDfwWxtI3mbZaao0lMtAA
v6jmSZ6bof/RkRAzqdUK4d1sZtE9V8j+c3CjUovqvKi3jK6GyzjdixXy5wGPpnHO3saFiqOi
oQ0p8d2p1GbU2ugVF5YbWoltTfzgMQGf2Bdg99hFxtcba029GOn3w56s+5RRpi7PT373PmhC
RbtzHrLLpZlVPfm4WVpwMIv4woTK9ytYdZhOTX3DBD/iDyMMIP+GAIEwUaYv/yc4WS+MJka/
iudqAYNnKdWwTfD/uKbyx43mvik32+DDOXXN80r/539r8kC3oqtqZ5tcaUP5MXP0l2/u/m98
K+uormopi7HDpMmmk41o3v0/Z9/a2ziOLPr9/opgPxzsAqcxluSHfIH+IEuyzY5eEWVb6S9C
Jp3dCTbpNDqZ3Z3z6y+LpKQiVZTn3AGmu11VpPhmsZ578U6eaahFzqee127yz3/5n19//2a1
cTwVxqUkS6GfOyzeUU0cOZq+DYhCQwaXyVxdu2bnNQ3oxGfcuaRKqlcj4ApEu9O6TgcJtzxv
INgGrXFLeoftXsQ2986tpDOvKbhSXoRnS1aobWBlJKoReoD4JoKXPuZRPXGh1fVL0VVkPKHd
N+Z4zeGb63anHC97kby8dounj3+//fwnmCKM9y06lePblIy5WTAkvoBfgkMw9HMSlrCIGjkQ
LyFuVvx0B4sBZFNi39I9ds6BX+IGOJQWyIzeIUGDR43hJAMYftp14MIa0+ZWkkbdP/R5pioZ
vGUoOwrZzCPy2AGAeF1bEFbBUYEZFZA33eMWaxDVoH6m8xgXED8nEzE2Palk4JyUlBUxYwWx
SvFMOtLfuFuq0RxY+qZR8m1BVBWVUZn43SXHuLLqArC0/qe3piKoo5rGw/CwipEOgBJ1ALY3
zU+tOcqi3uZUFJilHOjHSRqrIGIewvgo37xpEMIBR83XfSFKlLfMFDypb50bysYCcKeEbvK+
PNnVCNDYQddEG+tTAtT6RLYsCgY+ObYgbEIkdltMTQJT3TKXuQTKDWB3SGIGoPkV56IWXwbm
8DAnYBho4tMOawT6C67Hf/7L4++/Pj/+BZfLkxU3gsNV5zUaOvFL7wN4P+xNOoXpNC+P1odA
qQBJcIZ0CSlnhG6vJ/O0piZq/admak1OlUWiZovc02fwW67szrMssluop9CkE2vbgnDBrr9a
oyJg3bomhwPQRSJeoPIN19xXqTXY5GeNHS0hsGXszw7PQ2W57+y+nM/JVOqD4E9WUrGci0eh
P6mGp4d1l11UN1ylJZFgHmJ7pVXZUNZ4v1X01hQTBXG+QUdqciKw2aqmgijknLP9vYGRRcSj
S4pwxSWYV2ZovrQZdK34TNJxSqgdqjiQt59PwJ38/fnl4+nnJCw7UZX4rEO6PdKIf8lg6a9T
lPK5F+c6S7Aqc0IgLh66K7puCN5I30wQrasoJEdJNXKvQkSqq+PVAovKwTkIg9WSIkD9tY2/
rDGqGvLrDQgbQE38imF9bETMgAhwRrrlSIwM327UMWxCo4py90Ucjo5a7k5lE9kl6hSMcRwl
tIDXKiLYZypkCaD20joVASRjaUAUY2R1pqrL9p5aQK2eEM1Zt1LS9X7z+Pb66/P3p283r28g
iX2nF28LljlmdCqjlo+Hn/94wuI/o2gT1YdUzorFKU5Iir1j6gja/hwg+9oTiaMk57w3DO6b
+/rw8fjbk6u5uQy4DvITeWTT9SsixZbjZ8/swWAwXJx8ugjEmRtM25nbEhMFFPOptOmer8X8
1ZnffPx8+P7+4+3nB2gsP94e315uXt4evt38+vDy8P0RHlLvv/8APJ5oVSGoa8vOedkiGsHb
uZquKaKjvPX/oHBORHSk4TxuqkGXAZ187/UGyN5W0te1xdUK2IV0Ile4LCboM0oCoXD7El/N
ACnPe7vR2S6LKVg9mdZJf/lx2p6cDoejC5Dco8IVd8agiaPGOW78OC6nEJXJZ8rkqgwrkrQ1
1+DDjx8vz49yyd/89vTyQ5bV6P87c2uO94Fgc+tI8glL4wZRR56C/4Hg6tib0vc3jkUvmHNQ
Tilq40QWx66E0zegrk7dsai1fWUYCNciENpX5aSN6t7oK8DzK5CsmrJmowZtZjT1cP9r/ecG
fBzYtTmAw8CuHQO7Jgd2bV5LeljNOihSNBpraugMXn6NR8jkkCVKndFQSumNyJ0iKTUPaNet
LxHVpgk2j4pDlhLfraOLY77mpoNc/uSoaybQWroKCn58VCgTPYRDUQ3WhQQ23dkcm8YJBIgT
To3xRYRs9PBRynpMVUQNWXm48LuAxEQ5PHFJDN5ZCM5c4DUJt9hBhDFZC4SobhvNFlBjwRvq
ZkQE5ywqXD2q0yq7J5GJa+ygmR2NqlPtc0MheWFyo3hMHA8EROJi03aVbbjaQ7pTbl9tSUxL
YCp132MRofjdJbsDMOVxQcvEFY2WjihxlXx0gjTkf1cAfDAoMZiLXtvSYjLr+zNY+Bgelzqh
XoiNYS4Mv8Q2T1jUMcORCSEsDs0kkWYxlD+dxILcCnmlNzmeCvFTvLNJ+SWgxOJOjbLiNV9G
dgW72l+HS7J9mU9uIN6gfX0gNv9kkbNDLhZSUZa2rkbjYR/qc8thGqWP09pWg0vZHjdikyrA
qwUQx/UBDjfvjkZF9TYIPBq3q+N8+ti2CGaKwlkCEURIigO/4HMSo5z9SBXGkNv2uLwhJQaI
4pZ/dRUu45T2msdEd7GjWWIWt8EioJH8S+R5ixWNbOqIZfjOlyvCmq4R1h3OpmQFofJzTS3a
JI0NBYX6rWWvyNIoM/Qh4ielNI6aKLvFdGDbF1VVlgKC0un4K6PaqKJjSFdHcX5R47/Oyksl
L6uBVoNmgmL0FMUxHkcRAUVR3tAYYHmkKyOJPZYV1RJAAZtEdg0T5eWOZYy0GsBkMDmsOLg+
5TpWe5qDoAHXh2NSQ4tnPnZQtVEfAhSLc6tXM1+ixxRTwNjOU/QMXn8Lp2kKi3tlvkkGaFdk
+h8yWQGDiYto619USL0yqEt/pBmXncaJa3LaEthIhGlhvzdiKix6UoA3FS8huaJxI4g7KZLm
nqRTYlqcxXnZ4IjNCGiK689aWYmntYe51M0DPhOXlTRSHatTzrfnPGa46h4rLUGvI6h7RIqC
zZs+r7CpNAwwQMRlYWiCJEzvEsehXeBEOkccDlbOmhw2I5QUgLMAUv4Bp2ig7uqmNn91PEfX
moQ0p8K+XYqYU4rJGmfXqfcyJRfW57UYr02YpXqhxia3CKF0DonZlxpSKPH7zsxQsbsz1Bw6
CwPNRYMdSBrlo002qn0PRvDq4WJaSdx8PL1/WL4QsvG3jSvLmbwQ67ISx2PBLM+v4dk6qd5C
YOuMsepjlNdRwig2M8bbG5LBigezCdhh5gYAhwueYYB88bbBdqqXiYqb5Olfz4/YzR2VOk++
fW4nIJ5NQIZ2AwBxlMUgLwOVqMlgysZFxVdxhkdFQHe/uz1H4D9ZxSzdJ1bN0/FRKXOHvCnW
SGhsTC14iY83m8WkEADB92muEP4kwrE9g7/3iV1pDn+SC022MI1udY+dNMCy0QEnJbbc27dz
3LMj2kaHlpQRy2LYbeY7GGQdaUIHBoLHMWUhIeFmcit4mvM9uEG6anLzUPA8T7O9mSxYAPto
2b02QIWgePn96ePt7eO3m2+qf5OQLaLkMWYnCJr5OoWJT9XGiYtQx6XVpR5RiAcstXAQyS7m
laN01BwDimNFJGZEeIQILqymrZwQkTvMMSKqm6sk4tVxjSQ6rNv2GlFen+e+dT6SW3enChqT
Jl5aeiLHaB+uBTC8HPbiQqorM2SYhukIAoL1IDXTA5mlgKrbW8NbdN/d4gPbcXmBELi2/ddg
PjNaL35hkN/k1fip97qMGz26kdb7W4avWvV7sik1mBXVid6WmuBQkdcWXJZby/ptW40OOcat
up3JbKfx7oByccQo1XOcVkcdtsiCwHu/ae4ngSoHPDicYP6XlBCjJ5v4IdjDAxNMvSlnjgVr
RUdVA5y1kjV38vDzZv/89AIJkl5ff//eq4b+Kkr8Ta9arIsV9UAaZaMtVbEKAgLUMT+egv3O
3iV/shF9RRWPBKNr2lmIaw9x+shyxYKYudwSSD4DxvLIoLYuxcRkNrctEwTm3DROgVtNmoSM
RrrSRd0wad5HLCvPeKulzbEBW+neoMSUYKVjBjA5Qy6GSREzLOua/urOGSy/ng3CGAjbRBVQ
sXHEK8J0D5ZI6dVJrE6dPg/5w9k/dKptI1kYky4blgNF70ICZYCE+BqAIzygGqDPSxPepXEd
W6S8MsyNe1gvQKYlMT3REDTO1bKBCLzfpvHlRprZAH6y7RX2EZKQpLI601VNbkF2F/t7nYtp
koG+yMcYYGQ0L25VNhe1NwavW2VsrwMyO8Omy4icDZkhTU79XmLNNRSZyeaY9AOE+0mHezSR
DGdJkXXW1pqsIuN1KGu0AqKMq9G1SGXENaqHmCiuHOcyJuLHKp4c0FDw8e37x8+3F0iuOzKQ
+nB4f/7H9wsEvgJCad/CkQmJPmDnyJQH3duvot7nF0A/OauZoVLvu4dvT5BqQ6LHRr8bVi09
03+VdnDOpUdgGJ30+7cfb8/fP8yQdmmR9CF8jDXXw+cihEo6sQIbJbozWjJ8bfj++7+fPx5/
oycJL/aLlq40aWxX6q5irCGOauNJV8V5TPL5QKgOVd3ET48PP7/d/Prz+ds/8FV+D1LB8c6U
P7vSsCNVsJrFJW3movCklblGlfzIduiOqaOKJazEHdGgruFs41PKvZ5AGuuCpShkCQ8WNlqf
OHXbNW1nxRwYqoDEIMXBiGg34Cw2eqj2lEO8B4ZYmR4HbjcF1RcZ86CLLXtJldj94cfzN3Cv
VnM+WStoOFablqo8rnhnvmuIouuQaK4oeEgLn6q0biUuMOe5z3ROt3mMbvf8qBmUm3LqCXRS
UUWOaVaRvK0YpSav9lbaTwXrcjAipXXETVQkUVaSbvGC5ZYfHWIkQji5pN8TQ7RAsL7DxlP7
iwzTYTyMepBk7hLIrY5YprapozEY4hjXeiwlQ3GpvuMOkgRDKASyw2MRKhoHJps4gE7jJOqe
D+83lYP2jJ2v+wekDOxB4ywomj4p9KkZ/ZoZZEJ1yqfFZOR/VbabegmP2nIgi6T/vCaW8fmI
z6GEbZIhsXLxYPT5lEHCSKmOYtizu04PhpOe+i1fODaMZyzfnSZluwtSJ2tQnrNyAmQ1Cl0H
J5YMWyVX3t5OcyYWXyoYSBU9kJxxx/4cYsOOT7xRjXCEoPi0sA4XQU/ZUjyuHNHJDgWO7wi/
QKzFsJu9BObN7YgYalb0rN5rnOMD3WnXTqrNGzNmTpPIRcOnTNYQ/+PHw893Ow5HAyHANjJy
CBn/RuBRmBas6wGUmDkZDVWh/qBQyhQI/OJVmJtPnvl1owoZO1NGeKKDn0zoISrXkHpmEvCk
77Ds8Un8U3B50tZcJk1uwGBZBaq9yR7+MC4q+NIuuxW72OqW6sTrBCTelCN0j1MOFvDLtJiD
IFmULlKT9jtmn+iaxmuB7xPKRpjnNiU0rCwr15xWvDGCXgBMurC/mlUMEWUgLoTUkk3v/Cj/
pS7zX/YvD++Czfvt+cf03pfLaM/s2r+kSRq7DjYgEKeXTi72alUFSlPpF1YW3O43oIsSuuNa
0YJgJ67Ne3Agthz3e3yG8OQR3RMe0jJPGzJ9ApCosHLFbXdhSXPsPHPMLaw/i12aWPg48wiY
P1kIpGnTQA9Ca3HZE2OcJ7xJpnDBnURTqAzqbh4PUW4dCqUFiHZcGV6M7Jh7OanX3MOPHyhA
PARLUVQPj5DUyVpzJQjT2t5zfrJSICZG7lwmfBd3h7ad7AnHcxdwKqz5GeJc0kIJWUEWiSst
J6+ga92TY8CfXv7+CR5UD9KBRtTp1MHI7+XxamUtFAWD5Nx77LGOUBORrhySbNJwYzjnsOL/
ObQ8Rv28mbq8Jc/v//xUfv8Uwzi4RIZQRVLGBxQxcSejOxaCk8o/e8sptPm8HAf++pjiLxWR
DCxZWweTOCcLK1ECAqvs9ffdpWYOh3lMrDm3q3Quh3BM47dwjB6s4bf7k8YxvOSPUW5rlh0k
4ELvuqajiyxhbx5cy87Mz6ZfkP/+RVzbDy8vTy83QHzzd3UQjFIUc85lhUkKMbfNuUAIKeKa
IuNonxLgvGUx2WyHdmbAU2ryARnVETdV1Oo4e35/NDvEp+aXQyXwh6GhGDBSjkENAOO3ZREf
2eRqt9Dqnp0NPTdTSMYBQ+EiCdLdrpELv3+nZpUodfNf6m//porzm1cVuYM8xCSZeVDdgbP4
kHx02MnXK8aVnHbMrFUAuksmI77yI4RokaGMLIJdutOWMP7CxkG0KuM51SMO2SmlvmbFfwSw
TKYO7yw0aSWlmbPzpKlo0Dr/maZxAQTxuGJ6mH5nTOAV5MzEcbYQQuoCGIGL2jDcbNeGaE+j
PD+kfJ16dFHK5o014hgZMkCGfE7nYtnp5IzqsaNdD7F8sqjM7HM6PqWh59chK4tTlsEPWqof
Qc42Wp2uy4M+gnO46lgV+A79/FfXLdjXcsrTeQKw15slSOrdfGzO4gqe317Bt3Qq+h7v6mKc
CN4O7MLi5OxI+QWCWhB4pA0tl9U2hq5ZGlpwpYc1d5lP9ARijMDjIDVFdEqzfM5TpEToX3YC
ajEFw3gLFNIWA6EKgRA1yGRRwo8XI3GWhO2jXQ3pps0aZORNE2Ro0gHQxJUNka5l1gcGR+mS
Jqe+pTH7mK5rH7tra2IjAKIxnMO1OFXQi7cCL2suTl4eZOeFb3AXUbLyV22XVKRNf3LK83st
fRoNhHc5pGSgjqFjVDT4sdKwfd7P7SilA+CmbSnBvpiubeDz5QIJxtJCjAkHSypIlwU2Y7i2
Y9WxjGIwoirh23DhR2Z4KMYzf7tYUIZ+CuUbtnf94DUCt1pRhm49xe7oWXZ7PUa2ZLug5PPH
PF4HK0P8nnBvHfr0JtaCa5D2OFLdcdcZYmi6QOZFUrUsY0Xb8WSfkjwq6Fvqhhuvu+pcRYWD
5Y59uJcmJ0GaCv4jp1zbFUacZz51z2msSoKKVogC51G7DjerCXwbxK1xm2o4S5ou3B6rlFNT
o4nS1FsslnjfWY3v6ePdxltYB5mC2QEUR6DYR/yUD/IYnffoPw/vN+z7+8fP3yEO23ufH20M
FfAiHls338Rmf/4B/xy3egNSBtzW/4/KqGNDm+2Mpwb4YUUg0ajIODI6TzuOx9ODutx0wR3g
TUvJs5BJ/WcdFYJ9/xCvnFysuP+6+fn08vAhuvNu3yq6XhZ3ih/sOxWzvR2g81xWtmwbUSMO
ExQCJc+x3GWuLUhinRaXOzLvVXw0rfVhf0VZXNYO++BhA+rH2XgMRruoiLqIKnQCq3m8Kox7
YjiKZBoPM5GqxbkpMQqY6utH/mTYZZh1ldpPQ+qIJTLtpTELnJm/OiMctoRMbKEkFFLPdvth
s8jG6FaovOR/FUv5n/998/Hw4+m/b+Lkk9iqf8MHzMCLUY+1+FgrpGlk3BchEwT2RZBrxgCL
j8Z9AB0YbjP6+AaSGOQskZVvwSTJysOB9uiQaA5m1lIRZgxU02/6d2vGOKRfnc6R4EZIsEoh
R2E45ElzwDO2E39NBkQVocwWBvSxhMTfWMuoUHU1fGyUSFkd/T/msF2UKaqRfhAwjvByEic1
JyolntmruD3sAkU06Rbglgrn6tquaP2hdL/WUt+G6NUXXLpW/Cc3lNWOY4XdQCVIUG/btp1C
1RRgYKTtSAzYMfI2y4UNjWLi6xGLN8anNABUYBxs2rSp/+fAtykgHjYombPovsv559VisUCX
jCZSN6Wy5aD4PIMsj/jtZ6KSOj1oo1sw+iooZnfozNbuzPZqZ7Z/pjPbP9eZ7Wxntv+7zmyX
VmcAMJVSq3P7LBaH+8zJzycyXbg6v6tGMAmlvTRALiZ2jg2u45zXFjAVH/eN0GC5YPPk9VGk
F5dH1ECjeELqyuwppitfcF4BCfXh1AHzdX5IP3tjKiVcag7vT2vleVQ31d30oDjt+TGmLiO9
tQVzWNktvK93U5Dpxaj4pursOIDEYbw3/ZgBUM7cStzi8c3buw28rWefDHtl4ktDTfGyxByS
5vh5ctVMh4yRGlqFKkDxaldSMHBTmtRTVc5rh+W5XclXVnVpVXnrycaRKA42MXFD8Qhq/Jq0
nbSA3+erIA7FlqScyHVn7Z0iIF2fFMsemFomYXDVdSf4BsHFihVrH+13WWSIQZo4B5jfmpo8
BJ6x+h1qnFx/FhdT7elnoxoblouHkhufxMF29R83PoKh3W6od6TEX5KNt7VvSHUyThZKLi8+
V01VHi6wxELd7ntzRCVQO59YbMQxzTgrO9h/dnOOFs+THLs6iexqBVRG/p+C05ygjbJTNOGZ
LJZ+uDKwRSgHOeOx5IZUXNp75lpRPJYCvd2uhEx4kPvURMkcViZIS5vHcQfg16p0ZDqW6Mpc
6TrS52g4/O/nj98E9vsnvt/ffH/4eP7X082zeLH9/PvDI3o1y7qio3EcAUjGIEjFKs37wIEL
qwFQaFBgudspzp/YW/uUlEFVAxwY1QLOMh9FH5Og/X7g6UWvHu3uPv7+/vH2eiN9maZdrRLB
0RtCSfmdOzBssb/dWl/e5eqRpr4NLDvZAEk2flHOE2Pm0QfA5OLY+3LoKd9+iSnOVjtBGMN4
Oh25yRc5I68NiTpfrApOGZtUcGa0g5hGNinn0/dydXWkkK4EFkNGOl9IFHalV5C6wdyBgjVi
uA3FpQZX4XpDrUGJFvztetlOSsX3brNSSZDuI4cjiTwrBK+0pqN9DHh3mwDb+sWkURIeuGtl
Teh7lIR3xLbWoH3JWVyX008Jrk28Fykhl0QXaQOuYZNiBSu+RAEtxVUEPNwsPTrUlSQoswS2
jevDYMSl9rFZTGxwf+G7hxQOAJVBwywHvv+CUXcVq5PYGjAl2zAgqRiqGgI4cxvDsnW4mHzT
2o8mUvsJzBDUbJ+lzo6KvWq14sKKXSltK9S+ZOWnt+8vf9h7Ex2Ww75YmMyqWhn6VJvO6sKC
wlxZIMroQQ30V9uf3jCp//vDy8uvD4//vPnl5uXpHw+PWO1vbXfLCQkdx9pGxmrSIFQf31Zk
pHulizKzfwFbyHojT4NZhGydpP0HICtT0gEgMH031CF9lBX9YUdNmNHSAh2lsDM0PyNciWfI
xbU/QUqTyQxAyJsbL9gub/66f/75dBH//41SYOxZnTqd3nskGFpa2UF6gfLcZ9DURLF494st
og3dHXHKdYwFLMNGKv1iMo+wP6yADVIFSHYGOnI4RWQs/fTuJO6xrzheV2FrPUGjmUb5FCKT
saGUGK80QV2eiqQWPFrhqkIlWXZhIW3YOYW1dapc3wDvil2URUaiLzH4Oiwkno9z4zB5ZRVQ
0wq91oWBPUo6lO7Es14FouopzeCLoiU8pTkruKzKgpek5KlodmNY+KFIzRzRxiCGzx/oR3eW
q6kuOe8y42F6tkwSerAySDAirhWZYcAlAyLl5qUc1bHVIGQDkVO7oTeG/Pj5/OvvoJ/RLksR
yvVLROFYBYYKYBWI4xBcwlwOLJICTI8VBZLfCgSvo92IMGqV8Tzoe7APf7cTBxzf08xET+M0
bhkIoqJhdyqW4Cxh3mxWAaXoHgjOYZiuF2vjQh+QwEZJy7Vb/nW73Gzmv4Wpw812dfWzljxi
guwOWSk27PxgqUiOsyR3cRTORUkEp+Ymve14zsyzA5A857E71CHG2opVkianwzL1tPrhIbZL
vAmwtNdBYDIfvT/wn9wgwwHfHCFjN9q80ErzqD2n4vituyDGZ3CaIVvjc1krqVh/kNxXx7Is
yGqiJKrAUXaUGigAaKFruFjpUoe0No6jtPECj7ZhwsWyKAazy5jM94DpmtRMzRTFKS0o1Trz
hjsamkdfzZoMJHXJYgJx34r9jXSo0Z2dFBOT11QLMQFMb2kIdDKDLRO/KfsdABuCncxDnFmU
tXTfT3VZ47bL312xC8PFwlzPuoRiDvC62i2RuEL8UJ74J8EjyTyvBiHgZMLaGTw2iIdEJnip
g+IOaXsL0/K5YYeSDCQGxYzTSwLE5cBKUtxxz5tUug2jjhWt2Y5GFbdgEHMurft8TYbNJqCl
sdy1LSCGOI4SklUYiYDC5o12Fjuyc9gyGNWc2QnbjR0FawdJcFjcVXt0PiA4TuSA4btDSxeo
D8bgq29CJiJSPXJ3Yq4DTctrkUWPFuA2nvGBAdp5lKZ+wKM7YoAtyZqWZzLOkEarUEPUXMas
rm3vTYqKx3RoDkwkc+qSUQbaLo1x3PPEZO7GOpLUfgecMmb4EPveYtlOAOI2y7AMVhYjG5yk
y5YWrmgpQBcuKR4nybfeAvmTiQ+s/DV+5ssYC13LanX6UEMEjp8u3kGTpPkpS1EHd6lf4NxA
6vdg1TpuXwUXf1HnS48MiCLyDUMyrgrPb++P0eWWnK/0q3SFoFCHsjzYgZc06niKLikjUSz0
Vy19F0jDLePC9sj4ggBe2HQL+tnNDnQsZQE3N9SIaV1FBMLxkaXz6/Rz7EtO06PBIKSPJJmg
iYryKlcD7DaZ+M2iKc3pFnVvlkHrWO2yAE9J0wBMdl8b+h347S3IhNZ7wVsX9OooogY+ZTRF
gei+8zAIfVqHiGtNIaz89StR/LMuizK/cikWZvtY10Jg+qgQvCjEXe5S1wsW1REGW9cbrP/K
WVxQiGmSOrUkxRp0RF3eop0oiMrJs0MTqiS9OiTK1SujSgsOQpZrdErxfJXqBLaPOWVajqhA
Fj0GUlgvlpOHaE+o3mjXvlqL+bAMXwgiiM2MtJj6NzXUPMr5CQdX43BmdGpmqAbwNL2b/zov
M/HGEf/jzBV7I0Sk+NlZbqAmLk7AMtNhNQ4x/FxsaF9Y2xwaLYDwJLEpoRmhdnuIfjGQoxlW
DFt/EVAvC6MUepiIH1t5EYy/ve2CPDzgUY02QcViDz8vAL31sGZIQpY+/QThZQzCsbZxnIu8
kSfjtdUnlspVkvuirGjlDKJq0uOpQZvc/o1JjQOqgWBk/CKzbnLyemgsaSeqyqUSRSQX9vVP
HHjK84C6DZIEiViSdI9FHPKnipkyroDbPRKPipvMNCyAl2MNkR9ptaXkhXaOoMZKBKgMAA3B
R2dEd1EQ0GYUzEikqhCs2UV4H0mofgK9GkDwnbVARgBNCRGLNAbBvl1Yv31MjY6AtxWZVFxM
v5nMVAJQvD1+ERDEFaQJ6OAOBwizIxHKB4mxG/HT6VrP8eRECdiBHZErR5QnFkBLNvQ3RgGE
cpLcAZziauNc2n0aTRbAcEMAVdh1q7u9iGFCvVp6oBDEjYSKl2HombQxE8/jyKTUzycTmIi5
H780PmIq4F58Rw8B28Sh55HFluFMsXC9IQutt45Ce9amidk5FlfZiZv9UE4X7SW6N2kzMO9s
vIXnxfZ3s7ZxfFPzvnaBHix4R7vgSCP5XFe9g8xZtd0opRCNN1cWuE2z34IFFVdBlJm9LlpR
E6S00SsOGdOEi8CC3Q21ohhRSsRsASWzYgEFMzL0aNyvIEM2IY14JLUVviPqSKx9FlsT2UuM
DaD2DTuIHe7XB0OTWKnn+6iBrkgTxMz0p4ffQ+Ay0nleUkjLWYNJAKhUz8G/DOsSeQQd394/
Pr0/f3u6OfHd4B0CVE9P356+yegggOkTJUTfHn5Afj9Cm3vJiOgDl+c8am9ANfvy9P5+s/v5
9vDt14fv35DrpfJy+w7pa41GfLyJap50DYDA6nstir9aPWqe2bp+G47ZWbQ+zFCDj9h9dJtm
jnfuSHW8cEax5Oe8FWvHUJPtT19Yw08dGRJYdHfZFaZOXmkc6fqlwngMlYz0+AnV6+KMNb1n
cZrusluDN9OwqeGqdiv78fuH07FJBiE3WgEAGbKcmgGJ3O/FyzyHaLTG+Esc5BqxYkFaFFzG
Y7/NXVplSZRH4gpubaIhctcLLJvBDPDd6g5EUhT7DqfKMOEQV/uEHuIWlotTNi269rO38Jfz
NPefN+vQbvyX8p5OH67Q6ZloWnpW9rloylyxbVSB2/R+V4KDC5q7Hib4j2q1CmmnfItoS7Rz
JGlud/QX7sS1t6IFEAbN5iqN762v0CQ6S1C9DmnZ50CZ3d46HP0HEjtsC00h17Ejq9NA2MTR
eunRVoCYKFx6V6ZCLfcrfcvDwKeNAw2a4AqNOIQ3wWp7hSimRSQjQVV7Pq1qHmiK9NI4HuYD
DaSwApXVlc9p2cMVoqa8RIJJu0J1Kq4uEnbHLbNmYmJzv2vKU3wUkCuUl2y5CK4s8ra52irg
0TqHDQw6nmbw4mTigiuiRUeKRGbfpV+1mgD6rI6/uZYwTqli65wtLV9yCTJefxLC850F2S+Q
hr2HyAg1pUXpJ9rL26b3vAnEtyHBYgIx8s8o2Ipyv9CoVf9mPD78/CZD0LJfyhvbP9WMkUNE
7rEo5M+OhYulbwPFn6Y6VYHjJvTjjWfFbgCMuIKt1WaiY1Zx365OvCIB+oddmZVm2sBp4wBV
m90I7ueuHAS6dB0DlbN2dVKbdZ8kiqz0EOWpHbZh4E6puRq94QkWSrHTvz38fHgEJnsSnqRp
jPfdmbI2OxWs3YoXbXNveO4rk1UJpnS4Mjo4qPi1ElxHAfz5/PBCyCVkBKcujersPsYmKBoR
+quFPacaLBhK8YSR4Vf74JqOqegLqLhMZF3eerVaRN05EiCnCzii38Ojm9I2YqJYmf2RnbJc
73ErsRUERqRtVNOYopapXPjnJYWtTwUEa58jSdsmLZI0cQ1PHhX3KpT71ZGRMZIheM1VyiRt
ZBL7P0FakxnYjMouptTMQJlnxVBp44dhS5fJKhwr2RgKNizq4u37J4CJNsnVLd+axHNWF4fx
z6xoiiaFaRaMgGgp2bV+4Q4XKIVWBojuT/I4LtpqMkA89taMb0yzPxsH96K7Zn24fmmig5lW
zcSfIhztbYoDjlAlEbBXLibaRaekFkfBZ89b+dgDnKCNp9a4E3LSUksj68qfNFjAxl04Oqlr
7J6LiaiGbEsEkhXgVQEUc83iVZ2Q14N1vFqfz+OmVvm6iPVTqLAXCW1RXnQHbrhLFOXXklY6
Qzg661aR7rI6lTOl4JBoboi/j+c+ivxkjOFhawWRQRjZR/F9+wod7zvltY++NcJ0qrQhdKKE
mvKPrJpdOFVFP6q1wfXkKmBVzgQvVSQZ7qmEgqFol4AHqAWHeE+dTKdAYnhTW6FQJVIpTqSU
uN5HZI4jSYd9QhSAs70FukSQlbY82N8Hu7dyb1LvJl8eSx0vvZfA6wQkM4sIJilPSayyVCEQ
yk1v6PuIcCnLMAVMEkkEycNBS0CJpS8qo5T+KXoLTca/bxUAycLoqLYQgNY2YIc4BxIOYd39
1RpVqwNkjh2pSGcBsboO8TEFJx4YUSR/jsX/FT32VW7RMW69iDTUdDlShOI+AH8AR1pJTCXO
O1akjuc3JixO59J6piOqgsd2O+a/f/W7cU1lwgLMuQGP5Lps7ydjIbZeEHytsNOwjTHfkGIJ
x7bfVsuy7N6V7WHKyY9rR01cfYIcetXJeAxiHMTTUWlLpkJYcY9PZa84owb4tcn5KAXPfWCY
UweolABAhFsTDFqGyJTfAlRwiE4hrMDnJ0ohDRidnAUeF+aHuJnnQ67D7FDuWDMFVnE0SDJF
v4eXFSTUGAdBp2y6ETUL+G9v7x+ziaVU5cxbBSv7iwK4NsT1A7glwyECNk82qzU6TQdYx5dh
6E8woSdlB+YncpCDUc9TuQFDHDpBQgzfUgXJrfED58ulSVRICyifBIrWbsOVhZIGVIIbOdkN
5oyvVqQzisaugwVRZrt2LZczNtTSALGBe/Zd+moSjpyy3jif5uiU2+SP94+n15tfIfuKDnv/
11exOl7+uHl6/fXpG2i6ftFUn8T7AOLh/81cJ7FYq5aNAYCTlLNDIePHmAeuheSZce1YWMrF
1SYh7cKBKM3Ts29Wrdtp1CUFGzJDo870SKabkaeFFJ5aayiOiIzZajJzlZMNwZT6s5+y9D/i
CPwuOF2B+kVtzQetRiS35CSaNACbCASV57w/BcqP30T5sUY0t2ZtedbGVZaYDdRiz04nOsVR
Cl2ni7XU6OSLEjWdagnSUTKncwzhq2DInWerjn8pjsErJK6LCF8VqFzgiCpBekPzKkcijiNm
PI8y8Nt4mShBJWeWq/gIfnmG+JooG6uM7BIZ9jdVNXVNBAeEx5e3x39SD3aB7LxVGHbykibH
YVp+eDuwAt4iSE3Pihzr84BA/GsE9HmvRsRoICInQ1dJPzwUznZWmuCTaLtYU7dBT5DHlR/w
RWhe/DZ2iuGtt1oYZso9Zhfdiycem2+34FDr+v7M0sssWXZftDKK7izVTrBnLqXO8MGoEG/e
LLp1POR6slQ8icUZ5Yiv3o9qWgiu/donD2nOCnb1k+KxdJXmS8QFC3SVLEsvjO9OtSM/bD91
p6JmPL0+rg07TD9qrxBgLXH0h34g+XKTeYgtguvDENZpgExGAEHGdbaCledjis6MjN8XYvWd
tpu3No1TlSork4Elid5I5CRUg4RK1eSi7a+NXOVpeH348UPc+fJrBDOhWp4nFT3AEp1cooq6
AiRSSn1fqeaRd70kYKQDperELlxzM52lhJ/bcEWxXhI5XMKTbnX7+EiejzOjo85fcWR+0ljQ
aVjjhz/jLZYdWFAuw9ScfomRSTO9tTVEGiPKWEX2Gw+Evnb31dhQb3M1oE24sb5gRZntYYHn
UeyoRPehUMwWXbi3jpch5hxmB2dgRSX06T8/Hr5/mw6atrEgl/Bi0nAJJyNlKSVWHG1XwXTU
NNwpwtdE+3BFhsaR6KZisR96irNHTIbVO7Xl9sm019aarNnXknSUk+hdsl1tvPxytgYGbseV
TwGtg0scwMXXrjHT5ElEVgXbJfWi09hwE7RWXfaRKYF1vGpWYTDZbU3F16twTev9FcVd3oZr
50ArPb/VBAHVvhzGmszDAJvk98DtdonXKTEfQzbma/OkHq3uzuyakMytqwZOXJbl0eqKzDU+
nAb2ImSpQvp0/Bk19Ekc+LabOkoPPemr2aXDoU4PkSP5pmx2aUY9uXg9i+t9+vezfiXkD+Lt
iPfzxdPpDKUhTtni8j0m4f4yRE83jPEuOYUwX6AjnB8Y3otEy3CL+cvDv57MxqonCriym99V
cG7IdQcwdGCxIuglIsQTaqFkXk07Vy9F6gWu6tcOhG/sQowKFw4/V1ycjOdhUniOoQgCJ0K8
OGNXs5ZBeOWTilUnEJtw4UI4Ghmmi6UL422INaTXysAgSm/56GxodO7AIj+uqC2k6GW8Z/QK
GYHwZ2NoExWSn6oqu6ehdpYIAzfxA67ArwAo6LmXh2anQhtR06DwsgJDSwb5kyfVauQuasSm
vO/CsMrDNZ48eOWCFwjc9Iu1If7rC8UXf+GIdteTwAQ7LBwxSfgnSCj/MYMAnU89nO/4tEcG
sKfc3fky3rkLoZ+tk6b16GNCacFtqqTpTmKWxZSYls1DPwRLgO9QDDcTyvQYwVp5m8Vyfvw0
EelejkmMCIr9cLmXhigTbhfGIdajgB/x6TBBPYkjheBYObjW1mTlTbBeUcsBNWyzWW+DaZPF
RCy9FdEXidgupt0HhL/a0CU2wQpPCkKtwi09J8MqzHfBcjPTCcmQLbYLatYP0emQinGI/e1y
biDqZrtcraadklLFE99VCdn8ZLvdkjZ+VkIu+bM7M8OwRwG1sPDIpjbshYrZSxhr6cxKyWbp
oaPfgIemfr7H5N7CpwbCpDAmy0RRfK1JsaVaJBD4ksUIb7NxfG7rk2EqRopm0+J4kxixtC0a
MYrmdw2aNR1Ey6DZXGvdEudjGhA82GCX3QEcb9a+R05bCxkiC7BeEIwnLcfraW9DCJsz065b
bwEU1Hf2Ue6tjs47cGhOnoAXf324JzonbuyU5zE59tKzdK5iXqVpQhZt2mpu2UqtvezWpEUJ
X/vEGoFEYz6xIhNwr+N5TrVC3S5iZmmrJES0ms4vW92KkduR477xBCNLx+LANKG/d4ScH4hW
wWblMg7UNDw+kgG1eoJDtvJCnk97IBD+gudUDw6CeaFNAwe8Px3rIzuuvYCYHLbLo5ScAoGp
yLC34zCvFguqiaCPubI1pHhp0u0vsWlLraBik9Se7xMbOWNFKm5kAiGvIfJsVaiNbclH05Gx
MRCFuLg98utL3yPOI4nwfUezlv6SkkcaFGtiChWCaAcwUOvFmtghEuNtqcmTqDX1qMIU2820
HQIeeJuAvAwgZd569jqUFIGrSev1cv6WkDQOByiDZksxOGYXtsRSy+MqWNB3Rp61kChnT/pI
Dnkd4/VqSY5MWux9b5fH02hp9jzn64BYbPkmIBdUvqHfQYhgbigEOqS+FlL7ULzz6DY4HMQQ
wXwbqKkQUOKEE1BydLYrPyA4N4lYEreSQqyoia7icBM4no6YZunPdapoYiUqYjIZAvGdIm7E
DqQEq5hiQ3E8AiFeruQJU1QyVMGV1u/D1ZbaplU+MUTVRXJHTkPEd/pUU3fgOY9TvKOLp4v3
+4r8HCt4daohMw+dm6cnq4OV7xNnokCEi/WSrLqu+Gq5mOdYGc/WoRfMr1p/tVivHbfShnwu
aBRk3DpltkCVog5Ch5jDOvzJrDTGUb+gD7Wo9RcbUp5nkqxcxcVBGs7dZ0CyXC5d10W4Ducu
oapNxQ1GnA7ijbpciFuWxKyC9YZ4NJ3iZLugeRlA+bOsdJtUqUd972u29hZEC/mx8Yg7WYB9
jxoMgQgc6YdGinjubtV2ZgQLnqfixibu8jSPvSUOKowQvrcgT3uBWoP4ba4hOY+Xm5zYlz1m
S55dCrsLtrT8ZiBrGr5ZzW9g8eAQjMKVF2fs+WESenMLMEr4JvTD6QhFYhhC6r3DishfbElW
u4h8UvWDCAKfqrOJN0tipR/zeEVwik1eeQvi7pRwck4lZm4YBIGRRBvDqfNXwFcesa7OLAJb
XvphKZDrcB1RDTw3nu/NLblzE/qUPOQSBptNcKD2PKBCb+7hBhSQhs5ReOtfLUyOtsTMr01B
kolztZm7/BTN2syvgJBrf3OcfwIrovQalRTvT4RpLivTYYOAZbVbqTCQNbcLz6NOXsk9RUbw
Tg2CGN0NA5dqanx6ojRP60NagEenduMYs2kubOKJSqRHXGomfbMhOBXJi/SESaosRw8lJPxN
q+7CeErViAn3EauVZyE5SFQR8LSFaB7xfBF37QThbHuBACKMyT+ufvNK86ThYV+ApEjS875O
72ZpxikGNorMryIzaf8/xq6luXEcSf8Vn3Z6InZjKVKUqEMfIJKSOCZFFgHJcl0YHpeqWjEu
u9Z2zbb3128mwAceCVUfusvKL5l4AwkgkYkGsN+N57mjCOVcSvaMtGSVzysKMvE67TLBqRxN
IwFYo3lw+kWSyEKXrL9RvCrLyX26uyqMrgTtYq9/9URNMnwNlcN5sTbe+XI9UCiwcGmu+2F8
lRYywDL59YCaRPVEaHSjTn9pMhlz8oR6rnbWacUIsUieyiOZVNYxDN/EPV2C6By+ZFR06To1
k9Gy70jkm5LxHdkB9U+3FUu7tKLODgy2RndfoJD+LljZGv18er98/fn8+H55efb61as2mfVq
Fyl40m4+yGgwjL20yfL4xZWfMREmy8Cx4NZY0BHeKtCvQSV1tGr6sCSemjDwvdOVee+t1w2f
PwjYpkkTzfKFiEJGC08jcUmO6AV8xD1HIiPuuaSbcNKkGWtbXtXqZtcDMQ7N2utP1w2z55Ee
u7QF8b35wqenzjwncLIu01l08j6hlhxNuNDvtGBX0zWMF6mRFFJBRlPS1t8oSE2Cnw6svR2f
b5DMZZN6TEcRsQwepzlfVmy6E1naCdoh9JQLfFfvBEnz8VmzB8HWVGm3PlGPHyWP9JNj9lVp
vpdWdWY+hkboFrTtK9Uor9lp/6QjGpuJaTfzZuOz02wekweOPTzcjtufLZcJaWPYw8kqWNod
UZJD/zCTuGcrOeHUrkeiYhGZMYkGKnm0LMHhjNf+qs3FwZuNJt3EMMxo91Hya8p4T8dFHES+
uiOMLpHM89T/nkYyFPPl4vQLnir2HKNJ9PY+gc5An+erz0lfRWx9ioOgsxd5to5mgbuEmBLv
eUqerSMoMIRzFMWgf/GUZdZUr4xczfkPTUmSxKSBlLI62NXZsLIiXX6jKcUsiM2g19K8whOK
WoFLf2srBtIadoL18/Qh15ad7sicLJxhLOkrTw41hvDKLA8sMKlE2tlAb6frtKzk7jF2oINT
9da8hEpyV87CZWS9LJStV0Wxbm0ok5GGxHbivicCUtFQZteWGqSItmXWuHZ7THFldqt4FvjH
BMLkZliBOJ9ZxUdaYucCqHPvjN7bQNti0ISPKBAicXCloUfraZ2WZqtIj7jSSgvZZmr7wdD6
mjI6fjyclut5G4mu/02HQ/kbPtalMK6RJwb0k3CQLmn2/FCZTq4nLtzayp3tyHc1VVgkt4ke
7MWAcP1c0umwVCTJguqRGk8WR6uEkt3r6AQy6tgURmnaWh1LnZPstiZTTKmtFktMNYGtgBpI
qF8BWMiMQjZsH0cxnZL98ndCCl6uIo8BtMG1CJczyjpjYoLZZ2HGONEwWGuW1GGmxULWhrRv
9ApOluRMZrIkZL/B26Y4WfmgxXJBZQc1vticUg0wWcwpV6cWj6lomSBofr8UsIrJuqL0TQtN
SPs7jalJknjlEQDKIHkoPbE0m8PnfBZ4itcckyRYUPO0xZNcE+DZSU5c0vQc3yZfTWjQFMmE
eLmNPUEMJia8eZstIrIpNEWIxEJUtj3fxUEY+bGlV6Ztw2qhs+j6XDVqR7R4pd1QWP8eiUzZ
PUynWIbnSAPmKus9kvZ6vLFq5+iHAhE096e9RimeHtdUAZ2MwbYtX1EDvs7aoxbt0DkRrc5f
Lg/Dcv7+8eNsnIP2GWQVHroQebQY2Z6VNaiAx7/AmxXbQsBC/peYMUh9/etKylqtoiwRw0vV
X0qRbyF0MeNzUqemhg+PRZbL8CB2+8APtFpVDrZkxR4vX84v8/Ly/PPPm5cfqEtpR3lKznFe
agNzopnHQxodWzmHVjbDnSgGlh29apfiUCpXVexxZmH7re4sQ4qXZ54y6kcKf/FpICn0bl9n
hqZIFVHra5oPG6cC7FqDsfbpgO2hyqZe9j2dH97OWBbZEH88vOO5OSSOPve/uIm05//5eX57
v2HqxCc/NXlbYDguVurO972Z04fJePaqYkv33le+Xp7ez6+Q9sMbVO/T+RFj6UK2/raRwM13
/eO/ueMLD7H9vVK20vqwCa0t1UQnOoykV3lVN5xCskrVcrEl5VWsLGu7r40fcvsj1RFEszU6
jhpIQxwC+4ui0rb1A029EnCJOEXSALook+7JFnO750MSIe2XcsBT6LiWzak51vXnzor08Px4
eXp6eP2w+wL7+eXyArPD4wu+y/zPmx+vL4/nt7cX6B7oiv/75U/rikllQhydfbTNkbHlnFz/
RnyVmEY7PZCj8/WY2gxqDCHxZcWbiN6UKjzlUaS74RiocTSPKWoZhcymi/IYhQEr0jBa29gh
Y7NoHroZg/V2uaS05gmWBqtmOzfhklfNye5uvN7fd2ux6RQ23ev9pZaUTdlmfGS0Z3HO2CJO
En1iNNin1cArAuZutI63M67IkV1OJC+CuVtrPYCDyFt1yJPMQyopIPfjz5K7FsmM9pI/4jGl
so/oYmGnd8uDWbi0S1aVyQKKsHAAqGPYQAc02WlwuWtazp2KG+jULCOOTTybu6KQHDsJA3kZ
BETHFXdhEtBHTQPDCrbt/qGK8IKSu1qRh1BD1z9Fyk5f623YiR+MPu5OS7IGSYcJ/ag+hTFO
OvaqT3bv87N3hCyJ1pbkJCZVGciUv7QKj6k+HM0jkrwiR1FsXpwagD2KHK5VlKzoyDo9x22S
kNuKvkV3PAn7XahRs2MtajV7+Q6T07/P38/P7zfo5Y1oyUOTLWCPQ56B6Bz9dtJI0hU/LXX/
rVgeX4AHZkc8Exxy4EyDyzjccb2vXJegvLVn7c37z2fQniyxqOSjoSu2tCbS5ldr9uXt8QzL
9fP5BT0onp9+uPLGal9GgdNJqjhUjw+sWqXPWPsSY2yHpsiC0Ng9+LOiygvaqZXBqWw2Zm1Y
Dvtpf5H+fHt/+X75v/ONOKoKcdRryY+e7poyN+6/NBS0ipn0K+7dJQ1sSWhcYdjg8uQFIYHl
zIuuEt3fjQHmLF4uZtdAz5eVCE3DBQtbeEoisciLhbptuYXNImMu0VGM/kPfIGhMpzQMwoQW
f0rjQI9jamLzwDzMMjJ2KuHTmLoHc9mWzrFDj6bzOU8CX73gGNWfOrmtbz7U1fFNGgTkeZ3D
FPqKKFHPVa2bE889j8aYzz2RQY00YVn0V3qStHwBUq6ddPS5OrBV4LuxNQZxOIvJS26NqRCr
WeTp9S0sNuJKL4mCWbv5hfxP1SybQW3rTwUdfA3lnusTIjVRyRlMvLw8vWG8vC/nf5+fXn7c
PJ//9+brK2zM4cs3d8vubskkz/b14ccfl8c316sw2xrBCOEnPuslH2YgZnn7RhIvuElAN6+T
S05pF7IVRr0et6xjrUcxAIzfFQL9ENbUnWqmuymFH10GWT6cBjfGU7VLTL6q53m5wQ24+d1t
xXsPxpY8+Q1IrTjGL2rqst7ed22+MZ78IOdGHjWR1pwGH7p57qATZN2maCt0+kqXCxM19G6k
CWGVFwjy6KFhWzQ6rEuTH32ak+XC7yj6Nq86vqvyETXFVeZvDg2DT7NHt2e9Lnbz8uqu2dp3
ytM07AjoCGgDCy/KGdn7BgYZTxRWxJXpNc6BbVsvzZWZL8dKoWsrLTrPpKVpZD1LLQM1Z2/n
RFHlzWsjaENyZIORtm0OnsLu68MxZwdddE8aIv6k4nTlqGxgVlaUMUkeLLR/j2i4Mm1GtGxJ
tzolRqDyN+fK8whMdivodX4QhqYfrO62G2rPIPtyxWJdC+hpC/P5VE+NFuQiJluGC7tNqy3b
0m+tEP10Ku0P1nW6o5QKWQgVhgK9bht5bRg6Le7V1+zy9uPp4eOmAUX5yeiNFqJLWLdFplsL
jFInxBBeDHExb9avly/fdN9hsiLkLUZxgj9Oy8QIOq6jWaPvmPyy9Y9zsWfH4mhXW0+mLMQ1
rrRo2wPvPsHka2bpuK5Pcu9hktWQsWbWbGOVp53pb6b6VrczCAuet1VdZnaEadrDn5/UhZWM
W88Fp1qtbgs8nsf1pft0KNpbbhWsWA+xO/qW3bw+fD/f/PPn168ws2V2oLHNuksrjJGp9RGg
7WtRbO51kj5ghmVLLmJEYUBAlqWGQAxv0B1zTlzXYRbgv01Rlm2eukBaN/eQGHOAooK6XJeF
+Qm/57QsBEhZCNCyoCnyYrvv8j2obMbDGlkksesRcnZCFvjH5ZhwSE+U+STeKoVxQ4GVmm/y
ts2zTreNB/ouTw9rTcvC70FxMrz4Ym6GOdqgypjRaqk3UxNFKWtEqLA1bmf6Y/Ce7tjdYwPJ
Ean3fyA2Fb2ZQP77dd6G1j5CZ6CDPiEASgKGhTMyX4C2JqwGgyqZUYeuCEHPNAfAXLc+wjre
mgxj7FGz2kGdR8Nxg6hiKhAk21JtAnzXkhOH3pi6gLY4UudZWCVL8yoE+1+eBPGSji+LX6C2
TgvrfV1+OKSugrGX74tDRYIYQvTTIbcy3aP0u6wJp4+WsNBK7fpwSOa98ESmh0IPWk4HsYuJ
+5l+0jCSvM0AsK8wnN55I+JbHRArzNEJv7vI1GMG6oy6BsJObnXCozQ1wHkSA+ek5oamx099
lJhiDYPMLJPWJfMaps/CrOnb+7a2BEbZhra+w8TqOqtr6lwDQZEsdOsZnJ1AfVGhtsxJgnYI
L+ce6g4BZx5Q5tX6Z8xHigqLKuyf8iOpeRg86YGL2uz06BxiexLzWH9ZLytWGmqaAySHLr6v
q9xoIvQHHp6scaZo8mp8ay2zA+ZOLOpM09vzqqV9ztMrb6T6INeC9cPjv54u3/54v/mPmzLN
vFHiAVPWEX3EsamAiLixRsYhZX714eKDI3gCsu2mJ6R/eORBbC+RAyYdmBFdYOKQ9ml3ZZ5R
ojnbsZbpTTJhXmMqLfWsSZJFQBVUQsuAzvXwwuWqcGnkuaLz1qAq2dIB2rQ8SGPdXzD5HjVO
+TjGYbAsG7oo62wxC+hnMFpG2vSU7ml1bOLqzbjJ7v6LTj3kGlQJfL2tx8zL9KgpsA2qzV/o
/+sACyCMcb2qNchRTyimtDyI0LbM7/PuHOtNEnh92BuaugrRAtq7M1yBqL1qK7LJGaxo8/1W
7PTsA05HcD4oMTrjMFydbPAf50eMj4nZcVRJ/JDNRa5Hv5K0tD2cCFK30UK3SGqj7nJ00gG2
AKWdvXVe3hZ030FYRUIhiqrAAn7d2yLT+rBl9IHPTlropKwsvTLlQbGZ8/S+AZWT2+lAI2xr
GSzEIyuveKcHgJS0Mk/NKEWS+tkXkl41YbUu7CinOr5p6XMcCZawe63tyEUaA6QsA8R7CnF7
n9u5vWOlqCnffQhi1Bpe7/VIITIb963cP5vUIgXlzyIJi/APtm6tBhF3xX7HLFm3+Z7DpknY
aZSp8i5tEnNnoID+XB9pwycJ19sCB8SVfgXKWAU17esOFVRba+euYvfSnNGkwnZTdi6Lt8Cn
yfVGWOQag4nm9xb1UIpCNqxJ34vCJNStyG9NEixAePIDPceoJY0M/dpTyiYXDAMTWRJhpMLM
btd5TwZlyCetZyA1fp0Bl43rIqDJuTlJNRgIusW+yq3ctkXFrBJwVjj1xFnFD6YTFUlGz6mw
clDe9yUuclZZkkSelxi5N7eyAvKb8mARQQG2Rleb53vYkhtHXyPR31i8Yq34R31vJqFTnZld
FMfaLjDMBhyK7ElE7GBYOlOe2GEEThVfwTumMID1XddwahMhZ6KiqGp7wjgV+8rJ4ue8rbE8
HkGf7zNYyOwBpxzNdLvDmqSrzUf/y1rsyobrp7HUajuF2zQ0gjHbMrpnQQe3tj/THJcUfEfr
GOoaEGBT25jI4wljVt/tVVhUvQwe8QNsZGdQSPi6q3ewZfKcuSFOGMgjGc27YbtJn04gw6Fs
Cjckn8YAf+59CjDioLdCVTDe7dLMSt3zhfLAIesamWRse8vsFunNHx9vl0do7fLhw4jCqF0i
NVLgKc0LOugroioIlS/q4JWULDEs2+b0FZG4bzzWY/hhW0OTqXtg+uK/or+tQPERBRl8ZJ/f
WRMx/urt+AlaZy2OElm3uBLsQSXDKM0pxnTOs6FhgMPVZ+VnbkwASYZ91GIeMysNuZUNLFZJ
DI2dxEimz5cGfEHGMRjRQDcOlVQVRsrYF+t0X7+WPPYrRZUMvlKnLT5HnHyB2aNxfJLHUpav
qxElXfdOaGRXJRB1N9Q9MYl1V3ED0XhKP1VDbDdlTx382Lg1t/A8RJUM/UNm3GKS64RkGg8y
zG/d96smTnrtNPp0FlpeWSVZpAzfqfm+EmUar2Ynu/Ngh4z/tIi6iwlrpNx8fXm9+efT5flf
v83+LieWdruWOKT7EwM7UQvYzW/T6v53fXZTBUIFiN6WqOxIn8i+guGtvVMZoKgtkzV1rqIq
Q/pXGPqoUyOLcDl367d/W+iTybdVNJMn+GOVidfLt2/u7IJr1Vbd5lhJKEAFnPfmvWeqYVbb
1cLK/YBmBb+1uvwAVSLzILsctLl1zoQHn1Rrp3J6jrShXZAYTCwFzbDwHMAbnH5fO0ZZe791
hIO2y493fFr1dvOummLqpfvzu3r7hO+mvl6+3fyGLfb+8Prt/P53usHgXwYbx3zvqx/12NDT
IrAl0o9CDWyfC8MWyvoQz3f2HlS+wTFswtI0R6divvuAAv6/L9Zsbyh2A0151qvYFVAloCep
ceSnZrB3Oebtmstl/MDIQMZOqrkRpECD5aVPhX81sHXeU3OBxs2yrG+rqc5IuFPghuarxC5l
ZDVIxL6G0vD0tF0bEwjMYHON4Xr267TNKjrho1K6m2PPQdUVQkdah0Ooa0/UqYOEeHFHJls0
dbH2I13qazcF+y5LNUbeNqR8oAtPOQtOzpEWhyDFtqLlXgDUSTnGPdWLHCD4+KvU64Z1R+Nw
K4eNYwcrOzr84ml70G7/JeRYXiDV4unHloy/a0FWf5S0fBmHhgoiqUUSrpbkSqbgyPJf3VNp
cyoF5tEsNG22Jf0U0ZfX6qOYfqnXg4F+K9fTZrq1mKItI52vFWln2FUgAf1PL5JZ4iLDbmIa
IkDcpaKGCqaHEOCACdiqUqNITM1gfLI/VqYBnXqDJ0DIYHSlaQn4Bey1N3Yzj3S8DibIxhqi
U7tDkUvDVxPG9/XS0PZjOmHAPBHb0IH9yo3VwMLW6/hzzk0fDyOW15/ph3cTyykJPE5gepaM
zyLaX4fGsNS8BZn07i4TbkVgZKFlaDccImpbcTVHGA1kRTuumDh693IW0PI4jZahCxS8hDGV
+AAz9MuAnQAhfbP0uAzKEJJtI6FgQe9ODaZoQZ2yGSyLyM23BPTHn2PdzGciCaiqVwg22JUE
15+i8JYqERXz12UZXGw4n/e+Sq58zWE3vwqYW6IN7AWiwKW30Lf10GcaPU5mNH8YUzWTV1FA
hgYZPz1GQUj0nha9uRCNwDMYU8mwfcF3W+ZUoE8rIaxjuDpPng2QH19nulOIM8yiMCKHmUK8
kWu0XhTi00uiYFDgVUoOC4W5snuvDA/vsK39/qu5L61qarOvTSCh5aNoQmLahY/GEJODEmel
JMYQb0VJb5g0zqUnrtHEEs4Dylp/ZLDieBv0mMyf9N56bYiI29lSsIT6uJonIqGv1HWW6NqE
hgzxys1yxatFOCfKsv40TwKyA7ZNnHoeLg0s2I2uzfKj1zu38yhXwU7ne3n+L9w0/6LrbQT8
Zb24G00E+Pn57eWVHnYZeh1G+xzzNcxIdZVzZW5eMdcWGbcI+X5r2CIjbfRrt2P7fV5yE0V3
tXraDN39MGifLSZCqdDykgFAM7LOQD/R2ycJ1kzgxujDJKO+fUK3nsa2qilPnWIek5AmQjtM
uqu2FbXkTByToOwO5bgekno6IWX4Ql0S9MQdP3RG5jnoeSqhsUnSp8v5+d3oIYzf79NOyLJQ
SVXMeko1NmLXsmI8Cwfy+rBxvdpI6ZvC9FDO7ySdvg3oJZFZAaCr6mM+2a/rXRLR4e2X50GJ
YtrlrKFvOqxijEmnWr2ywykreFMyzX5+l83nRghv9Oag617qdyf3Z8Gf0TKxABnz4fdwoKYb
tsXVYK5tmyca1LzIfw8DrXNX2JJpUXhupxvWyrcHTf/gZCTjm4MenMJN9OS2lg0XG9fyedlf
g3RVzrllzjoy4us8eZledjV5JawzGKf8GuA4nNdzodWL+kK76tPN5+FHlxYbk9DgnLjN90X7
aZKDQIbv4npAv6cDiJEuRBCB3Xxa88iUJK03bftFBPa5OFms7UF3LYWkagOLj56D44a8hMGp
k/AztK5P24MxbNULJEOiepNU5Xv6yPWYNaTjBBk5oKhFqfuuMaMlKB6UbCQoqfucdPSk4hGk
vLClHHmdarYQioiLIe+veKe3Pr3fg8fXl7f/Z+zJlttGdv0VV57urZq5iSXbsW/VPDQXiYy4
mU1Ksl9Yiq1JVLGtlGTXGc/XH6CbTfaCVvIw4whAr+wFQGPZ//16lrz/3B7+XJ59EyGwiFfv
5K6K6yV5DvyqFtWdeR3fyVx06mhrhILRWNElGnqRlz6/NAQ0aah7OQQt4T+3mx9vP1HDfNw/
bc+OP7fbh+9GeASawuqNdEnWZlYGcqjaKR4crWruuH/oHjbP28MGeilYAjvQ08vjYb97NBwl
e9AwIbybVXOG7kDGBipSfsd5xSilVy4+aZlXZREXjbYTJEImRxh1ocQqMpFieH407WXQf0nh
yGRkC1EIy+BRgf1OkQNFSVsWjPiywpeRE52yzMoUuGYrqkvLNKi9afuGcQr3wKirkjuHe5tv
jj+2r5pfrLWc5owv4qab1SyPV2VtyM6KhlXxuj+ZyB1mtTFWMEvjLMIewncnR7CoQq8f0W1G
+lesr6/GIIgjP6sudMwBtdINneBHF+TlzHgXQa2uUJ+vcjoxQtKyVZx60ZKZxKo5Xm4rjD4D
9/gvaJukLaK4DsqMDNu4zvuej3d0zG69fVinrMz9XWRhXCcRnWgLcd0qreMM7v0TFL6q0Uy3
m+ctrZpjHHcCqyxrTxN/unVB4Wk9juMqPFV/FEYB8zCNMjV4kJYn8HXQeAICSCx9x/ZVl9fX
nvUsCHAZMM9D5kCQkUZxKPaXXT1bpJlhDz1rv6QNCAwnZkSRiLxinhOugvMDrmc8CzxOkkkl
3vvoBFlJdfqTIp6MB4yON3VjjAjOfFaxiBiROpj6VG5JxCrj9RHNChZY1JsYRe5GYT29hBvq
BA38H46mSbf0vjz3ImVcZOXqBEHJFg3IV/S8SZKlb8nxtp5h/PepvDe6sqrjuS9ghSIGbn/a
BW3TeOhynp5aLYj2bb4qlAIjh0Ogpex+euPWvn7jNukxt75EFCVP0oB1QdMv8pNUiSP2WQT+
cxFuiDCvaJFVeNBlp2Ynm5/CgjzDhB37KSIRsvEU/o43cf75yr+K0XS2YfWpSlAxK6y5MbVx
w4omtS4o9bWzte7YZW8CzyxLbM1PbSBhEAyQggrYLM1CgefdPp5xEWz2rAF292X/tP/2Pr6E
+exRhbF0J4NBC5BY+a7d6e83YNbfCofhTuQFBATG8bVVSZgxyQxl28OBQYY+VYZXX9/rsPWm
YtIo+q9Bicu5fDUe29RSj+liNLC98VARN4VyxEGBCtOE+0T+nqYJcorBHhsci/Tpz2iOfMDy
pKmoYll1qhgcaI0h8ArEIhDm+b+IZ6Lq6IMMnWhF1BEwjTkfc7oFLZqGOAh5ERmW3gNKvNfa
Q215UAmvkDlpM6DR9GoxLSpalrGi1Dbru7aF4VbokrKpMv3Zv4frKpQE/enCTLMHgx/4KgyS
y6KtXEKY+xhEPW2VS0u5vhL94OyhhJMkRZWz9c0FmchbI+Lp5fTi3NMOIj1JmU2qC+qdQyMJ
ozD+/OnK00zIUUTpQooRQXyfKchwHVjxKi0w8ahz7oVP+4cfZ3z/dqCSIEJ98bJBo4xL7VlO
/OywOuOzBVk0UI7xyKj6hwUBXEhQGm8SVUimxOoV80g82sbAnLTw/6WuVRcwGdbcAI0GLFIM
3b5sD7uHM4E8qzbftsIY74xrqhwlTf6CVDsyRUv95qQP1Z5CGgVWjPMGjrZ2TlumszySJZyv
Vm+f969bDKFMvGbG6EzSm2GMQZLdErKmn8/Hb0QlVc7n2gMV/hRHlg0Trw5ztJL1YxBgvLEJ
vFQSkgK82SmdUQGBFdl6Z0J4GZ79D38/vm6fz8qXs/D77uf/osbqYfc3fLrI0jU9w50LYL43
H7aU3olAy3JHeXt7irlY6et+2G8eH/bPvnIkXhAU6+rj7LDdHh82sN5u94f01lfJr0ilxen/
5WtfBQ5OIG/fNk/QNW/fSfzAepeYNlLtuPXuaffyj1PRoDyAhbLulmFLLgiq8KCn/K1PP3Is
Kr/y8Lwkf57N90D4sjdeKPtMzCJDtAiC0JWFtPY03oc0sgo4P7gMWRGSoZp0ShSgOFxr2gOY
hh5ybdFoPDtSUdYYRORO7ThiV8RUKow18sVqQuJ/Xh/2L/0bK1WjJO9mnMGNSVrJSQLbgaEH
D+Ls9OKGfmHvCeFKnk7JdE4jgUxv9GwhqqYwA4n38Lq5vvk8ZQ49zy8vP00csHJfohAhxXVi
aoiatoVIyUeWotFYNfiBZ75eIYLSiOYkBc4TZgdx0uep0RlxBAMnMK/KYm5CG4z+aNLBSrZo
0DBZ3KLjmwmw9fKRQsbPzuM+QBu1bpA4ZDfn4Zr0I0J0w9Pzi2uz/hlbDOtcNLDfHB61+gfS
FKk/y1ytA7V/GSN1yz1+m9XKtYlM61sR39EVAlX+ZPHmN4p8Nr22GmBnL7x+f3XM40bL1+L0
BDXr/O3rUZx6Yzf6R0FUvI9LPwjzboHJGmHRTkwU/OiqNesm10XeJVw3CDZQWNJEyT0c57nB
ZJjdGuhFinmmMfNpBCdpWnyRYdbG3RMG7khBLN4fnjcv8A2f9y+71/3BeG9TLZ8gG9gSpinm
YUgXapnob0+K9SqiuvR4rQ7vUqMOJg2KZZTmlIgc6S7YwtZWH7IASNmM3uMSX6FmP2K0I5JK
LRkj0+eu2mR19nrYPOxevrnrlusRYeGHlGxBgjXWwojA0HKNiYjaPL8zQcCm1X2OyFKPn6Hh
Rnce431nwM/grCFvULnwzEgiCvYLXQYQ2AosG48hShydE8CBTT9dcc6p4Ktjx5qU7LBj4TT6
IbtfTdOfV3Pq/byJh5ic8E+KX9PBGkdUVpX7ogoMOi9r3xHF05KyXeVZmpuP1gCQokDY1NoN
I3RkoVTGmYJuWzSkLgIfWPXT1TrYZYzBHT5Ui+NHZ+NCFiZxt8KID72H0PhezbIUn8qAm0Fj
Fa4HLQYQiF+ssniYSefZrICbWrgRc9HpChsBgMtHROzEOg1W5UL0puQYLDXMXBSPw7ZOmzsL
Y3tZIGwhtH8yJujQ+pcgMqwM8bc/biAHuVvMoCbhxejAAhh9TAMQSENDGTNgUCpFRxT6/UKr
tVuzpqFWwRfZ6Lv+m5ipL+QsIdTxgRCkGBYVvb2pj7dWTY7SCkBu27KhNuHa6pBRiAyvjIiy
wDiqg+uNUajHod4rpZkVpFqxmn5dWc8IS0rFMMz4xPiGGMpvYkywgnTlJAz0w3FA4ORR8yYJ
+vDPjC+y0ph3HU1umqCxV5iCUF98wInVJ86Xef/1hyYHmroFnp/Bzrjr/BZ9kpo4og08yGEx
+VnHxuIZOhwaQXGLNBsmejzWJ6IA/WSK3tnUies7KZBPN/ywekgXoOKuM+PDpsCPIViaFw1M
bRGhrcedjdc7FRdhfVfZMetHPA5c34IDyN2IIypo06xJ4ROl84I1LbDDZOWEpaYEkVexwEiX
7LE3zI5WLLa19RNNgoQea3zY0TWWNYB7QtyEtA+oxFsntAQ2dWxUeDvLm25J2eRLjMaKiwrC
JrOqBEgfe1M3LW3KGb8w9raEGaCZuJQ0QAgAwraP3LElfL+M3ZnnxwDDeFAyZCj8OU3AshUT
UYyzrFyRpGkRxYbiWMOt4WOLsZ3sIobNZBjUWfFM4ebhuxHfmqtbT1uikpVwjjyHIoHrpJzX
jBIJFA2xAySiDFA0ArHC854pqHBT0pbG/UDkoKI/QSj4GC0jwRw5vBHweDdXV5+sk+hLmaUe
w4x7KEF+/DaaqVpUP+i2pcKq5B9nrPkYr/H/RUP3DnDGBZBzKNeZ71hLSUTNMyCUrh2TUmKa
i78upp91js0trOlXiONYMZ+nui8F1+P27XGPSUzdYQk2yJxxAVp4khwL5DK3rfg1cG95htIY
9S4kKIGnN44KARSpP/ISrsKytlBhkmZRHRd2CQwMhUGHZIgRu1DVovpCMPujxXpcF/qZYPmO
Nnnl/KQuNYkQnKE+DUk7h/M5IJcASM/iQTo2Am4OMZPm6RwtEeQ06E+K+Gdk+5SSwf2kQzsp
l74I0lZCP/9E8t+ZvWpZ5CwuhZlZXE8sblga1FvKG/d2Yh3p8FvGQNNgQWw1IgDW9RTYHXFG
8WUmuRjqOAhSqx8Kgjn/UD8eiTvK+JQDSXZPiwgDwX2W0ll/RgreUGZrEs8wjgkZtEsV9wkg
4yjaJolx8ciIkIY1AMvJOeG3LeOJufEVTDJZ4mQ/UVJSyVtS208KG2FYTkykVMwttxiLQlji
0II9RYnKYF/8lKGAM2MuiferDRTZPR3dSSOgrvWxE/fEtOBSIGfjYoEHZyCe5e9p25OBNs6D
OIpIU8jx69Rsjjmwu55NgEr/mmpX1drP4OdpAecdzVbljgSaVL7j47ZYX1j7FkBXztbtgT7J
sCYalTA0b0ErlzspSdCSvEWZk1vRqa8Uej0DiwH3TUuDAW4EC5LWQ8btKCDIAGSo3xFnjWUN
alLCyhqoNG23Ql6MyHcXmYT+siLV71jW7iGuzt/o3onWx34PaZjcZvQRKDL66YMa1O+U0MdJ
0dPjGbr84enf/QeHSOqQ3eGgDYG/cqk/JorRHLn6EqXuP9oDA906aYThf+g+8sHuMuIWaOAg
dv/VBYHG9OrAknC4NiYEuh/0iQrk8GwC4D2W5o1r38Dy5lrVqc4NtZRWLK5L3wmDLmB8Zpww
ICCjswbNARVWL/D3cmL9nhqvIgKCzB/1tIlII4QRQviK0Xankrzz+E5jaqHCx//PRAQ3Fdcm
KqjJUETI4sYZEpkDi1KORu4gHVUUuwEk1Mk4F58XLt201AOiwTlo/8SpMBocghuqRdEWdRXa
v7u5GSarh/pugx69ruqmMyNAhXGVGEuhB0jRWWeKJHzk6ynztdTQPKRKuWgoqwWYoWIALYlR
x6s+kafGrq0wVrpVsRIjdJizC0YoHb1gxAvJC6OQU4tEkuk9MWvAZUiaBEbMFhv8DMRNRW/X
Qvd6hx/jebs77q+vL2/+PP+gLciMD7JyB7IyXeFI8nn62VjPBu4zZbthkFzrRhoWRtNzWRgj
3IOF+2WPMRmGp2I9+7GF8XZGT2BsYS68ZS69mCsv5saDuZleeXpwc+kb6Y0Z5sTEXdz8cgo/
X5hNprzEldRde9o7n3i/M6CsWRfO5vYXVi1QalEdb30nBZ766qNMcXX8JT3QK199dJoRnYIO
MWWMkQpaYhBc0KM8t3q7KNPrrjZpBaw1YRjwAdhqPReBAocxiH+hPVqJKZq4rUmrJkVSlyAc
66GyB8xdnWaZ7r+uMHMWS7jTIEaCJ6Mx9/gU+iot82xE0erJ+YwRp9Sgm7ZepDwxi7TNzEis
HWUUJ9kWKS5tjbuSgK5Aq8AsvZf5F4c8wpp6yXi8llat24e3w+713Y19gReN3hn8DSzlLXrm
u0qEkQmOa54CewYSKpSo02LucVrCqPZx5LvP+kefnkDX8wGblGB+O5kmw0KJt5ZeX6JrA/t3
WoyQwIXxU1OnplWAIqFYkx6lcw7iYBHOhbg1MkdBMwMuDB+DpLEJVSm+B4fisQhzHNrZjEk0
BkNN/vrw8fh19/Lx7bg9PO8ft3/KtMCDjKDU0eOY9TCKGc9BCto//Hjc/+flj/fN8+aPp/3m
8efu5Y/j5u8tdHD3+Ae6Cn3DVfHH159/f5ALZbE9vGyfRFbF7QvajIwLRkYu2D7vD+hltHvd
bZ52/24Qq/swpQ0OKlzANyoMD6IUY9cKdivUgtm6FDPYnCaBlk+cbFyh/X0fLHztbaAaX5e1
1A4YrjCwMsvhTefw/vN1f/awP2zHJM2af4MghuHNDZcBAzxx4TGLSKBLyhdhWiX62rEQbpGE
6SePBnRJa13tO8JIQk0zYHXc2xPm6/yiqlzqRVW5NaCQ75LCuQs71K23h7sFzFdbk3oQsazE
tz3VfHY+uTbCS/aIos1ooCltSHgl/lI8usSLP8SiEDrikKgQO+uvjqe5W9k8a1W2VYw64OCH
+Ffy/ent69Pu4c8f2/ezB7EJvmGKr3dn7dd69tIeFrkLMA5DAhYlxNDisI44ZRqj5qqtl/Hk
8vL8xnRHs5A4RseYkb29ft++vO4eNq/bx7P4RQwNzoSz/+xev5+x43H/sBOoaPO6ccYahrk7
qwQsTOAGZZNPVZndnU8/XRKbfZ5yI62nhYB/8CLtOI8n9tEEZ/+tyFVtz1rC4DBdKqPUQDhO
4R1ydMcRuB8jnAVOnaH5UDZASRlVdSNwqs7qlVN1STRXUf1aN5zoA7ADq5qRLmz9Rky0ybdL
j0gxw79TS8eWa2pjM4zz07S0Za2aE3S1cO1qN8fvvu+TM3ciEgm0K1/DpPkHsMRCysdj9217
fHUbq8PphFgPAixNTd2FgUgaCl8xo47L9Toxcpj04CBji3jirgUJd+5lBScPMGi/Of8UiYha
zqJVuL5//imbkxeodysPCwQDuegiu7plogunTB659eQpbGAZ0c+9fvPISAevga8+EYcgICaX
VLrpET+dfHKa4Qk7J4GwS3g8pVDQjB95eT45WdJThgJPiVFyMquuQqJVVFDOnUlr5vX5jdvG
qqJaFmuhEwumK9J+MyjWcPfzu+nsqo5wl4kAWKdnnNPAQ7UOsmiDlBPjZnVIOgCrDVKuZimx
ghXC0fDa+H4hO7uLocu2nhXSQvyqYH+nwUH6+5QT37YKmQzMRY0EcdSxL+Ba+ydYDKAkzheE
nup/FLsHFsCmXQwCvGcgM/HX5YYTdq9nqlDLmmUcGAt3OnqOw8uK+LqMGesIDqOujFQgJlxc
muN4nH3ZU9ETfYJ68svvwnN3BE3sLslmVZJ7oIf7Fo5CD3PlcN0GQTddMdpZzyKnZ0KeIvvn
n4ft8WjI08PSEU/PLj91Xzojvr5wT6/s3p0t8SrrlO4NHKRH9+blcf98Vrw9f90epPe6Je4P
BxRPu7CqC/eQjepgroIsEpiE4m8khrp7BSZsXAkOEQ7wS4o5ZWL0favuHKxM80II6wrRkWzK
gNUEcvtrDzQ1acFrUwktgLPz8LmKlN6F24OllnjafT1sDu9nh/3b6+6FYCSzNCDvIwGHa8S9
qKRl2zIWJIoJo4orRmwMJGrPh0blnw6zQXlake1JlBu31CFx5lSgRrFQ1eAeXCahv8+ZSPxC
T8vADtbicf38/OR4B66S6vNQ1akxn6zBkUMpIg8vlqyIT4qRVSoW2XY7LhFrcvTRJuSKEStV
AlQTEo8d+3RxQhGApGFYeSoBTBdRj+MazS1rPKVv0fY3ub65/Cf0RNYyacPpek25V9hkV5M1
OSV6e8uZl0Q0cwoP9XvQYRJn3Myn5WK7JjuxWZHQjdarITmbxeuQ9CjXP2+OaaTDbr7OfAtg
pPDaFDB+l+cxqvrF4wAm8RzHrSGrNsh6Gt4GJtn68tNNF8Z1/64Qjy5845PHIuTX6KSxRDzW
ImkoKyAg/axiT3uq+iw0d50v0Tl6rGDk01gaagq3n/7Fw2UdtodXjFGxed0eRe7C4+7by+b1
7bA9e/i+ffixe/mmBztHqxr9YaY2jH5dPEfTpLFjEh+vm5rpM0aPIoZ/RKy+s9ujqWXVcFVg
3Cve0MTKJ+A3Bq3GFKQF9kE42MzU1Zl570yMGX/VVVrYbQXpgrgIgWmp9byDaRGzuhPW2cbT
keUFFaQgiWIMbG3ZKT97EFKLsLrrZnWZWzpqnSSLCw+2iJuubVLdQkOhZmkRYS5jmM9Af70M
yzrS7xLM8h13RZsHRpxu+QDHMrdijB6u3FotlAUWdx0aN4V5tQ4TaXFUxzOLAg3pZyjOCVPh
Kkv1kQ51wIYGjrMoG/v5L6xDOOuB6TNA51cmxaAY0mBp03ZmqenE+jk+tBrHpsDAqRIHd9fk
WacRWHKEwLB65ds7kgI+GV2vKcKZHFyoZY6Bm91V7IWawrnXx2kfvIjKXB/xgLLsTzWotPE2
4WijjcyqKbrcS6bJghomswaUqpm2ofUZzyI12T/dXNYCU/TrewTbv00FZA8TkSrMQIk9JmUe
KbjHs5rWII/oJoEteooGI5hTmuAeHYRfnP6an3kcfDe/TysSEQBiQmJ0w3kNjLIqDdeWrjo/
xDMxMzyJahEXs8xKI5utDsVa9d0ehInxQ5jDYrC0mulWpUHvNtn/FK6ZS5Z1JphxXoYpHDnA
sLO6NvJqMOHeH+c2SGSzMA5ChBv5TwrRf5mxBE73uW63LnAiTwurhDxoOx6JzDMi0Wd3dWGc
7Spjjemdy1dWSgQkC0V35LvA9u/N29MrBup/3X17278dz57lk/vmsN3ABfvv9v81yVIk07wX
1qVowoOOT1q2jwHNUZcd3DWk761BpVX07qsopX3TTSLSvxlJWAZsFfpV/HWt2d8gAuRwr83q
PJMLUjtBhWv44FVsdLdq0UcdU4oIQwiqJ+jaZqyL6Fa/X7MyMH8RR3GRWWan2T0aqmjruL5F
mVCrN69SIzdklObG7zKNMDE3MF61sbphxat9uYx46e7WedygF1Q5i/RtoZcR2Z47/bKelag+
tJOBCuj1P/ouFiD0wZUxcbXVjAGB9Oi1/63s+nrbtoH4V+njBmxF0gVb95AH2aJtIbakSFaV
7EXIUiMIuqRB4wDZt9/9ISnyeFKyAkNX8kxS5PF4dzz+zusQNULdRK4dX9UxbMew2nbtxoUW
h0S0Zn0WhupTUW7qKuwctlu0ghhqVK7VcKxE0YwjbZx+TqVPP+4fj98oy9zXh8PzXRqwRUrs
BU1oZFJwMUYF6wCs9ikAmFNb0EK3Porjj0mKy64w+3P/KMCZM0kLZ+MoMDGFGwplC1I3a35d
ZpivahoRIaIY5GPWwGDYLSq06UzTwA90oDxsAf7DTM2VfYFuF2Zysr1D9v6fw6/H+wdrUjwT
6S2X/0iXhvuy7rmkDB+ld0sjAP98rTsQTa7PyEjZgmasP58JiPI+a1a6prHOF4gPUtTq9b0p
KQZm1+G1isVfcVsRc2kQNMH5p5OzzyHr13BAIvxUDMncmCyn1qBS6WpjEO2sZRzvUFLxd4Dx
SCGOu6LdZfvwMJc1NCaEN7mWg60rOs/FZnZgPUXo+rcAIhWiRvUmu8DjCEV1yDHv5okIG9Zu
9fzw98vdHQamFY/Pxx8vDzbNmdtfGTo6wAamtE5poQ+K4xU6P3k9HWc6pAMDscg0z4uDSBHC
neTeBXBFuHT4b83X4gXpos0s9Akeu9HyUV3YGBPv9TgNrlwgImsr2qDX0LJM9Ck68Se8Ho6K
LhciVH0K71qweDb5uU66p3HkiaPGBjD6dgOpjpLVXO1N2SpMibVCAxEVbttqr/aw6aovdU8V
OaiqAqH9Q2dFXD6UlUW5maT4yzSJ1CMSNvPF7DQV7L5sKnbNMxkT91dpA72m4XnHxB7f0ERz
QCUaonLUKsNltGl3tsIf7zPS15FiHOs7yPAcb6ZytoSE+CzurYEPzbIjqSpXwtXz62uHjTZF
JXjpNJIWlu1BxdqCkEynytVMjpUlcNdGQAktHDW5rTJlLk8ewRFfdkO9prDstP8vuv0sf/g2
29mMn0oPXDH5gYzdSgHNyY7gIwUtOl0KZ234yEFUYBCXsEOWNGCuTW+HuBY5hzfxKDrBaox8
G9wCzf/5aRJxPQosORftBrFJpZwj+g/V96fnXz5sv99+e3niY3Jz83gXqrIZ5hOBc7yKzNSo
GI/qzow8yJVkbnRBNkh0KHa4wffAwaHboK1W+7QyUljJIRASUh/K8k4T21GejAvX5KJXhsH9
V6FgYxI/CeZ/V6s082MPCN8euyT2Yw+WFjsbNpjUZg+2rLqh+kvQukD3yivNZqaDlnuJoRbn
GIOfqoBa9fUFdSnlmGQxkbyupGIFSsmF/StNSkbG6b8wptZBt+zuBZG+qz30P35AoCP89Px0
/4ixtvBtDy/Hw+sB/udwvP348ePP4xcQZho1RxnolJe8dYPJYy1Imjr11AZ+7uRI0e/U7c1V
eCFhN6zN3yDLR3J50vZcN7TbqseXKdOd9m30XJtLabBCbNGDY1OnndmKyS4wRQzquVsz9WtO
61foOXbD+YPNhK6bIc4cPH6tZsj/jwWP7I0EQ4DsFZiUoSsx7gp4mr3uM0fXBZ/OE7L2G2us
X2+ONx9QVb3Fi7DENMVLtXTaagkPFjPMOv0Fv78SeosTNKhIlAPpd2C4N13tH01FQmBixHHn
S7CZERon23pkcFBxNMkglnM0QTHvEEjeRNeMKMJfK9+EJHhsk5nqD59Pp6KRCaRhrDOX4aNw
l50i+pRk411aY7QhnWGGNRiIEawHvDJXr4tg7DaJDjuSg9RPo1SB8nJ5rSemo2ClkZdTz11Z
1TwBjVBfVl3Jxvp87RqMw41O45xBHopjunLoi/0GnZhSu9LILEQguswkuSXbkaIM7eFdqSBB
EDTiBqQkN0PSCIaeSU/q0rbGTY+V/OUE6CE+k4eyFNg1KOcW3WoVzhZlZSD6yJbDtUbmYBj/
ZI6DpiwaAkJgxP1H7TkzSzZkCRWvbiL/UBshl7D9jcJxk3zzBstMccvbjPJ+HvFDsOnHE/+S
H5T/YlCTQWlc2Rr9TS2rFwpJpP0ke6SHnZuU7nZFlUy7Q3th1tWkt2XDtgQDZVOl/OkqvCWT
8ooZFnCYAaPx5Aik16jO0CtRzS1hq+09P6I60e9iBcVTwTZ09erM2k5n5h6xcDDeCAOfpBgf
fWLQ4cLwNlOR6sL6cVIW9Sopc7wmy0UL4/igDds9Ao82Ra5N27zYcvszvre4LoHN5TAQdBTo
C8zm1srlZTGTZl0YJeEYJqMdh4G8CcNp4nagl2xLN5+4xOpyOG7eZ3B41zMHfNDhFLHcNUIt
tFuzIC8sor5KNSOYRpSPU+1H85raMaj6w8oO1WZZnP725xldTaIfQb/9yDCRkMaIgd9gGTkU
AhcH5YMoLACOyUMJho/mLcVYXFRJDeljr59/V/UxmkWYsNU2W7fpmWCyZnvtroq6NriGxPh4
e1lD50SYvC/8VThxUWv5Yq2pMLLH4SpfJA5VhP/Eq0Fxao98kXwIDhfDGXLkrtBoGOeNWebk
6rOeHzagUEEBfX1Hf6mNSzkqNUS6l6PAB/36vM7mbuOoDdJmZurLXaH6R6N5ogsIe6fimJ4S
C6BlNzOEruwRqLkZKjW0xVfLWx+va8dsGt7A7g/PRzTn0A+xxNRdN3eHAB8DRxfudM6DMO1J
HvMkjOKDy8wVbdhEdnAt6ZKTEPLO4sKbzqqxwncCK90pJ4I0UgToImmuFS8pLpbVl8SlCEIF
iu0mD0HBYmr8l/MmE4x4g9cFMd4IkuAFYNMR3mW21RyrTAXSN2sMB3qcn7yencCfQMzDmUcq
JUwiHXOm1I0mEF7pWRFjSOg8kQBN8NX9f55/+uuaBgIA

--3V7upXqbjpZ4EhLz--
