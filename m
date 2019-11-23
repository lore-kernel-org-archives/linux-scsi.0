Return-Path: <SRS0=GkA7=ZP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE57AC432C0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Nov 2019 04:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75BA02071C
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Nov 2019 04:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfKWE6o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 23:58:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:28928 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbfKWE6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 23:58:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 20:58:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,232,1571727600"; 
   d="scan'208";a="238856291"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 22 Nov 2019 20:58:40 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iYNVI-000HuN-GR; Sat, 23 Nov 2019 12:58:40 +0800
Date:   Sat, 23 Nov 2019 12:58:29 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux@yadro.com,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2 12/15] scsi: qla2xxx: Use explicit LOGO in target mode
Message-ID: <201911231243.Odck2GJ5%lkp@intel.com>
References: <20191120222723.27779-13-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120222723.27779-13-r.bolshakov@yadro.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Roman,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on next-20191122]
[cannot apply to v5.4-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Roman-Bolshakov/scsi-qla2xxx-Bug-fixes/20191122-011503
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-36-g9305d48-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/scsi/qla2xxx/qla_iocb.c:2374:29: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2389:9: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] extended @@    got resunsigned short [usertype] extended @@
   drivers/scsi/qla2xxx/qla_iocb.c:2389:9: sparse:    expected unsigned short [usertype] extended
   drivers/scsi/qla2xxx/qla_iocb.c:2389:9: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2390:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb0 @@    got resunsigned short [usertype] mb0 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2390:18: sparse:    expected unsigned short [usertype] mb0
   drivers/scsi/qla2xxx/qla_iocb.c:2390:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2394:26: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb1 @@    got resunsigned short [usertype] mb1 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2394:26: sparse:    expected unsigned short [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:2394:26: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2395:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb10 @@    got resunsigned short [usertype] mb10 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2395:27: sparse:    expected unsigned short [usertype] mb10
   drivers/scsi/qla2xxx/qla_iocb.c:2395:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2397:26: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb1 @@    got resunsigned short [usertype] mb1 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2397:26: sparse:    expected unsigned short [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:2397:26: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2399:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb2 @@    got resunsigned short [usertype] mb2 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2399:18: sparse:    expected unsigned short [usertype] mb2
   drivers/scsi/qla2xxx/qla_iocb.c:2399:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2400:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb3 @@    got resunsigned short [usertype] mb3 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2400:18: sparse:    expected unsigned short [usertype] mb3
   drivers/scsi/qla2xxx/qla_iocb.c:2400:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2402:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb9 @@    got resunsigned short [usertype] mb9 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2402:18: sparse:    expected unsigned short [usertype] mb9
   drivers/scsi/qla2xxx/qla_iocb.c:2402:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2420:30: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] control_flags @@    got resunsigned short [usertype] control_flags @@
   drivers/scsi/qla2xxx/qla_iocb.c:2420:30: sparse:    expected unsigned short [usertype] control_flags
   drivers/scsi/qla2xxx/qla_iocb.c:2420:30: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2421:29: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] nport_handle @@    got resunsigned short [usertype] nport_handle @@
   drivers/scsi/qla2xxx/qla_iocb.c:2421:29: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:2421:29: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2434:9: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] extended @@    got resunsigned short [usertype] extended @@
   drivers/scsi/qla2xxx/qla_iocb.c:2434:9: sparse:    expected unsigned short [usertype] extended
   drivers/scsi/qla2xxx/qla_iocb.c:2434:9: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2435:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb0 @@    got resunsigned short [usertype] mb0 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2435:18: sparse:    expected unsigned short [usertype] mb0
   drivers/scsi/qla2xxx/qla_iocb.c:2435:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2436:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb1 @@    got short [usertype] mb1 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2436:18: sparse:    expected unsigned short [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:2436:18: sparse:    got restricted __le16
   drivers/scsi/qla2xxx/qla_iocb.c:2439:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb2 @@    got resunsigned short [usertype] mb2 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2439:18: sparse:    expected unsigned short [usertype] mb2
   drivers/scsi/qla2xxx/qla_iocb.c:2439:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2440:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb3 @@    got resunsigned short [usertype] mb3 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2440:18: sparse:    expected unsigned short [usertype] mb3
   drivers/scsi/qla2xxx/qla_iocb.c:2440:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2442:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb9 @@    got resunsigned short [usertype] mb9 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2442:18: sparse:    expected unsigned short [usertype] mb9
   drivers/scsi/qla2xxx/qla_iocb.c:2442:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2450:30: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] control_flags @@    got resunsigned short [usertype] control_flags @@
   drivers/scsi/qla2xxx/qla_iocb.c:2450:30: sparse:    expected unsigned short [usertype] control_flags
   drivers/scsi/qla2xxx/qla_iocb.c:2450:30: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2451:29: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] nport_handle @@    got resunsigned short [usertype] nport_handle @@
   drivers/scsi/qla2xxx/qla_iocb.c:2451:29: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:2451:29: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2461:9: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] extended @@    got resunsigned short [usertype] extended @@
   drivers/scsi/qla2xxx/qla_iocb.c:2461:9: sparse:    expected unsigned short [usertype] extended
   drivers/scsi/qla2xxx/qla_iocb.c:2461:9: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2462:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb0 @@    got resunsigned short [usertype] mb0 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2462:18: sparse:    expected unsigned short [usertype] mb0
   drivers/scsi/qla2xxx/qla_iocb.c:2462:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2464:26: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb1 @@    got resunsigned short [usertype] mb1 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2464:26: sparse:    expected unsigned short [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:2464:26: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2465:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb10 @@    got resunsigned short [usertype] mb10 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2465:27: sparse:    expected unsigned short [usertype] mb10
   drivers/scsi/qla2xxx/qla_iocb.c:2465:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2467:26: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb1 @@    got resunsigned short [usertype] mb1 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2467:26: sparse:    expected unsigned short [usertype] mb1
   drivers/scsi/qla2xxx/qla_iocb.c:2467:26: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2469:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb2 @@    got resunsigned short [usertype] mb2 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2469:18: sparse:    expected unsigned short [usertype] mb2
   drivers/scsi/qla2xxx/qla_iocb.c:2469:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2470:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb3 @@    got resunsigned short [usertype] mb3 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2470:18: sparse:    expected unsigned short [usertype] mb3
   drivers/scsi/qla2xxx/qla_iocb.c:2470:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2471:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb6 @@    got resunsigned short [usertype] mb6 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2471:18: sparse:    expected unsigned short [usertype] mb6
   drivers/scsi/qla2xxx/qla_iocb.c:2471:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2472:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb7 @@    got resunsigned short [usertype] mb7 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2472:18: sparse:    expected unsigned short [usertype] mb7
   drivers/scsi/qla2xxx/qla_iocb.c:2472:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2473:18: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] mb9 @@    got resunsigned short [usertype] mb9 @@
   drivers/scsi/qla2xxx/qla_iocb.c:2473:18: sparse:    expected unsigned short [usertype] mb9
   drivers/scsi/qla2xxx/qla_iocb.c:2473:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2493:27: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] nport_handle @@    got resunsigned short [usertype] nport_handle @@
   drivers/scsi/qla2xxx/qla_iocb.c:2493:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:2493:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2494:22: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] timeout @@    got resunsigned short [usertype] timeout @@
   drivers/scsi/qla2xxx/qla_iocb.c:2494:22: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_iocb.c:2494:22: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2495:28: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [usertype] control_flags @@    got restrunsigned int [usertype] control_flags @@
   drivers/scsi/qla2xxx/qla_iocb.c:2495:28: sparse:    expected unsigned int [usertype] control_flags
   drivers/scsi/qla2xxx/qla_iocb.c:2495:28: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2657:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] nport_handle @@    got resunsigned short [usertype] nport_handle @@
   drivers/scsi/qla2xxx/qla_iocb.c:2657:32: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:2657:32: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2987:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] nport_handle @@    got resunsigned short [usertype] nport_handle @@
   drivers/scsi/qla2xxx/qla_iocb.c:2987:32: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:2987:32: sparse:    got restricted __le16 [usertype]
>> drivers/scsi/qla2xxx/qla_iocb.c:2988:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] tx_dsd_count @@    got resunsigned short [usertype] tx_dsd_count @@
>> drivers/scsi/qla2xxx/qla_iocb.c:2988:32: sparse:    expected unsigned short [usertype] tx_dsd_count
   drivers/scsi/qla2xxx/qla_iocb.c:2988:32: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2991:32: sparse: sparse: too many warnings

vim +2988 drivers/scsi/qla2xxx/qla_iocb.c

edd05de1975927 Duane Grigsby       2017-10-13  2975  
9a069e196767d7 Giridhar Malavali   2010-01-12  2976  static void
9a069e196767d7 Giridhar Malavali   2010-01-12  2977  qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
9a069e196767d7 Giridhar Malavali   2010-01-12  2978  {
75cc8cfc6e13d4 Johannes Thumshirn  2016-11-17  2979  	struct bsg_job *bsg_job = sp->u.bsg_job;
01e0e15c8b3b32 Johannes Thumshirn  2016-11-17  2980  	struct fc_bsg_request *bsg_request = bsg_job->request;
9a069e196767d7 Giridhar Malavali   2010-01-12  2981  
9a069e196767d7 Giridhar Malavali   2010-01-12  2982          els_iocb->entry_type = ELS_IOCB_TYPE;
9a069e196767d7 Giridhar Malavali   2010-01-12  2983          els_iocb->entry_count = 1;
9a069e196767d7 Giridhar Malavali   2010-01-12  2984          els_iocb->sys_define = 0;
9a069e196767d7 Giridhar Malavali   2010-01-12  2985          els_iocb->entry_status = 0;
9a069e196767d7 Giridhar Malavali   2010-01-12  2986          els_iocb->handle = sp->handle;
9a069e196767d7 Giridhar Malavali   2010-01-12  2987          els_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
ad950360eebb5f Bart Van Assche     2015-07-09 @2988  	els_iocb->tx_dsd_count = cpu_to_le16(bsg_job->request_payload.sg_cnt);
25ff6af10562cf Joe Carnuccio       2017-01-19  2989  	els_iocb->vp_index = sp->vha->vp_idx;
9a069e196767d7 Giridhar Malavali   2010-01-12  2990          els_iocb->sof_type = EST_SOFI3;
ad950360eebb5f Bart Van Assche     2015-07-09  2991  	els_iocb->rx_dsd_count = cpu_to_le16(bsg_job->reply_payload.sg_cnt);
9a069e196767d7 Giridhar Malavali   2010-01-12  2992  
4916392b56921b Madhuranath Iyengar 2010-05-04  2993  	els_iocb->opcode =
9ba56b95a58890 Giridhar Malavali   2012-02-09  2994  	    sp->type == SRB_ELS_CMD_RPT ?
01e0e15c8b3b32 Johannes Thumshirn  2016-11-17  2995  	    bsg_request->rqst_data.r_els.els_code :
01e0e15c8b3b32 Johannes Thumshirn  2016-11-17  2996  	    bsg_request->rqst_data.h_els.command_code;
9a069e196767d7 Giridhar Malavali   2010-01-12  2997          els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
9a069e196767d7 Giridhar Malavali   2010-01-12  2998          els_iocb->port_id[1] = sp->fcport->d_id.b.area;
9a069e196767d7 Giridhar Malavali   2010-01-12  2999          els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
9a069e196767d7 Giridhar Malavali   2010-01-12  3000          els_iocb->control_flags = 0;
9a069e196767d7 Giridhar Malavali   2010-01-12  3001          els_iocb->rx_byte_count =
9a069e196767d7 Giridhar Malavali   2010-01-12  3002              cpu_to_le32(bsg_job->reply_payload.payload_len);
9a069e196767d7 Giridhar Malavali   2010-01-12  3003          els_iocb->tx_byte_count =
9a069e196767d7 Giridhar Malavali   2010-01-12  3004              cpu_to_le32(bsg_job->request_payload.payload_len);
9a069e196767d7 Giridhar Malavali   2010-01-12  3005  
d4556a4932a546 Bart Van Assche     2019-04-17  3006  	put_unaligned_le64(sg_dma_address(bsg_job->request_payload.sg_list),
d4556a4932a546 Bart Van Assche     2019-04-17  3007  			   &els_iocb->tx_address);
9a069e196767d7 Giridhar Malavali   2010-01-12  3008          els_iocb->tx_len = cpu_to_le32(sg_dma_len
9a069e196767d7 Giridhar Malavali   2010-01-12  3009              (bsg_job->request_payload.sg_list));
9a069e196767d7 Giridhar Malavali   2010-01-12  3010  
d4556a4932a546 Bart Van Assche     2019-04-17  3011  	put_unaligned_le64(sg_dma_address(bsg_job->reply_payload.sg_list),
d4556a4932a546 Bart Van Assche     2019-04-17  3012  			   &els_iocb->rx_address);
9a069e196767d7 Giridhar Malavali   2010-01-12  3013          els_iocb->rx_len = cpu_to_le32(sg_dma_len
9a069e196767d7 Giridhar Malavali   2010-01-12  3014              (bsg_job->reply_payload.sg_list));
fabbb8df8eba6f Joe Carnuccio       2013-08-27  3015  
25ff6af10562cf Joe Carnuccio       2017-01-19  3016  	sp->vha->qla_stats.control_requests++;
9a069e196767d7 Giridhar Malavali   2010-01-12  3017  }
9a069e196767d7 Giridhar Malavali   2010-01-12  3018  

:::::: The code at line 2988 was first introduced by commit
:::::: ad950360eebb5f5f7610b13cfd08c0185ca3f146 qla2xxx: Remove __constant_ prefix

:::::: TO: Bart Van Assche <bart.vanassche@sandisk.com>
:::::: CC: James Bottomley <JBottomley@Odin.com>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
