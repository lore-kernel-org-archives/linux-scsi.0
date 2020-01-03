Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA753C2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 20:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73644222C4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 20:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgACUTK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 15:19:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:7400 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgACUTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Jan 2020 15:19:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 12:19:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,391,1571727600"; 
   d="scan'208";a="369691980"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 12:19:06 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1inTPV-000Dza-Qr; Sat, 04 Jan 2020 04:19:05 +0800
Date:   Sat, 4 Jan 2020 04:18:53 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [scsi:misc 58/85] drivers/scsi/qla2xxx/qla_target.c:5326:35: sparse:
 sparse: cast from restricted __be16
Message-ID: <202001040422.6EbHYDMc%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
head:   c53cf10ef6d9faeee9baa1fab824139c6f10a134
commit: a9c4ae108610716140bdec56ae0bebbe1c5cbe49 [58/85] scsi: qla2xxx: Use get_unaligned_*() instead of open-coding these functions
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        git checkout a9c4ae108610716140bdec56ae0bebbe1c5cbe49
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/qla2xxx/qla_target.c:1843:15: sparse:    expected unsigned int [usertype] f_ctl
   drivers/scsi/qla2xxx/qla_target.c:1843:15: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:1916:23: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:1916:23: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:1916:23: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:1935:31: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:1935:31: sparse:    expected restricted __le16 [usertype] ox_id
   drivers/scsi/qla2xxx/qla_target.c:1935:31: sparse:    got unsigned short [usertype] ox_id
   drivers/scsi/qla2xxx/qla_target.c:2229:23: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2229:23: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:2229:23: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2238:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2238:37: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:2238:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2240:38: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2240:38: sparse:    expected unsigned short [usertype] response_len
   drivers/scsi/qla2xxx/qla_target.c:2240:38: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2286:23: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2286:23: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:2286:23: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2295:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2295:37: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:2295:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2297:38: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2297:38: sparse:    expected unsigned short [usertype] response_len
   drivers/scsi/qla2xxx/qla_target.c:2297:38: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2298:34: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2298:34: sparse:    expected unsigned int [usertype] residual
   drivers/scsi/qla2xxx/qla_target.c:2298:34: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2301:45: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_target.c:2301:45: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_target.c:2301:45: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:2587:27: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2587:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_target.c:2587:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2588:22: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2588:22: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:2588:22: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2595:40: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2595:40: sparse:    expected unsigned int [usertype] relative_offset
   drivers/scsi/qla2xxx/qla_target.c:2595:40: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2650:42: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2650:42: sparse:    expected unsigned int [usertype] transfer_length
   drivers/scsi/qla2xxx/qla_target.c:2650:42: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2657:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2657:35: sparse:    expected unsigned short [usertype] dseg_count
   drivers/scsi/qla2xxx/qla_target.c:2657:35: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2819:34: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2819:34: sparse:    expected unsigned int [usertype] residual
   drivers/scsi/qla2xxx/qla_target.c:2819:34: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2820:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2820:37: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:2820:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2841:45: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_target.c:2841:45: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_target.c:2841:45: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:2843:46: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2843:46: sparse:    expected unsigned short [usertype] sense_length
   drivers/scsi/qla2xxx/qla_target.c:2843:46: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2846:69: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2846:69: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2846:69: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3100:27: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:3100:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_target.c:3100:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3282:60: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:3282:60: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:3282:60: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3284:57: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:3284:57: sparse:    expected unsigned int [usertype] residual
   drivers/scsi/qla2xxx/qla_target.c:3284:57: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3100:27: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:3100:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_target.c:3100:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3576:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:3578:25: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_target.c:3582:29: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_target.c:3582:29: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_target.c:3582:29: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:3653:25: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:3653:25: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:3653:25: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3846:21: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_target.c:4508:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:4529:19: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:4702:19: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:4797:26: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:4880:19: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:4920:26: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5056:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5151:18: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5157:34: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5172:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5192:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5237:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5238:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5239:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5314:25: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:5314:25: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:5314:25: sparse:    got restricted __le16 [usertype]
>> drivers/scsi/qla2xxx/qla_target.c:5326:35: sparse: sparse: cast from restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:5326:35: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_target.c:5326:35: sparse:    expected unsigned short [usertype] val
   drivers/scsi/qla2xxx/qla_target.c:5326:35: sparse:    got restricted __be16 [usertype] ox_id
>> drivers/scsi/qla2xxx/qla_target.c:5326:35: sparse: sparse: cast from restricted __be16
>> drivers/scsi/qla2xxx/qla_target.c:5326:35: sparse: sparse: cast from restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:5326:33: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:5326:33: sparse:    expected restricted __le16 [usertype] ox_id
   drivers/scsi/qla2xxx/qla_target.c:5326:33: sparse:    got int
   drivers/scsi/qla2xxx/qla_target.c:5327:39: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:5327:39: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:5327:39: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:5731:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5947:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5947:46: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5948:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5948:46: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5965:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5965:46: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5966:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5966:46: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5973:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5973:46: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5974:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5974:46: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5976:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:6000:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:6000:46: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:6001:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:6001:46: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:6003:30: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:6783:29: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:6832:48: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/scsi/qla2xxx/qla_target.c:6832:48: sparse:    expected unsigned short [usertype] msix_atio
   drivers/scsi/qla2xxx/qla_target.c:6832:48: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:6873:44: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/scsi/qla2xxx/qla_target.c:6873:44: sparse:    expected unsigned short [usertype] exchange_count
   drivers/scsi/qla2xxx/qla_target.c:6873:44: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:6875:44: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:6875:44: sparse:    expected unsigned short [usertype] exchange_count
   drivers/scsi/qla2xxx/qla_target.c:6875:44: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:6878:40: sparse: sparse: invalid assignment: |=
>> drivers/scsi/qla2xxx/qla_target.c:6878:40: sparse:    left side has type unsigned int
>> drivers/scsi/qla2xxx/qla_target.c:6878:40: sparse:    right side has type restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:6882:48: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_target.c:6882:48: sparse:    left side has type unsigned int
   drivers/scsi/qla2xxx/qla_target.c:6882:48: sparse:    right side has type restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:6885:40: sparse: sparse: invalid assignment: &=
   drivers/scsi/qla2xxx/qla_target.c:6885:40: sparse:    left side has type unsigned int
   drivers/scsi/qla2xxx/qla_target.c:6885:40: sparse:    right side has type restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:6887:40: sparse: sparse: invalid assignment: &=
   drivers/scsi/qla2xxx/qla_target.c:6887:40: sparse:    left side has type unsigned int
   drivers/scsi/qla2xxx/qla_target.c:6887:40: sparse:    right side has type restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:6890:48: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_target.c:6890:48: sparse:    left side has type unsigned int
   drivers/scsi/qla2xxx/qla_target.c:6890:48: sparse:    right side has type restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:6893:48: sparse: sparse: invalid assignment: &=
   drivers/scsi/qla2xxx/qla_target.c:6893:48: sparse:    left side has type unsigned int
   drivers/scsi/qla2xxx/qla_target.c:6893:48: sparse:    right side has type restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:6896:28: sparse: sparse: too many warnings

vim +5326 drivers/scsi/qla2xxx/qla_target.c

2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5137  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5138  /*
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5139   * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5140   */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5141  static void qlt_handle_imm_notify(struct scsi_qla_host *vha,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5142  	struct imm_ntfy_from_isp *iocb)
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5143  {
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5144  	struct qla_hw_data *ha = vha->hw;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5145  	uint32_t add_flags = 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5146  	int send_notify_ack = 1;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5147  	uint16_t status;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5148  
57bf595a6f2437 Bart Van Assche    2019-08-08  5149  	lockdep_assert_held(&ha->hardware_lock);
57bf595a6f2437 Bart Van Assche    2019-08-08  5150  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5151  	status = le16_to_cpu(iocb->u.isp2x.status);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5152  	switch (status) {
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5153  	case IMM_NTFY_LIP_RESET:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5154  	{
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5155  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf032,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5156  		    "qla_target(%d): LIP reset (loop %#x), subcode %x\n",
2d70c103fd2a06 Nicholas Bellinger 2012-05-15 @5157  		    vha->vp_idx, le16_to_cpu(iocb->u.isp24.nport_handle),
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5158  		    iocb->u.isp24.status_subcode);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5159  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5160  		if (qlt_reset(vha, iocb, QLA_TGT_ABORT_ALL) == 0)
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5161  			send_notify_ack = 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5162  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5163  	}
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5164  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5165  	case IMM_NTFY_LIP_LINK_REINIT:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5166  	{
0e8cd71ceca4c1 Saurav Kashyap     2014-01-14  5167  		struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
bd432bb53cffea Bart Van Assche    2019-04-11  5168  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5169  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf033,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5170  		    "qla_target(%d): LINK REINIT (loop %#x, "
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5171  		    "subcode %x)\n", vha->vp_idx,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5172  		    le16_to_cpu(iocb->u.isp24.nport_handle),
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5173  		    iocb->u.isp24.status_subcode);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5174  		if (tgt->link_reinit_iocb_pending) {
82de802ad46e23 Quinn Tran         2017-06-13  5175  			qlt_send_notify_ack(ha->base_qpair,
82de802ad46e23 Quinn Tran         2017-06-13  5176  			    &tgt->link_reinit_iocb, 0, 0, 0, 0, 0, 0);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5177  		}
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5178  		memcpy(&tgt->link_reinit_iocb, iocb, sizeof(*iocb));
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5179  		tgt->link_reinit_iocb_pending = 1;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5180  		/*
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5181  		 * QLogic requires to wait after LINK REINIT for possible
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5182  		 * PDISC or ADISC ELS commands
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5183  		 */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5184  		send_notify_ack = 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5185  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5186  	}
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5187  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5188  	case IMM_NTFY_PORT_LOGOUT:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5189  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf034,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5190  		    "qla_target(%d): Port logout (loop "
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5191  		    "%#x, subcode %x)\n", vha->vp_idx,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5192  		    le16_to_cpu(iocb->u.isp24.nport_handle),
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5193  		    iocb->u.isp24.status_subcode);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5194  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5195  		if (qlt_reset(vha, iocb, QLA_TGT_NEXUS_LOSS_SESS) == 0)
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5196  			send_notify_ack = 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5197  		/* The sessions will be cleared in the callback, if needed */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5198  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5199  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5200  	case IMM_NTFY_GLBL_TPRLO:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5201  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf035,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5202  		    "qla_target(%d): Global TPRLO (%x)\n", vha->vp_idx, status);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5203  		if (qlt_reset(vha, iocb, QLA_TGT_NEXUS_LOSS) == 0)
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5204  			send_notify_ack = 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5205  		/* The sessions will be cleared in the callback, if needed */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5206  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5207  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5208  	case IMM_NTFY_PORT_CONFIG:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5209  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf036,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5210  		    "qla_target(%d): Port config changed (%x)\n", vha->vp_idx,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5211  		    status);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5212  		if (qlt_reset(vha, iocb, QLA_TGT_ABORT_ALL) == 0)
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5213  			send_notify_ack = 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5214  		/* The sessions will be cleared in the callback, if needed */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5215  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5216  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5217  	case IMM_NTFY_GLBL_LOGO:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5218  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06a,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5219  		    "qla_target(%d): Link failure detected\n",
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5220  		    vha->vp_idx);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5221  		/* I_T nexus loss */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5222  		if (qlt_reset(vha, iocb, QLA_TGT_NEXUS_LOSS) == 0)
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5223  			send_notify_ack = 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5224  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5225  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5226  	case IMM_NTFY_IOCB_OVERFLOW:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5227  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06b,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5228  		    "qla_target(%d): Cannot provide requested "
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5229  		    "capability (IOCB overflowed the immediate notify "
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5230  		    "resource count)\n", vha->vp_idx);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5231  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5232  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5233  	case IMM_NTFY_ABORT_TASK:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5234  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf037,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5235  		    "qla_target(%d): Abort Task (S %08x I %#x -> "
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5236  		    "L %#x)\n", vha->vp_idx,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5237  		    le16_to_cpu(iocb->u.isp2x.seq_id),
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5238  		    GET_TARGET_ID(ha, (struct atio_from_isp *)iocb),
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5239  		    le16_to_cpu(iocb->u.isp2x.lun));
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5240  		if (qlt_abort_task(vha, iocb) == 0)
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5241  			send_notify_ack = 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5242  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5243  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5244  	case IMM_NTFY_RESOURCE:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5245  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06c,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5246  		    "qla_target(%d): Out of resources, host %ld\n",
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5247  		    vha->vp_idx, vha->host_no);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5248  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5249  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5250  	case IMM_NTFY_MSG_RX:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5251  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf038,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5252  		    "qla_target(%d): Immediate notify task %x\n",
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5253  		    vha->vp_idx, iocb->u.isp2x.task_flags);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5254  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5255  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5256  	case IMM_NTFY_ELS:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5257  		if (qlt_24xx_handle_els(vha, iocb) == 0)
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5258  			send_notify_ack = 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5259  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5260  	default:
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5261  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06d,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5262  		    "qla_target(%d): Received unknown immediate "
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5263  		    "notify status %x\n", vha->vp_idx, status);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5264  		break;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5265  	}
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5266  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5267  	if (send_notify_ack)
82de802ad46e23 Quinn Tran         2017-06-13  5268  		qlt_send_notify_ack(ha->base_qpair, iocb, add_flags, 0, 0, 0,
82de802ad46e23 Quinn Tran         2017-06-13  5269  		    0, 0);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5270  }
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5271  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5272  /*
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5273   * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5274   * This function sends busy to ISP 2xxx or 24xx.
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5275   */
82de802ad46e23 Quinn Tran         2017-06-13  5276  static int __qlt_send_busy(struct qla_qpair *qpair,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5277  	struct atio_from_isp *atio, uint16_t status)
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5278  {
82de802ad46e23 Quinn Tran         2017-06-13  5279  	struct scsi_qla_host *vha = qpair->vha;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5280  	struct ctio7_to_24xx *ctio24;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5281  	struct qla_hw_data *ha = vha->hw;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5282  	request_t *pkt;
5d964837c6a743 Quinn Tran         2017-01-19  5283  	struct fc_port *sess = NULL;
7560151b6b3c1f Quinn Tran         2015-12-17  5284  	unsigned long flags;
f7e761f56c7119 Quinn Tran         2017-06-02  5285  	u16 temp;
8ea4faf829eb2e Quinn Tran         2018-05-01  5286  	port_id_t id;
8ea4faf829eb2e Quinn Tran         2018-05-01  5287  
df95f39ae76474 Bart Van Assche    2019-08-08  5288  	id = be_to_port_id(atio->u.isp24.fcp_hdr.s_id);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5289  
7560151b6b3c1f Quinn Tran         2015-12-17  5290  	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
8ea4faf829eb2e Quinn Tran         2018-05-01  5291  	sess = qla2x00_find_fcport_by_nportid(vha, &id, 1);
7560151b6b3c1f Quinn Tran         2015-12-17  5292  	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5293  	if (!sess) {
82de802ad46e23 Quinn Tran         2017-06-13  5294  		qlt_send_term_exchange(qpair, NULL, atio, 1, 0);
33e7997755936b Quinn Tran         2014-09-25  5295  		return 0;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5296  	}
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5297  	/* Sending marker isn't necessary, since we called from ISR */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5298  
82de802ad46e23 Quinn Tran         2017-06-13  5299  	pkt = (request_t *)__qla2x00_alloc_iocbs(qpair, NULL);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5300  	if (!pkt) {
667024a3654918 Arun Easi          2014-09-25  5301  		ql_dbg(ql_dbg_io, vha, 0x3063,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5302  		    "qla_target(%d): %s failed: unable to allocate "
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5303  		    "request packet", vha->vp_idx, __func__);
33e7997755936b Quinn Tran         2014-09-25  5304  		return -ENOMEM;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5305  	}
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5306  
60a9eadb19f33a Quinn Tran         2017-06-13  5307  	qpair->tgt_counters.num_q_full_sent++;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5308  	pkt->entry_count = 1;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5309  	pkt->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5310  
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5311  	ctio24 = (struct ctio7_to_24xx *)pkt;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5312  	ctio24->entry_type = CTIO_TYPE7;
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5313  	ctio24->nport_handle = sess->loop_id;
ad950360eebb5f Bart Van Assche    2015-07-09  5314  	ctio24->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5315  	ctio24->vp_index = vha->vp_idx;
df95f39ae76474 Bart Van Assche    2019-08-08  5316  	ctio24->initiator_id = be_id_to_le(atio->u.isp24.fcp_hdr.s_id);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5317  	ctio24->exchange_addr = atio->u.isp24.exchange_addr;
f7e761f56c7119 Quinn Tran         2017-06-02  5318  	temp = (atio->u.isp24.attr << 9) |
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5319  		CTIO7_FLAGS_STATUS_MODE_1 | CTIO7_FLAGS_SEND_STATUS |
f7e761f56c7119 Quinn Tran         2017-06-02  5320  		CTIO7_FLAGS_DONT_RET_CTIO;
f7e761f56c7119 Quinn Tran         2017-06-02  5321  	ctio24->u.status1.flags = cpu_to_le16(temp);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5322  	/*
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5323  	 * CTIO from fw w/o se_cmd doesn't provide enough info to retry it,
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5324  	 * if the explicit conformation is used.
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5325  	 */
2d70c103fd2a06 Nicholas Bellinger 2012-05-15 @5326  	ctio24->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
2d70c103fd2a06 Nicholas Bellinger 2012-05-15  5327  	ctio24->u.status1.scsi_status = cpu_to_le16(status);
e25f76549bd779 Quinn Tran         2018-05-01  5328  
e25f76549bd779 Quinn Tran         2018-05-01  5329  	ctio24->u.status1.residual = get_datalen_for_atio(atio);
e25f76549bd779 Quinn Tran         2018-05-01  5330  
e25f76549bd779 Quinn Tran         2018-05-01  5331  	if (ctio24->u.status1.residual != 0)
e25f76549bd779 Quinn Tran         2018-05-01  5332  		ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
e25f76549bd779 Quinn Tran         2018-05-01  5333  
63163e06012787 Himanshu Madhani   2014-09-25  5334  	/* Memory Barrier */
63163e06012787 Himanshu Madhani   2014-09-25  5335  	wmb();
8abfa9e2268337 Quinn Tran         2017-06-13  5336  	if (qpair->reqq_start_iocbs)
8abfa9e2268337 Quinn Tran         2017-06-13  5337  		qpair->reqq_start_iocbs(qpair);
8abfa9e2268337 Quinn Tran         2017-06-13  5338  	else
82de802ad46e23 Quinn Tran         2017-06-13  5339  		qla2x00_start_iocbs(vha, qpair->req);
33e7997755936b Quinn Tran         2014-09-25  5340  	return 0;
33e7997755936b Quinn Tran         2014-09-25  5341  }
33e7997755936b Quinn Tran         2014-09-25  5342  

:::::: The code at line 5326 was first introduced by commit
:::::: 2d70c103fd2a066f904712b14239a5ce141f8236 [SCSI] qla2xxx: Add LLD target-mode infrastructure for >= 24xx series

:::::: TO: Nicholas Bellinger <nab@linux-iscsi.org>
:::::: CC: James Bottomley <JBottomley@Parallels.com>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
