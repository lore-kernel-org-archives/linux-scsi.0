Return-Path: <SRS0=2Pi9=YT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA7DCA9EB9
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Oct 2019 14:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1D0621655
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Oct 2019 14:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfJZON3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Oct 2019 10:13:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:30076 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfJZON3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 26 Oct 2019 10:13:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Oct 2019 07:13:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,232,1569308400"; 
   d="scan'208";a="192822482"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 26 Oct 2019 07:13:24 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iOMom-0000hm-9Q; Sat, 26 Oct 2019 22:13:24 +0800
Date:   Sat, 26 Oct 2019 22:13:01 +0800
From:   kbuild test robot <lkp@intel.com>
To:     James Smart <jsmart2021@gmail.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH 32/32] elx: efct: Tie into kernel Kconfig and build
 process
Message-ID: <201910262236.pFVb5hph%lkp@intel.com>
References: <20191023215557.12581-33-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023215557.12581-33-jsmart2021@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[cannot apply to v5.4-rc4 next-20191025]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/James-Smart/efct-Broadcom-Emulex-FC-Target-driver/20191026-050814
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/elx/efct/efct_driver.c:49:33: sparse: sparse: symbol 'efct_libefc_templ' was not declared. Should it be static?
--
>> drivers/scsi/elx/efct/efct_scsi.c:1839:30: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] ox_id @@    got icted __be16 [usertype] ox_id @@
>> drivers/scsi/elx/efct/efct_scsi.c:1839:30: sparse:    expected restricted __be16 [usertype] ox_id
>> drivers/scsi/elx/efct/efct_scsi.c:1839:30: sparse:    got unsigned int [usertype] init_task_tag
>> drivers/scsi/elx/efct/efct_scsi.c:1840:30: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] rx_id @@    got tricted __be16 [usertype] rx_id @@
>> drivers/scsi/elx/efct/efct_scsi.c:1840:30: sparse:    expected restricted __be16 [usertype] rx_id
>> drivers/scsi/elx/efct/efct_scsi.c:1840:30: sparse:    got unsigned short [usertype] abort_rx_id
>> drivers/scsi/elx/efct/efct_scsi.c:1848:30: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] ba_high_seq_cnt @@    got tricted __be16 [usertype] ba_high_seq_cnt @@
>> drivers/scsi/elx/efct/efct_scsi.c:1848:30: sparse:    expected restricted __be16 [usertype] ba_high_seq_cnt
>> drivers/scsi/elx/efct/efct_scsi.c:1848:30: sparse:    got unsigned short [usertype]
--
>> drivers/scsi/elx/efct/efct_els.c:2263:23: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] ba_ox_id @@    got tricted __be16 [usertype] ba_ox_id @@
>> drivers/scsi/elx/efct/efct_els.c:2263:23: sparse:    expected restricted __be16 [usertype] ba_ox_id
>> drivers/scsi/elx/efct/efct_els.c:2263:23: sparse:    got unsigned short [usertype] ox_id
>> drivers/scsi/elx/efct/efct_els.c:2264:23: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] ba_rx_id @@    got tricted __be16 [usertype] ba_rx_id @@
>> drivers/scsi/elx/efct/efct_els.c:2264:23: sparse:    expected restricted __be16 [usertype] ba_rx_id
>> drivers/scsi/elx/efct/efct_els.c:2264:23: sparse:    got unsigned short [usertype] rx_id
>> drivers/scsi/elx/efct/efct_els.c:2265:30: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] ba_high_seq_cnt @@    got tricted __be16 [usertype] ba_high_seq_cnt @@
>> drivers/scsi/elx/efct/efct_els.c:2265:30: sparse:    expected restricted __be16 [usertype] ba_high_seq_cnt
>> drivers/scsi/elx/efct/efct_els.c:2265:30: sparse:    got unsigned short [usertype]
>> drivers/scsi/elx/efct/efct_els.c:1443:43: sparse: sparse: invalid assignment: |=
>> drivers/scsi/elx/efct/efct_els.c:1443:43: sparse:    left side has type restricted __be16
>> drivers/scsi/elx/efct/efct_els.c:1443:43: sparse:    right side has type restricted __be32
>> drivers/scsi/elx/efct/efct_els.c:1549:46: sparse: sparse: cast to restricted __be32
>> drivers/scsi/elx/efct/efct_els.c:1549:46: sparse: sparse: cast to restricted __be32
>> drivers/scsi/elx/efct/efct_els.c:1549:46: sparse: sparse: cast to restricted __be32
>> drivers/scsi/elx/efct/efct_els.c:1549:46: sparse: sparse: cast to restricted __be32
>> drivers/scsi/elx/efct/efct_els.c:1549:46: sparse: sparse: cast to restricted __be32
>> drivers/scsi/elx/efct/efct_els.c:1549:46: sparse: sparse: cast to restricted __be32
   drivers/scsi/elx/efct/efct_els.c:1549:42: sparse: sparse: invalid assignment: |=
>> drivers/scsi/elx/efct/efct_els.c:1549:42: sparse:    left side has type restricted __be32
>> drivers/scsi/elx/efct/efct_els.c:1549:42: sparse:    right side has type unsigned int
>> drivers/scsi/elx/efct/efct_els.c:2602:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] init_task_tag @@    got restrunsigned int [usertype] init_task_tag @@
>> drivers/scsi/elx/efct/efct_els.c:2602:27: sparse:    expected unsigned int [usertype] init_task_tag
>> drivers/scsi/elx/efct/efct_els.c:2602:27: sparse:    got restricted __be16 [usertype] ox_id
>> drivers/scsi/elx/efct/efct_els.c:2609:38: sparse: sparse: cast from restricted __be16
>> drivers/scsi/elx/efct/efct_els.c:2609:38: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected unsigned short [usertype] val @@    got resunsigned short [usertype] val @@
>> drivers/scsi/elx/efct/efct_els.c:2609:38: sparse:    expected unsigned short [usertype] val
   drivers/scsi/elx/efct/efct_els.c:2609:38: sparse:    got restricted __be16 [usertype] ox_id
>> drivers/scsi/elx/efct/efct_els.c:2609:38: sparse: sparse: cast from restricted __be16
>> drivers/scsi/elx/efct/efct_els.c:2609:38: sparse: sparse: cast from restricted __be16
>> drivers/scsi/elx/efct/efct_els.c:2609:36: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] ox_id @@    got resunsigned short [usertype] ox_id @@
>> drivers/scsi/elx/efct/efct_els.c:2609:36: sparse:    expected unsigned short [usertype] ox_id
>> drivers/scsi/elx/efct/efct_els.c:2609:36: sparse:    got restricted __be16 [usertype]
--
>> drivers/scsi/elx/efct/efct_hw.c:4748:59: sparse: sparse: incorrect type in argument 3 (different base types) @@    expected unsigned int [usertype] *data @@    got ed int [usertype] *data @@
>> drivers/scsi/elx/efct/efct_hw.c:4748:59: sparse:    expected unsigned int [usertype] *data
>> drivers/scsi/elx/efct/efct_hw.c:4748:59: sparse:    got restricted __le32 *
>> drivers/scsi/elx/efct/efct_hw.c:921:36: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] rq_id @@    got e] rq_id @@
>> drivers/scsi/elx/efct/efct_hw.c:921:36: sparse:    expected restricted __le16 [usertype] rq_id
>> drivers/scsi/elx/efct/efct_hw.c:921:36: sparse:    got int
>> drivers/scsi/elx/efct/efct_hw.c:937:49: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/elx/efct/efct_hw.c:943:57: sparse: sparse: restricted __le16 degrades to integer
>> drivers/scsi/elx/efct/efct_hw.c:953:60: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] rq_id @@    got icted __le16 [usertype] rq_id @@
   drivers/scsi/elx/efct/efct_hw.c:953:60: sparse:    expected restricted __le16 [usertype] rq_id
>> drivers/scsi/elx/efct/efct_hw.c:953:60: sparse:    got unsigned int [usertype] base_mrq_id
>> drivers/scsi/elx/efct/efct_hw.c:956:60: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] rq_id @@    got tricted __le16 [usertype] rq_id @@
   drivers/scsi/elx/efct/efct_hw.c:956:60: sparse:    expected restricted __le16 [usertype] rq_id
>> drivers/scsi/elx/efct/efct_hw.c:956:60: sparse:    got unsigned short [usertype] id
   drivers/scsi/elx/efct/efct_hw.c:733:41: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] rq_id @@    got e] rq_id @@
   drivers/scsi/elx/efct/efct_hw.c:733:41: sparse:    expected restricted __le16 [usertype] rq_id
   drivers/scsi/elx/efct/efct_hw.c:733:41: sparse:    got int
   drivers/scsi/elx/efct/efct_hw.c:766:57: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] rq_id @@    got tricted __le16 [usertype] rq_id @@
   drivers/scsi/elx/efct/efct_hw.c:766:57: sparse:    expected restricted __le16 [usertype] rq_id
   drivers/scsi/elx/efct/efct_hw.c:766:57: sparse:    got unsigned short [usertype] id
>> drivers/scsi/elx/efct/efct_hw.c:2496:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] sge_flags @@    got restrunsigned int [usertype] sge_flags @@
>> drivers/scsi/elx/efct/efct_hw.c:2496:27: sparse:    expected unsigned int [usertype] sge_flags
>> drivers/scsi/elx/efct/efct_hw.c:2496:27: sparse:    got restricted __le32 [usertype] dw2_flags
>> drivers/scsi/elx/efct/efct_hw.c:2532:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [assigned] [usertype] sge_flags @@    got ed int [assigned] [usertype] sge_flags @@
>> drivers/scsi/elx/efct/efct_hw.c:2532:27: sparse:    expected unsigned int [assigned] [usertype] sge_flags
   drivers/scsi/elx/efct/efct_hw.c:2532:27: sparse:    got restricted __le32 [usertype] dw2_flags
   drivers/scsi/elx/efct/efct_hw.c:2544:19: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [assigned] [usertype] sge_flags @@    got ed int [assigned] [usertype] sge_flags @@
   drivers/scsi/elx/efct/efct_hw.c:2544:19: sparse:    expected unsigned int [assigned] [usertype] sge_flags
   drivers/scsi/elx/efct/efct_hw.c:2544:19: sparse:    got restricted __le32 [usertype] dw2_flags
   drivers/scsi/elx/efct/efct_hw.c:2676:19: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] sge_flags @@    got restrunsigned int [usertype] sge_flags @@
   drivers/scsi/elx/efct/efct_hw.c:2676:19: sparse:    expected unsigned int [usertype] sge_flags
   drivers/scsi/elx/efct/efct_hw.c:2676:19: sparse:    got restricted __le32 [usertype] dw2_flags
   drivers/scsi/elx/efct/efct_hw.c:2680:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [assigned] [usertype] sge_flags @@    got ed int [assigned] [usertype] sge_flags @@
   drivers/scsi/elx/efct/efct_hw.c:2680:27: sparse:    expected unsigned int [assigned] [usertype] sge_flags
   drivers/scsi/elx/efct/efct_hw.c:2680:27: sparse:    got restricted __le32 [usertype] dw2_flags
   drivers/scsi/elx/efct/efct_hw.c:2778:19: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] sge_flags @@    got restrunsigned int [usertype] sge_flags @@
   drivers/scsi/elx/efct/efct_hw.c:2778:19: sparse:    expected unsigned int [usertype] sge_flags
   drivers/scsi/elx/efct/efct_hw.c:2778:19: sparse:    got restricted __le32 [usertype] dw2_flags
   drivers/scsi/elx/efct/efct_hw.c:2797:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [assigned] [usertype] sge_flags @@    got ed int [assigned] [usertype] sge_flags @@
   drivers/scsi/elx/efct/efct_hw.c:2797:27: sparse:    expected unsigned int [assigned] [usertype] sge_flags
   drivers/scsi/elx/efct/efct_hw.c:2797:27: sparse:    got restricted __le32 [usertype] dw2_flags
   drivers/scsi/elx/efct/efct_hw.c:2854:19: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] sge_flags @@    got restrunsigned int [usertype] sge_flags @@
   drivers/scsi/elx/efct/efct_hw.c:2854:19: sparse:    expected unsigned int [usertype] sge_flags
   drivers/scsi/elx/efct/efct_hw.c:2854:19: sparse:    got restricted __le32 [usertype] dw2_flags
   drivers/scsi/elx/efct/efct_hw.c:2875:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [assigned] [usertype] sge_flags @@    got ed int [assigned] [usertype] sge_flags @@
   drivers/scsi/elx/efct/efct_hw.c:2875:27: sparse:    expected unsigned int [assigned] [usertype] sge_flags
   drivers/scsi/elx/efct/efct_hw.c:2875:27: sparse:    got restricted __le32 [usertype] dw2_flags
>> drivers/scsi/elx/efct/efct_hw.c:4213:20: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] sge0_flags @@    got restrunsigned int [usertype] sge0_flags @@
>> drivers/scsi/elx/efct/efct_hw.c:4213:20: sparse:    expected unsigned int [usertype] sge0_flags
   drivers/scsi/elx/efct/efct_hw.c:4213:20: sparse:    got restricted __le32 [usertype] dw2_flags
>> drivers/scsi/elx/efct/efct_hw.c:4214:20: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] sge1_flags @@    got restrunsigned int [usertype] sge1_flags @@
>> drivers/scsi/elx/efct/efct_hw.c:4214:20: sparse:    expected unsigned int [usertype] sge1_flags
   drivers/scsi/elx/efct/efct_hw.c:4214:20: sparse:    got restricted __le32 [usertype] dw2_flags
>> drivers/scsi/elx/efct/efct_hw.c:4338:29: sparse: sparse: cast from restricted __be16
   drivers/scsi/elx/efct/efct_hw.c:4339:29: sparse: sparse: cast from restricted __be16
--
>> drivers/scsi/elx/efct/efct_unsol.c:910:28: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [assigned] [usertype] ba_low_seq_cnt @@    got e16 [assigned] [usertype] ba_low_seq_cnt @@
>> drivers/scsi/elx/efct/efct_unsol.c:910:28: sparse:    expected restricted __be16 [assigned] [usertype] ba_low_seq_cnt
>> drivers/scsi/elx/efct/efct_unsol.c:910:28: sparse:    got unsigned short [usertype]
>> drivers/scsi/elx/efct/efct_unsol.c:911:29: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [assigned] [usertype] ba_high_seq_cnt @@    got e16 [assigned] [usertype] ba_high_seq_cnt @@
>> drivers/scsi/elx/efct/efct_unsol.c:911:29: sparse:    expected restricted __be16 [assigned] [usertype] ba_high_seq_cnt
   drivers/scsi/elx/efct/efct_unsol.c:911:29: sparse:    got unsigned short [usertype]
--
>> drivers/scsi/elx/libefc_sli/sli4.c:152:31: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] dw3_version @@    got restrunsigned int [usertype] dw3_version @@
>> drivers/scsi/elx/libefc_sli/sli4.c:152:31: sparse:    expected unsigned int [usertype] dw3_version
>> drivers/scsi/elx/libefc_sli/sli4.c:152:31: sparse:    got restricted __le32 [usertype]
>> drivers/scsi/elx/libefc_sli/sli4.c:153:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned long [assigned] [usertype] cmd_size @@    got d long [assigned] [usertype] cmd_size @@
>> drivers/scsi/elx/libefc_sli/sli4.c:153:18: sparse:    expected unsigned long [assigned] [usertype] cmd_size
   drivers/scsi/elx/libefc_sli/sli4.c:153:18: sparse:    got restricted __le32 [usertype]
>> drivers/scsi/elx/libefc_sli/sli4.c:155:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] request_length @@    got unsignerestricted __le32 [usertype] request_length @@
>> drivers/scsi/elx/libefc_sli/sli4.c:155:34: sparse:    expected restricted __le32 [usertype] request_length
>> drivers/scsi/elx/libefc_sli/sli4.c:155:34: sparse:    got unsigned long [assigned] [usertype] cmd_size
   drivers/scsi/elx/libefc_sli/sli4.c:275:37: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] dw3_version @@    got restrunsigned int [usertype] dw3_version @@
   drivers/scsi/elx/libefc_sli/sli4.c:275:37: sparse:    expected unsigned int [usertype] dw3_version
   drivers/scsi/elx/libefc_sli/sli4.c:275:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/elx/libefc_sli/sli4.c:416:37: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] dw3_version @@    got restrunsigned int [usertype] dw3_version @@
   drivers/scsi/elx/libefc_sli/sli4.c:416:37: sparse:    expected unsigned int [usertype] dw3_version
   drivers/scsi/elx/libefc_sli/sli4.c:416:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/elx/libefc_sli/sli4.c:550:29: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] dw3_version @@    got restrunsigned int [usertype] dw3_version @@
   drivers/scsi/elx/libefc_sli/sli4.c:550:29: sparse:    expected unsigned int [usertype] dw3_version
   drivers/scsi/elx/libefc_sli/sli4.c:550:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/elx/libefc_sli/sli4.c:748:29: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] dw3_version @@    got restrunsigned int [usertype] dw3_version @@
   drivers/scsi/elx/libefc_sli/sli4.c:748:29: sparse:    expected unsigned int [usertype] dw3_version
   drivers/scsi/elx/libefc_sli/sli4.c:748:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/elx/libefc_sli/sli4.c:846:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] dw3_version @@    got restrunsigned int [usertype] dw3_version @@
   drivers/scsi/elx/libefc_sli/sli4.c:846:32: sparse:    expected unsigned int [usertype] dw3_version
   drivers/scsi/elx/libefc_sli/sli4.c:846:32: sparse:    got restricted __le32 [usertype]
>> drivers/scsi/elx/libefc_sli/sli4.c:1078:33: sparse: sparse: Using plain integer as NULL pointer
   drivers/scsi/elx/libefc_sli/sli4.c:1526:33: sparse: sparse: Using plain integer as NULL pointer
>> drivers/scsi/elx/libefc_sli/sli4.h:3029:17: sparse: sparse: invalid assignment: &=
>> drivers/scsi/elx/libefc_sli/sli4.h:3029:17: sparse:    left side has type unsigned int
>> drivers/scsi/elx/libefc_sli/sli4.h:3029:17: sparse:    right side has type restricted __le32
   drivers/scsi/elx/libefc_sli/sli4.h:3030:17: sparse: sparse: invalid assignment: |=
   drivers/scsi/elx/libefc_sli/sli4.h:3030:17: sparse:    left side has type unsigned int
>> drivers/scsi/elx/libefc_sli/sli4.h:3030:17: sparse:    right side has type restricted __le16
>> drivers/scsi/elx/libefc_sli/sli4.c:2486:47: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/elx/libefc_sli/sli4.c:2487:48: sparse: sparse: restricted __le32 degrades to integer
>> drivers/scsi/elx/libefc_sli/sli4.c:2486:38: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] payload_offset_length @@    got  [usertype] payload_offset_length @@
>> drivers/scsi/elx/libefc_sli/sli4.c:2486:38: sparse:    expected restricted __le16 [usertype] payload_offset_length
>> drivers/scsi/elx/libefc_sli/sli4.c:2486:38: sparse:    got unsigned int
>> drivers/scsi/elx/libefc_sli/sli4.c:2589:41: sparse: sparse: cast from restricted __le32
>> drivers/scsi/elx/libefc_sli/sli4.c:2591:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] sge_flags @@    got restrunsigned int [usertype] sge_flags @@
>> drivers/scsi/elx/libefc_sli/sli4.c:2591:27: sparse:    expected unsigned int [usertype] sge_flags
>> drivers/scsi/elx/libefc_sli/sli4.c:2591:27: sparse:    got restricted __le32 [usertype] dw2_flags
>> drivers/scsi/elx/libefc_sli/sli4.c:2594:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] dw2_flags @@    got unsignrestricted __le32 [usertype] dw2_flags @@
>> drivers/scsi/elx/libefc_sli/sli4.c:2594:34: sparse:    expected restricted __le32 [usertype] dw2_flags
>> drivers/scsi/elx/libefc_sli/sli4.c:2594:34: sparse:    got unsigned int [assigned] [usertype] sge_flags
   drivers/scsi/elx/libefc_sli/sli4.c:2597:47: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/elx/libefc_sli/sli4.c:2598:48: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/elx/libefc_sli/sli4.c:2597:38: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] payload_offset_length @@    got  [usertype] payload_offset_length @@
   drivers/scsi/elx/libefc_sli/sli4.c:2597:38: sparse:    expected restricted __le16 [usertype] payload_offset_length
   drivers/scsi/elx/libefc_sli/sli4.c:2597:38: sparse:    got unsigned int
   drivers/scsi/elx/libefc_sli/sli4.c:2719:41: sparse: sparse: cast from restricted __le32
   drivers/scsi/elx/libefc_sli/sli4.c:2720:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] sge_flags @@    got restrunsigned int [usertype] sge_flags @@
   drivers/scsi/elx/libefc_sli/sli4.c:2720:27: sparse:    expected unsigned int [usertype] sge_flags
   drivers/scsi/elx/libefc_sli/sli4.c:2720:27: sparse:    got restricted __le32 [usertype] dw2_flags
   drivers/scsi/elx/libefc_sli/sli4.c:2723:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] dw2_flags @@    got unsignrestricted __le32 [usertype] dw2_flags @@
   drivers/scsi/elx/libefc_sli/sli4.c:2723:34: sparse:    expected restricted __le32 [usertype] dw2_flags
   drivers/scsi/elx/libefc_sli/sli4.c:2723:34: sparse:    got unsigned int [assigned] [usertype] sge_flags
   drivers/scsi/elx/libefc_sli/sli4.c:2726:48: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/elx/libefc_sli/sli4.c:2727:48: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/elx/libefc_sli/sli4.c:2726:39: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] payload_offset_length @@    got  [usertype] payload_offset_length @@
   drivers/scsi/elx/libefc_sli/sli4.c:2726:39: sparse:    expected restricted __le16 [usertype] payload_offset_length
   drivers/scsi/elx/libefc_sli/sli4.c:2726:39: sparse:    got unsigned int
>> drivers/scsi/elx/libefc_sli/sli4.c:2930:35: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
>> drivers/scsi/elx/libefc_sli/sli4.c:2930:35: sparse:    expected unsigned int
   drivers/scsi/elx/libefc_sli/sli4.c:2930:35: sparse:    got restricted __le32 [usertype]
   drivers/scsi/elx/libefc_sli/sli4.c:3083:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/scsi/elx/libefc_sli/sli4.c:3083:34: sparse:    expected unsigned int
   drivers/scsi/elx/libefc_sli/sli4.c:3083:34: sparse:    got restricted __le32 [usertype]
   drivers/scsi/elx/libefc_sli/sli4.c:3159:47: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/elx/libefc_sli/sli4.c:3245:35: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
   drivers/scsi/elx/libefc_sli/sli4.c:3245:35: sparse:    expected unsigned int
   drivers/scsi/elx/libefc_sli/sli4.c:3245:35: sparse:    got restricted __le32 [usertype]
>> drivers/scsi/elx/libefc_sli/sli4.c:3423:19: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] cq_id @@    got e] cq_id @@
>> drivers/scsi/elx/libefc_sli/sli4.c:3423:19: sparse:    expected restricted __le16 [usertype] cq_id
>> drivers/scsi/elx/libefc_sli/sli4.c:3423:19: sparse:    got int
>> drivers/scsi/elx/libefc_sli/sli4.c:3471:37: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:3472:36: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:3482:22: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:3483:22: sparse: sparse: cast from restricted __le16
>> drivers/scsi/elx/libefc_sli/sli4.c:3577:42: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] els_response_payload_length @@    got icted __le32 [usertype] els_response_payload_length @@
>> drivers/scsi/elx/libefc_sli/sli4.c:3577:42: sparse:    expected restricted __le32 [usertype] els_response_payload_length
>> drivers/scsi/elx/libefc_sli/sli4.c:3577:42: sparse:    got unsigned int [usertype] rsp_len
>> drivers/scsi/elx/libefc_sli/sli4.c:3681:38: sparse: sparse: invalid assignment: |=
>> drivers/scsi/elx/libefc_sli/sli4.c:3681:38: sparse:    left side has type restricted __le32
>> drivers/scsi/elx/libefc_sli/sli4.c:3681:38: sparse:    right side has type unsigned int
   drivers/scsi/elx/libefc_sli/sli4.c:3718:46: sparse: sparse: invalid assignment: |=
   drivers/scsi/elx/libefc_sli/sli4.c:3718:46: sparse:    left side has type restricted __le32
   drivers/scsi/elx/libefc_sli/sli4.c:3718:46: sparse:    right side has type unsigned int
   drivers/scsi/elx/libefc_sli/sli4.c:3754:25: sparse: sparse: invalid assignment: |=
>> drivers/scsi/elx/libefc_sli/sli4.c:3754:25: sparse:    left side has type restricted __le16
>> drivers/scsi/elx/libefc_sli/sli4.c:3754:25: sparse:    right side has type int
   drivers/scsi/elx/libefc_sli/sli4.c:3755:25: sparse: sparse: invalid assignment: |=
   drivers/scsi/elx/libefc_sli/sli4.c:3755:25: sparse:    left side has type restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:3755:25: sparse:    right side has type int
>> drivers/scsi/elx/libefc_sli/sli4.c:4001:23: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
>> drivers/scsi/elx/libefc_sli/sli4.c:4001:23: sparse:    expected unsigned short [usertype]
>> drivers/scsi/elx/libefc_sli/sli4.c:4001:23: sparse:    got restricted __le16 [usertype] rq_id
>> drivers/scsi/elx/libefc_sli/sli4.c:4863:50: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] available_length_dword @@    got restricted __le32 [usertype] available_length_dword @@
>> drivers/scsi/elx/libefc_sli/sli4.c:4863:50: sparse:    expected restricted __le32 [usertype] available_length_dword
>> drivers/scsi/elx/libefc_sli/sli4.c:4863:50: sparse:    got restricted __le16 [usertype]
   drivers/scsi/elx/libefc_sli/sli4.c:4993:43: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:4996:43: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:4999:43: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:5002:43: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:5056:47: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:5059:47: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:5062:47: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:5065:47: sparse: sparse: cast from restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:5176:30: sparse: sparse: invalid assignment: |=
   drivers/scsi/elx/libefc_sli/sli4.c:5176:30: sparse:    left side has type restricted __le16
   drivers/scsi/elx/libefc_sli/sli4.c:5176:30: sparse:    right side has type int
   drivers/scsi/elx/libefc_sli/sli4.c:5663:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] dw3_version @@    got restrunsigned int [usertype] dw3_version @@
   drivers/scsi/elx/libefc_sli/sli4.c:5663:33: sparse:    expected unsigned int [usertype] dw3_version
   drivers/scsi/elx/libefc_sli/sli4.c:5663:33: sparse:    got restricted __le32 [usertype]
>> drivers/scsi/elx/libefc_sli/sli4.c:7366:53: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] page1_low @@    got icted __le32 [usertype] page1_low @@
>> drivers/scsi/elx/libefc_sli/sli4.c:7366:53: sparse:    expected restricted __le32 [usertype] page1_low
>> drivers/scsi/elx/libefc_sli/sli4.c:7366:53: sparse:    got unsigned int [usertype]
>> drivers/scsi/elx/libefc_sli/sli4.c:7368:54: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] page1_high @@    got icted __le32 [usertype] page1_high @@
>> drivers/scsi/elx/libefc_sli/sli4.c:7368:54: sparse:    expected restricted __le32 [usertype] page1_high
   drivers/scsi/elx/libefc_sli/sli4.c:7368:54: sparse:    got unsigned int [usertype]
>> drivers/scsi/elx/libefc_sli/sli4.c:7404:22: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] payload_size @@    got restrunsigned int [usertype] payload_size @@
>> drivers/scsi/elx/libefc_sli/sli4.c:7404:22: sparse:    expected unsigned int [usertype] payload_size
   drivers/scsi/elx/libefc_sli/sli4.c:7404:22: sparse:    got restricted __le32 [usertype]

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
