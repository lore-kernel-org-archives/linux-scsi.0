Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BECAC35E15
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 21:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 389DE2176D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 21:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgBYVKW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 16:10:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:45477 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgBYVKW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Feb 2020 16:10:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 13:10:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,485,1574150400"; 
   d="scan'208";a="226481249"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 25 Feb 2020 13:10:20 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1j6hT9-0004Ka-E4; Wed, 26 Feb 2020 05:10:19 +0800
Date:   Wed, 26 Feb 2020 05:09:49 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Joe Carnuccio <joe.carnuccio@cavium.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [scsi:misc 53/68] drivers/scsi/qla2xxx/qla_tmpl.c:873:32: sparse:
 sparse: incorrect type in assignment (different base types)
Message-ID: <202002260548.sgLT96UJ%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   162e250031cc6caca35738813720e4ed83f1b1bb
commit: a31056ddc6651b457d72d8d71d32143764df86d2 [53/68] scsi: qla2xxx: Use endian macros to assign static fields in fwdump header
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-173-ge0787745-dirty
        git checkout a31056ddc6651b457d72d8d71d32143764df86d2
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/qla2xxx/qla_tmpl.c:873:32: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/scsi/qla2xxx/qla_tmpl.c:873:32: sparse:    expected unsigned int [usertype] capture_timestamp
>> drivers/scsi/qla2xxx/qla_tmpl.c:873:32: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_tmpl.c:885:29: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/scsi/qla2xxx/qla_tmpl.c:885:29: sparse:    expected unsigned int
   drivers/scsi/qla2xxx/qla_tmpl.c:885:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_tmpl.c:887:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_tmpl.c:887:29: sparse:    expected unsigned int
   drivers/scsi/qla2xxx/qla_tmpl.c:887:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_tmpl.c:888:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_tmpl.c:888:29: sparse:    expected unsigned int
   drivers/scsi/qla2xxx/qla_tmpl.c:888:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_tmpl.c:898:34: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_tmpl.c:898:34: sparse:    expected unsigned int
   drivers/scsi/qla2xxx/qla_tmpl.c:898:34: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_tmpl.c:900:34: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_tmpl.c:900:34: sparse:    expected unsigned int
   drivers/scsi/qla2xxx/qla_tmpl.c:900:34: sparse:    got restricted __le32 [usertype]

vim +873 drivers/scsi/qla2xxx/qla_tmpl.c

   869	
   870	static void
   871	qla27xx_time_stamp(struct qla27xx_fwdt_template *tmp)
   872	{
 > 873		tmp->capture_timestamp = cpu_to_le32(jiffies);
   874	}
   875	
   876	static void
   877	qla27xx_driver_info(struct qla27xx_fwdt_template *tmp)
   878	{
   879		uint8_t v[] = { 0, 0, 0, 0, 0, 0 };
   880	
   881		WARN_ON_ONCE(sscanf(qla2x00_version_str,
   882				    "%hhu.%hhu.%hhu.%hhu.%hhu.%hhu",
   883				    v+0, v+1, v+2, v+3, v+4, v+5) != 6);
   884	
 > 885		tmp->driver_info[0] = cpu_to_le32(
   886			v[3] << 24 | v[2] << 16 | v[1] << 8 | v[0]);
   887		tmp->driver_info[1] = cpu_to_le32(v[5] << 8 | v[4]);
   888		tmp->driver_info[2] = __constant_cpu_to_le32(0x12345678);
   889	}
   890	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
