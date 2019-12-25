Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0019C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 13:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 443FE2075B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 13:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLYNaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 08:30:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:39851 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbfLYNaV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Dec 2019 08:30:21 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Dec 2019 05:30:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,355,1571727600"; 
   d="scan'208";a="223418130"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 25 Dec 2019 05:30:12 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ik6js-000Ef4-0S; Wed, 25 Dec 2019 21:30:12 +0800
Date:   Wed, 25 Dec 2019 21:29:17 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     kbuild-all@lists.01.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] qla2xxx: Fix the code that reads from mailbox registers
Message-ID: <201912252157.xVgr2QmT%lkp@intel.com>
References: <20191220183357.16655-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220183357.16655-1-bvanassche@acm.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

I love your patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on mkp-scsi/for-next v5.5-rc3 next-20191220]
[cannot apply to target/for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Bart-Van-Assche/qla2xxx-Fix-the-code-that-reads-from-mailbox-registers/20191224-021100
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-129-g341daf20-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    got unsigned int [noderef] <asn:2> *
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    got unsigned int [noderef] <asn:2> *
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    got unsigned int [noderef] <asn:2> *
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    got unsigned int [noderef] <asn:2> *
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    got unsigned int [noderef] <asn:2> *
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1205:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1886:23: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_os.c:1886:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_os.c:1886:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1887:22: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_os.c:1887:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1887:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1901:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1901:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1901:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1902:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1902:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1902:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1914:24: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_os.c:1914:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1914:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1915:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1915:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1915:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1929:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1929:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1929:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:1930:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:1930:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:1930:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:4474:45: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_os.c:4474:45: sparse:    expected unsigned short [usertype] exchange_count
   drivers/scsi/qla2xxx/qla_os.c:4474:45: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_os.c:4485:45: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_os.c:4485:45: sparse:    expected unsigned short [usertype] exchange_count
   drivers/scsi/qla2xxx/qla_os.c:4485:45: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_os.c:4585:45: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_os.c:4585:45: sparse:    expected unsigned short [usertype] exchange_count
   drivers/scsi/qla2xxx/qla_os.c:4585:45: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_os.c:5137:41: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_os.c:5141:37: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_os.c:6986:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:6986:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:6986:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:6990:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:6990:38: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:6990:38: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_os.c:6994:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_os.c:6994:38: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_os.c:6994:38: sparse:    got unsigned int [noderef] <asn:2> *
>> drivers/scsi/qla2xxx/qla_inline.h:308:26: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_inline.h:308:26: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_inline.h:308:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_in
   arch/x86/include/asm/bitops.h:77:37: sparse: sparse: cast truncates bits from constant value (ffffff7f becomes 7f)
--
>> drivers/scsi/qla2xxx/qla_init.c:3599:31: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_init.c:3599:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_init.c:3599:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:3600:30: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_init.c:3600:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:3600:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:3694:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:3694:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:3694:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:3697:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:3697:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:3697:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:3698:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:3698:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:3698:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:5052:45: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_init.c:5052:45: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_init.c:5052:45: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_init.c:5133:35: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_init.c:130:32: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_init.c:130:32: sparse:    expected restricted __le16 [usertype] comp_status
   drivers/scsi/qla2xxx/qla_init.c:130:32: sparse:    got int
   drivers/scsi/qla2xxx/qla_init.c:980:39: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_init.c:982:47: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_init.c:984:28: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_init.c:984:28: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_init.c:984:28: sparse:    got restricted __le16
   drivers/scsi/qla2xxx/qla_init.c:1100:12: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_init.c:1100:12: sparse:    expected unsigned short [usertype] *mb
   drivers/scsi/qla2xxx/qla_init.c:1100:12: sparse:    got restricted __le16 *
   drivers/scsi/qla2xxx/qla_init.c:1147:19: sparse: sparse: incorrect type in initializer (different base types)
   drivers/scsi/qla2xxx/qla_init.c:1147:19: sparse:    expected unsigned short [usertype] *mb
   drivers/scsi/qla2xxx/qla_init.c:1147:19: sparse:    got restricted __le16 *
   drivers/scsi/qla2xxx/qla_init.c:1321:12: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_init.c:1321:12: sparse:    expected unsigned short [usertype] *mb
   drivers/scsi/qla2xxx/qla_init.c:1321:12: sparse:    got restricted __le16 *
   drivers/scsi/qla2xxx/qla_init.c:1762:32: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_init.c:1762:32: sparse:    expected restricted __le16 [usertype] comp_status
   drivers/scsi/qla2xxx/qla_init.c:1762:32: sparse:    got int
   drivers/scsi/qla2xxx/qla_init.c:2197:34: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2197:34: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2197:34: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2329:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2329:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2329:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2371:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2371:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2371:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2373:43: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2373:43: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2373:43: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2380:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2380:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2380:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2381:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2381:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2381:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2384:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2384:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2384:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2390:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2390:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2390:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2391:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2391:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2391:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2394:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2394:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2394:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2396:43: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2396:43: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2396:43: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2411:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2411:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2411:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2455:38: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_init.c:2455:38: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_init.c:2455:38: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2559:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2559:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2559:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2562:51: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2562:51: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2562:51: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2568:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2568:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2568:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2573:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2573:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2573:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2574:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2574:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2574:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2577:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2577:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2577:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2578:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2578:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2578:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2582:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2582:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2582:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2583:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2583:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2583:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2587:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2587:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2587:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2588:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2588:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2588:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2592:25: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2592:25: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2592:25: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2593:25: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2593:25: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2593:25: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2595:25: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2595:25: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2595:25: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2599:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2599:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2599:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2606:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2606:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2606:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2607:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2607:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2607:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2610:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2610:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2610:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2611:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2611:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2611:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2614:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2614:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2614:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2615:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2615:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2615:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2618:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2618:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2618:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2619:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2619:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2619:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2622:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2622:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2622:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2633:43: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2633:43: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2633:43: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2642:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2642:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2642:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2644:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2644:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2644:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2647:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2647:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2647:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2648:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2648:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2648:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2652:29: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2652:29: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2652:29: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2666:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2666:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2666:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2667:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2667:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2667:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2832:24: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_init.c:2832:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2832:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2833:50: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2833:50: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2833:50: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2842:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2842:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2842:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2843:43: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2843:43: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2843:43: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2859:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2859:31: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2859:31: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2712:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2712:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2712:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2714:36: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2714:36: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2714:36: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2720:29: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2720:29: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2720:29: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2725:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2725:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2725:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2726:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2726:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2726:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2727:28: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2727:28: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2727:28: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2729:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2729:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2729:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2736:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2736:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2736:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2737:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2737:40: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2737:40: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2751:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2751:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2751:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2752:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2752:26: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2752:26: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2755:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2755:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2755:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2758:36: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2758:36: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2758:36: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2764:29: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2764:29: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2764:29: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2769:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2769:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2769:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2770:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2770:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2770:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2789:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2789:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2789:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2790:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2790:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2790:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2792:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2792:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2792:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2793:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2793:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2793:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2795:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2795:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2795:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2796:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2796:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2796:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2798:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2798:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2798:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2799:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2799:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2799:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2812:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2812:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2812:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2813:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2813:27: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2813:27: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2961:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2961:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2961:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2968:43: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2968:43: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2968:43: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_init.c:2971:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_init.c:2971:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_init.c:2971:37: sparse:    got unsigned short [noderef] <asn:2> *
--
   drivers/scsi/qla2xxx/qla_mbx.c:120:21: sparse: sparse: restricted pci_channel_state_t degrades to integer
   drivers/scsi/qla2xxx/qla_mbx.c:120:37: sparse: sparse: restricted pci_channel_state_t degrades to integer
   drivers/scsi/qla2xxx/qla_mbx.c:212:22: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/scsi/qla2xxx/qla_mbx.c:212:22: sparse:    expected restricted __le16 [noderef] [usertype] <asn:2> *optr
>> drivers/scsi/qla2xxx/qla_mbx.c:212:22: sparse:    got unsigned short [noderef] [usertype] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:214:22: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:214:22: sparse:    expected restricted __le16 [noderef] [usertype] <asn:2> *optr
   drivers/scsi/qla2xxx/qla_mbx.c:214:22: sparse:    got unsigned short [noderef] [usertype] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:216:22: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:216:22: sparse:    expected restricted __le16 [noderef] [usertype] <asn:2> *optr
   drivers/scsi/qla2xxx/qla_mbx.c:216:22: sparse:    got unsigned short [noderef] [usertype] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:226:30: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:226:30: sparse:    expected restricted __le16 [noderef] [usertype] <asn:2> *optr
   drivers/scsi/qla2xxx/qla_mbx.c:226:30: sparse:    got unsigned short [noderef] [usertype] <asn:2> *
>> drivers/scsi/qla2xxx/qla_mbx.c:257:40: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_mbx.c:257:40: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mbx.c:257:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:259:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:259:40: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:259:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:261:39: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_mbx.c:261:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mbx.c:261:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:304:43: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_mbx.c:304:43: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:304:43: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:315:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:315:40: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:315:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:317:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:317:40: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:317:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:319:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:319:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:319:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:417:46: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_mbx.c:417:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:417:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:418:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:418:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:418:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:419:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:419:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:419:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:420:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:420:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:420:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:421:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:421:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:421:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:422:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:422:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:422:47: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:423:53: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:423:53: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:423:53: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:424:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:424:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:424:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:433:33: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:433:33: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:433:33: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:434:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:434:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:434:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:577:43: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:577:43: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:577:43: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:578:43: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:578:43: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:578:43: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:579:43: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:579:43: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:579:43: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:583:42: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:583:42: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:583:42: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:584:42: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:584:42: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:584:42: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:585:42: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:585:42: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:585:42: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:2388:26: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:2388:26: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_mbx.c:2388:26: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:2389:27: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:2389:27: sparse:    expected unsigned short [usertype] control_flags
   drivers/scsi/qla2xxx/qla_mbx.c:2389:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:2391:35: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_mbx.c:2391:35: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:2391:35: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:2393:35: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_mbx.c:2393:35: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:2393:35: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:2408:39: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_mbx.c:2409:26: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:2410:26: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:2414:41: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:2446:26: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:2462:43: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_mbx.c:2658:26: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:2658:26: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_mbx.c:2658:26: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:2659:27: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:2659:27: sparse:    expected unsigned short [usertype] control_flags
   drivers/scsi/qla2xxx/qla_mbx.c:2659:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:2676:39: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_mbx.c:2679:41: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:2680:21: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:2681:21: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:3075:18: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:3075:18: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:3075:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:3076:19: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:3076:19: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:3076:19: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:3149:27: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:3149:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_mbx.c:3149:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:3156:25: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:3156:25: sparse:    expected unsigned short [usertype] req_que_no
   drivers/scsi/qla2xxx/qla_mbx.c:3156:25: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:3167:41: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_mbx.c:3170:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:3228:33: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:3228:33: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_mbx.c:3228:33: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:3229:28: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:3229:28: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_mbx.c:3229:28: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:3230:34: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:3230:34: sparse:    expected unsigned int [usertype] control_flags
   drivers/scsi/qla2xxx/qla_mbx.c:3230:34: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:3251:40: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_mbx.c:3254:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:3256:20: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:3258:21: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:3262:29: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:4117:42: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_mbx.c:4120:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:4272:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:4272:35: sparse:    expected unsigned short [usertype] options
   drivers/scsi/qla2xxx/qla_mbx.c:4272:35: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:4291:29: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:4293:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:4310:29: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:4315:29: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:4390:34: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:4390:34: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mbx.c:4390:34: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_in
   drivers/scsi/qla2xxx/qla_mbx.c:4392:42: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:4392:42: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mbx.c:4392:42: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_out
   drivers/scsi/qla2xxx/qla_mbx.c:4461:34: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:4461:34: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mbx.c:4461:34: sparse:    got unsigned int [noderef] [usertype] <asn:2> *rsp_q_out
   drivers/scsi/qla2xxx/qla_mbx.c:4463:42: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:4463:42: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mbx.c:4463:42: sparse:    got unsigned int [noderef] [usertype] <asn:2> *rsp_q_in
   drivers/scsi/qla2xxx/qla_mbx.c:4706:28: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:4706:28: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:4706:28: sparse:    got restricted __le16
   drivers/scsi/qla2xxx/qla_mbx.c:4824:31: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_mbx.c:5278:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5278:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5278:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:5279:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5279:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5279:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:5280:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5280:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5280:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:5281:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5281:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5281:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:5282:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5282:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5282:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:5284:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5284:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5284:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:5289:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5289:38: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5289:38: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:5297:52: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5297:52: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5297:52: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:5298:48: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5298:48: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5298:48: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:5300:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:5300:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mbx.c:5300:47: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mbx.c:6329:18: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:6329:18: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:6329:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:6334:18: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:6334:18: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:6334:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:6335:19: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:6335:19: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:6335:19: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:6446:18: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:6446:18: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:6446:18: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:6472:20: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:6472:20: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:6472:20: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:6473:20: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:6473:20: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:6473:20: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_mbx.c:6498:20: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_mbx.c:6498:20: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_mbx.c:6498:20: sparse:    got restricted __le16 [usertype]
--
   drivers/scsi/qla2xxx/qla_iocb.c:208:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:208:37: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:208:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:213:32: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_iocb.c:213:32: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_iocb.c:213:32: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_iocb.c:264:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:264:37: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:264:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:269:32: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_iocb.c:269:32: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_iocb.c:269:32: sparse:    right side has type restricted __le16
>> drivers/scsi/qla2xxx/qla_iocb.c:379:43: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_iocb.c:379:43: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_iocb.c:379:43: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:402:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:402:29: sparse:    expected unsigned short [usertype] dseg_count
   drivers/scsi/qla2xxx/qla_iocb.c:402:29: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:405:9: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:405:9: sparse:    expected unsigned short [usertype] extended
   drivers/scsi/qla2xxx/qla_iocb.c:405:9: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:406:22: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:406:22: sparse:    expected unsigned short [usertype] lun
   drivers/scsi/qla2xxx/qla_iocb.c:406:22: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:407:32: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:407:32: sparse:    expected unsigned short [usertype] control_flags
   drivers/scsi/qla2xxx/qla_iocb.c:407:32: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:411:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:411:29: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:411:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:431:22: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_iocb.c:431:22: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:431:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:432:29: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:432:29: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:432:29: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:475:42: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_iocb.c:475:42: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_iocb.c:475:42: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_in
   drivers/scsi/qla2xxx/qla_iocb.c:477:42: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:477:42: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:477:42: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_in
   drivers/scsi/qla2xxx/qla_iocb.c:478:49: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_iocb.c:478:49: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_iocb.c:478:49: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:480:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:480:40: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:480:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:481:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:481:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:481:47: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:484:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:484:40: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:484:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:485:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:485:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:485:47: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:487:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:487:38: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:487:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:489:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:489:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:489:45: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_iocb.c:529:45: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:529:45: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:529:45: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:535:25: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:535:25: sparse:    expected unsigned short [usertype] extended
   drivers/scsi/qla2xxx/qla_iocb.c:535:25: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:536:34: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:536:34: sparse:    expected unsigned short [usertype] lun
   drivers/scsi/qla2xxx/qla_iocb.c:536:34: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1640:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1640:45: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_iocb.c:1640:45: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_out
   drivers/scsi/qla2xxx/qla_iocb.c:1664:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1664:29: sparse:    expected unsigned short [usertype] dseg_count
   drivers/scsi/qla2xxx/qla_iocb.c:1664:29: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1667:31: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1667:31: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:1667:31: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1682:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1682:29: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:1682:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:715:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:715:37: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:715:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:723:42: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:723:42: sparse:    expected unsigned short [usertype] task_mgmt_flags
   drivers/scsi/qla2xxx/qla_iocb.c:723:42: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:727:42: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:727:42: sparse:    expected unsigned short [usertype] task_mgmt_flags
   drivers/scsi/qla2xxx/qla_iocb.c:727:42: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1701:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1701:26: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:1701:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_in
   drivers/scsi/qla2xxx/qla_iocb.c:1825:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1825:45: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:1825:45: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_out
   drivers/scsi/qla2xxx/qla_iocb.c:1852:31: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1852:31: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:1852:31: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1861:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1861:29: sparse:    expected unsigned short [usertype] dseg_count
   drivers/scsi/qla2xxx/qla_iocb.c:1861:29: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1418:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1418:37: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:1418:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1426:40: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1426:40: sparse:    expected unsigned short [usertype] control_flags
   drivers/scsi/qla2xxx/qla_iocb.c:1426:40: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1429:40: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1429:40: sparse:    expected unsigned short [usertype] control_flags
   drivers/scsi/qla2xxx/qla_iocb.c:1429:40: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:780:30: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:780:30: sparse:    expected unsigned int [usertype] ref_tag
   drivers/scsi/qla2xxx/qla_iocb.c:780:30: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:797:30: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:797:30: sparse:    expected unsigned short [usertype] app_tag
   drivers/scsi/qla2xxx/qla_iocb.c:797:30: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:801:30: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:801:30: sparse:    expected unsigned int [usertype] ref_tag
   drivers/scsi/qla2xxx/qla_iocb.c:801:30: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:826:30: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:826:30: sparse:    expected unsigned int [usertype] ref_tag
   drivers/scsi/qla2xxx/qla_iocb.c:826:30: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:828:30: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:828:30: sparse:    expected unsigned short [usertype] app_tag
   drivers/scsi/qla2xxx/qla_iocb.c:828:30: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1484:36: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1484:36: sparse:    expected unsigned short [usertype] fcp_cmnd_dseg_len
   drivers/scsi/qla2xxx/qla_iocb.c:1484:36: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1547:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1547:29: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:1547:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1550:17: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1550:17: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1550:17: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1553:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1553:37: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:1553:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1558:32: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_iocb.c:1558:32: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_iocb.c:1558:32: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_iocb.c:1570:40: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_iocb.c:1570:40: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_iocb.c:1570:40: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_iocb.c:1872:26: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1872:26: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_iocb.c:1872:26: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1884:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1884:26: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:1884:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_in
   drivers/scsi/qla2xxx/qla_iocb.c:1960:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1960:45: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_iocb.c:1960:45: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_out
   drivers/scsi/qla2xxx/qla_iocb.c:1984:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1984:29: sparse:    expected unsigned short [usertype] dseg_count
   drivers/scsi/qla2xxx/qla_iocb.c:1984:29: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:1987:31: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:1987:31: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_iocb.c:1987:31: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2002:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:2002:29: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:2002:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:715:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:715:37: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_iocb.c:715:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:723:42: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:723:42: sparse:    expected unsigned short [usertype] task_mgmt_flags
   drivers/scsi/qla2xxx/qla_iocb.c:723:42: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:727:42: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_iocb.c:727:42: sparse:    expected unsigned short [usertype] task_mgmt_flags
   drivers/scsi/qla2xxx/qla_iocb.c:727:42: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_iocb.c:2021:26: sparse: sparse: incorrect type in argument 1 (different base types)
--
>> drivers/scsi/qla2xxx/qla_isr.c:300:74: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_isr.c:300:74: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_isr.c:300:74: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] wptr
   drivers/scsi/qla2xxx/qla_isr.c:302:60: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_isr.c:302:60: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:302:60: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] wptr
   drivers/scsi/qla2xxx/qla_isr.c:2442:31: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2443:31: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2444:31: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2446:31: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2447:31: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2543:37: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:2545:40: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:2547:37: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:2549:40: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:2553:25: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2564:37: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2566:40: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2567:29: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:2735:35: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2155:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2156:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2157:21: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:2158:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2159:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:2160:21: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:2177:27: sparse: sparse: restricted __be16 degrades to integer
   drivers/scsi/qla2xxx/qla_isr.c:2179:28: sparse: sparse: restricted __be32 degrades to integer
   drivers/scsi/qla2xxx/qla_isr.c:70:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:70:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_isr.c:70:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:82:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:82:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:82:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:83:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:83:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:83:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:88:42: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:88:42: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:88:42: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:91:34: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:91:34: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:91:34: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:92:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:92:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:92:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:93:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:93:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:93:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:96:33: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:96:33: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:96:33: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:101:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:101:41: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:101:41: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:102:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:102:41: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:102:41: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:103:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:103:41: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:103:41: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:112:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:112:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:112:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:113:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:113:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:113:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:117:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:117:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:117:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:118:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:118:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:118:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:190:38: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_isr.c:190:38: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_isr.c:190:38: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:197:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:197:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:197:45: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:213:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:213:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:213:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:214:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:214:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:214:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:231:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:231:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:231:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:235:33: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:235:33: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:235:33: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:236:33: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:236:33: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:236:33: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:237:33: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:237:33: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:237:33: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:251:33: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:251:33: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:251:33: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:259:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:259:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:259:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:260:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:260:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:260:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:322:22: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/scsi/qla2xxx/qla_isr.c:322:22: sparse:    expected restricted __le16 [noderef] [usertype] <asn:2> *wptr
>> drivers/scsi/qla2xxx/qla_isr.c:322:22: sparse:    got unsigned short [noderef] [usertype] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:324:22: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:324:22: sparse:    expected restricted __le16 [noderef] [usertype] <asn:2> *wptr
   drivers/scsi/qla2xxx/qla_isr.c:324:22: sparse:    got unsigned short [noderef] [usertype] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:651:30: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:676:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:676:40: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:676:40: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:684:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:684:40: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:684:40: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:685:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:685:40: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:685:40: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:690:30: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:691:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:691:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:691:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:691:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:691:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:691:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:691:30: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_isr.c:721:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:721:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:721:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:727:34: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:727:34: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:727:34: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:831:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:831:40: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:831:40: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:832:74: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:832:74: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:832:74: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:1200:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:1200:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:1200:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:1242:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:1242:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:1242:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:1243:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:1243:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:1243:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:1244:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:1244:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:1244:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:1245:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:1245:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_isr.c:1245:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_isr.c:1398:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1398:47: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1399:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1407:18: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1409:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1411:24: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1416:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1421:29: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1423:34: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1429:19: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1432:27: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1445:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1445:44: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1446:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1446:36: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1447:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1471:38: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1471:36: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:1471:36: sparse:    expected restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1471:36: sparse:    got unsigned short [usertype]
   drivers/scsi/qla2xxx/qla_isr.c:1473:31: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_isr.c:1490:36: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_isr.c:1519:27: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1532:33: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1620:38: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1621:24: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1622:24: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1629:46: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:1629:46: sparse:    expected restricted __le16 [usertype] comp_status
   drivers/scsi/qla2xxx/qla_isr.c:1629:46: sparse:    got unsigned int
   drivers/scsi/qla2xxx/qla_isr.c:1636:33: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1635:54: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_isr.c:1635:54: sparse:    expected restricted __le16 [usertype] len
   drivers/scsi/qla2xxx/qla_isr.c:1635:54: sparse:    got unsigned short [usertype]
   drivers/scsi/qla2xxx/qla_isr.c:1646:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1663:29: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_isr.c:1669:29: sparse: sparse: too many warnings
--
>> drivers/scsi/qla2xxx/qla_dbg.c:127:31: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_dbg.c:127:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:127:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:128:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:128:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:128:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:129:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:129:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:129:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:131:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:131:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:131:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:132:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:132:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:132:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:133:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:133:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:133:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:134:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:134:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:134:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:136:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:136:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:136:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:137:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:137:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:137:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:139:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:139:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:139:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:140:32: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_dbg.c:140:32: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:140:32: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:146:46: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_dbg.c:146:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:146:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:156:48: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:156:48: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:156:48: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:157:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:157:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:157:47: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:162:45: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_dbg.c:162:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:162:45: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:163:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:163:40: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:163:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:164:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:164:39: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:164:39: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:207:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:207:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:207:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:208:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:208:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:208:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:209:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:209:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:209:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:211:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:211:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:211:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:212:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:212:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:212:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:213:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:213:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:213:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:214:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:214:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:214:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:216:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:216:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:216:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:217:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:217:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:217:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:218:32: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:218:32: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:218:32: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:223:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:223:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:223:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:232:48: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:232:48: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:232:48: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:233:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:233:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:233:47: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:238:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:238:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:238:45: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:239:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:239:40: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:239:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:240:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:240:39: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:240:39: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:293:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:293:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:293:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:296:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:296:24: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:296:24: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:296:24: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:304:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:304:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:304:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:308:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:308:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:308:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:325:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:325:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:325:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:327:36: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:327:36: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:327:36: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:332:29: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:332:29: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:332:29: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:335:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:335:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:335:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:343:36: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:343:36: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:343:36: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:349:29: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:349:29: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:349:29: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:352:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:352:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:352:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:353:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:353:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:353:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:355:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:355:40: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:355:40: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:382:9: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:382:9: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:382:9: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:391:17: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:391:17: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:391:17: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:392:17: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:392:17: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:392:17: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:394:17: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:394:17: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:394:17: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:395:17: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:395:17: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:395:17: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:396:17: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:396:17: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:396:17: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:397:17: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:397:17: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:397:17: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:399:17: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:399:17: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:399:17: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:400:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:400:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:400:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:404:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:404:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:404:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:412:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:412:47: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:412:47: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:415:55: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:415:55: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:415:55: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:416:55: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:416:55: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:416:55: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:418:54: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:418:54: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:418:54: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:424:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:424:47: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:424:47: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:426:55: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:426:55: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:426:55: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:428:54: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:428:54: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:428:54: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:433:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:433:47: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:433:47: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:434:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:434:46: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:434:46: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:82:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:82:35: sparse:    expected unsigned int [usertype] fw_major_version
   drivers/scsi/qla2xxx/qla_dbg.c:82:35: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:83:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:83:35: sparse:    expected unsigned int [usertype] fw_minor_version
   drivers/scsi/qla2xxx/qla_dbg.c:83:35: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:84:38: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:84:38: sparse:    expected unsigned int [usertype] fw_subminor_version
   drivers/scsi/qla2xxx/qla_dbg.c:84:38: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:85:32: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:85:32: sparse:    expected unsigned int [usertype] fw_attributes
   drivers/scsi/qla2xxx/qla_dbg.c:85:32: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:87:25: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:87:25: sparse:    expected unsigned int [usertype] vendor
   drivers/scsi/qla2xxx/qla_dbg.c:87:25: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:88:25: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:88:25: sparse:    expected unsigned int [usertype] device
   drivers/scsi/qla2xxx/qla_dbg.c:88:25: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:89:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:89:35: sparse:    expected unsigned int [usertype] subsystem_vendor
   drivers/scsi/qla2xxx/qla_dbg.c:89:35: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:90:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:90:35: sparse:    expected unsigned int [usertype] subsystem_device
   drivers/scsi/qla2xxx/qla_dbg.c:90:35: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:759:20: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:759:18: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:759:18: sparse:    expected unsigned short [usertype] hccr
   drivers/scsi/qla2xxx/qla_dbg.c:759:18: sparse:    got restricted __be16 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:762:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:762:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:762:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:765:35: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:765:35: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:765:35: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:773:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:773:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:773:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_dbg.c:780:45: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:780:43: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:780:43: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_dbg.c:780:43: sparse:    got restricted __be16 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:785:50: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:785:48: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:785:48: sparse:    expected unsigned short
   drivers/scsi/qla2xxx/qla_dbg.c:785:48: sparse:    got restricted __be16 [usertype]
   drivers/scsi/qla2xxx/qla_dbg.c:790:48: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:790:48: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:790:48: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:790:48: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_dbg.c:790:48: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_dbg.c:790:48: sparse:    got unsigned short [noderef] [usertype] <asn:2> *[assigned] dmp_reg
   drivers/scsi/qla2xxx/qla_dbg.c:790:48: sparse: sparse: too many warnings
--
   drivers/scsi/qla2xxx/qla_sup.c:29:37: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_sup.c:29:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_sup.c:29:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:32:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:32:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:32:45: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:36:31: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_sup.c:36:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:36:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:37:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:37:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:37:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:39:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:39:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:39:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:43:39: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:43:39: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:43:39: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:44:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:44:38: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:44:38: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:46:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:46:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:46:45: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:61:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:61:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:61:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:62:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:62:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:62:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:76:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:76:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:76:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:77:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:77:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:77:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:79:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:79:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:79:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:81:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:81:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:81:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:83:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:83:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:83:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:84:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:84:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:84:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:123:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:123:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:123:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:124:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:124:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:124:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:127:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:127:41: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:127:41: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:130:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:130:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:130:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:131:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:131:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:131:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:136:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:136:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:136:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:137:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:137:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:137:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:174:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:174:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:174:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:175:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:175:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:175:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:219:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:219:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:219:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:220:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:220:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:220:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:229:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:229:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:229:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:278:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:278:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:278:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:279:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:279:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:279:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:282:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:282:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:282:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:317:19: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:317:19: sparse:    expected unsigned short [usertype] wprot_old
   drivers/scsi/qla2xxx/qla_sup.c:317:19: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_sup.c:319:45: sparse: sparse: incorrect type in argument 3 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:319:45: sparse:    expected unsigned short [usertype] data
   drivers/scsi/qla2xxx/qla_sup.c:319:45: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_sup.c:320:15: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:320:15: sparse:    expected unsigned short [usertype] wprot
   drivers/scsi/qla2xxx/qla_sup.c:320:15: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_sup.c:350:31: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:350:31: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:350:31: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:351:30: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:351:30: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:351:30: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:360:45: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:360:45: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:360:45: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:410:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:410:23: sparse:    expected restricted __le16 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:410:23: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:411:22: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:411:22: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:411:22: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:420:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:420:37: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:420:37: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:459:24: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_sup.c:459:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_sup.c:459:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:462:35: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_sup.c:462:35: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:462:35: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:463:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:463:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:463:47: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:502:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:502:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:502:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:503:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:503:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:503:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:506:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:506:37: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:506:37: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:616:27: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:627:19: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:628:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:688:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:690:29: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_sup.c:693:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:693:48: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:694:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:698:31: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:700:27: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:704:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:704:48: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:705:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:709:15: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:712:25: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_sup.c:715:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:716:21: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_sup.c:717:21: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_sup.c:722:25: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:959:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:965:27: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:970:34: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:977:15: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:978:15: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:987:30: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_sup.c:1055:22: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_sup.c:1059:45: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_sup.c:1061:42: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_sup.c:1117:28: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_sup.c:1119:28: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_sup.c:1123:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1123:47: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1124:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1138:30: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1140:27: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1145:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1145:47: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1146:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1151:15: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1159:25: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1175:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_sup.c:1200:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1200:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:1200:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:1201:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1201:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:1201:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:1202:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1202:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:1202:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:1243:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1243:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:1243:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:1244:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1244:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:1244:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:1355:49: sparse: sparse: incorrect type in argument 3 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1355:49: sparse:    expected unsigned int [usertype] data
   drivers/scsi/qla2xxx/qla_sup.c:1355:49: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_sup.c:1389:25: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1389:25: sparse:    expected unsigned short [usertype]
   drivers/scsi/qla2xxx/qla_sup.c:1389:25: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_sup.c:1440:21: sparse: sparse: incorrect type in argument 3 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1440:21: sparse:    expected unsigned short [usertype] data
   drivers/scsi/qla2xxx/qla_sup.c:1440:21: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_sup.c:1469:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1469:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:1469:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:1470:27: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1470:27: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:1470:27: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:1471:23: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1471:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_sup.c:1471:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_sup.c:1481:58: sparse: sparse: incorrect type in argument 3 (different base types)
   drivers/scsi/qla2xxx/qla_sup.c:1481:58: sparse:    expected unsigned int [usertype] data
   drivers/scsi/qla2xxx/qla_sup.c:1481:58: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_sup.c:1493:24: sparse: sparse: too many warnings
--
   drivers/scsi/qla2xxx/qla_nx.c:1568:25: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1570:26: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1569:26: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1569:24: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1569:24: sparse:    expected restricted __le32 [usertype] offset
   drivers/scsi/qla2xxx/qla_nx.c:1569:24: sparse:    got unsigned int
   drivers/scsi/qla2xxx/qla_nx.c:1571:28: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1573:21: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1574:73: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1585:19: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1585:19: sparse: sparse: incorrect type in initializer (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1585:19: sparse:    expected int idx
   drivers/scsi/qla2xxx/qla_nx.c:1585:19: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:1594:14: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1593:18: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1593:16: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1593:16: sparse:    expected restricted __le32 [usertype] offset
   drivers/scsi/qla2xxx/qla_nx.c:1593:16: sparse:    got unsigned int
   drivers/scsi/qla2xxx/qla_nx.c:1596:56: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1609:32: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1609:32: sparse:    expected unsigned int [usertype] offset
   drivers/scsi/qla2xxx/qla_nx.c:1609:32: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:1640:32: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1640:32: sparse:    expected unsigned int [usertype] offset
   drivers/scsi/qla2xxx/qla_nx.c:1640:32: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:1787:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1787:35: sparse:    expected unsigned short [usertype] request_q_outpointer
   drivers/scsi/qla2xxx/qla_nx.c:1787:35: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:1788:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1788:35: sparse:    expected unsigned short [usertype] response_q_inpointer
   drivers/scsi/qla2xxx/qla_nx.c:1788:35: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:1789:31: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1789:31: sparse:    expected unsigned short [usertype] request_q_length
   drivers/scsi/qla2xxx/qla_nx.c:1789:31: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:1790:32: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1790:32: sparse:    expected unsigned short [usertype] response_q_length
   drivers/scsi/qla2xxx/qla_nx.c:1790:32: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:1794:38: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_nx.c:1794:38: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_nx.c:1794:38: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:1795:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1795:37: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:1795:37: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:1796:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1796:38: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:1796:38: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:1865:25: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1867:30: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1866:26: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1866:24: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:1866:24: sparse:    expected restricted __le32 [usertype] offset
   drivers/scsi/qla2xxx/qla_nx.c:1866:24: sparse:    got unsigned int
   drivers/scsi/qla2xxx/qla_nx.c:1868:25: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1870:32: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1875:33: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:1875:71: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_nx.c:2004:14: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/scsi/qla2xxx/qla_nx.c:2004:14: sparse:    expected restricted __le16 [noderef] [usertype] <asn:2> *wptr
>> drivers/scsi/qla2xxx/qla_nx.c:2004:14: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2073:35: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_nx.c:2073:35: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2073:35: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2074:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2074:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2074:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2086:70: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_nx.c:2086:70: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2086:70: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2087:70: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2087:70: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2087:70: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2088:70: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2088:70: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2088:70: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2101:32: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2101:32: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2101:32: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2139:42: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2139:42: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2139:42: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2143:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2143:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2143:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2155:70: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2155:70: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2155:70: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2156:70: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2156:70: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2156:70: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2157:70: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2157:70: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2157:70: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2170:32: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2170:32: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2170:32: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2200:34: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2200:34: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2200:34: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2204:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2204:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2204:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2235:34: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2235:34: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2235:34: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2239:38: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2239:38: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2239:38: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2250:62: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2250:62: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2250:62: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2251:62: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2251:62: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2251:62: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2252:62: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2252:62: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2252:62: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2264:32: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2264:32: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx.c:2264:32: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx.c:2568:26: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2568:26: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:2568:26: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:2762:21: sparse: sparse: incorrect type in argument 3 (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:2762:21: sparse:    expected unsigned int [usertype] data
   drivers/scsi/qla2xxx/qla_nx.c:2762:21: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3859:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:3859:29: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3859:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3884:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:3884:29: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3884:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3885:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:3885:29: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3885:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3907:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:3907:29: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3907:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3908:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:3908:29: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3908:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3964:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:3964:37: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:3964:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:4000:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:4000:37: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:4000:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:4030:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:4030:37: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:4030:37: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:4058:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:4058:29: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:4058:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:4124:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nx.c:4124:37: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_nx.c:4124:37: sparse:    got restricted __le32 [usertype]
--
   drivers/scsi/qla2xxx/qla_mr.c:56:21: sparse: sparse: restricted pci_channel_state_t degrades to integer
   drivers/scsi/qla2xxx/qla_mr.c:56:37: sparse: sparse: restricted pci_channel_state_t degrades to integer
   drivers/scsi/qla2xxx/qla_mr.c:113:14: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/scsi/qla2xxx/qla_mr.c:113:14: sparse:    expected restricted __le32 [noderef] [usertype] <asn:2> *optr
>> drivers/scsi/qla2xxx/qla_mr.c:113:14: sparse:    got unsigned int [noderef] <asn:2> *
>> drivers/scsi/qla2xxx/qla_mr.c:680:24: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_mr.c:680:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:680:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:681:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:681:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:681:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:683:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:683:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:683:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:684:24: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:684:24: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:684:24: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:687:23: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_mr.c:687:23: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:687:23: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:916:36: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:916:36: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:916:36: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:918:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:918:41: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:918:41: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:929:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:929:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:929:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:948:49: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:948:49: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:948:49: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:951:57: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:951:57: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:951:57: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:952:57: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:952:57: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:952:57: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:953:57: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:953:57: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:953:57: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:954:57: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:954:57: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:954:57: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:955:40: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:955:40: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:955:40: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:956:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:956:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:956:47: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:986:49: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:986:49: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:986:49: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:989:57: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:989:57: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:989:57: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:990:57: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:990:57: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:990:57: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:991:57: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:991:57: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:991:57: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:992:57: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:992:57: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:992:57: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:1038:51: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:1038:51: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:1038:51: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:1448:33: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:1448:33: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:1448:33: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:1451:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:1451:41: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:1451:41: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:1452:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:1452:41: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:1452:41: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:1453:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:1453:41: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:1453:41: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:1454:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:1454:41: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:1454:41: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:1499:55: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:1499:55: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:1499:55: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:1519:41: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:1519:41: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:1519:41: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2725:37: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2725:37: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mr.c:2725:37: sparse:    got unsigned int [noderef] [usertype] <asn:2> *rsp_q_in
   drivers/scsi/qla2xxx/qla_mr.c:2787:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2787:26: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mr.c:2787:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *rsp_q_out
   drivers/scsi/qla2xxx/qla_mr.c:2818:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2818:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2818:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2819:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2819:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2819:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2820:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2820:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2820:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2850:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2850:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2850:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2851:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2851:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2851:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2852:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2852:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2852:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2853:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2853:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2853:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2854:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2854:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2854:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2855:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2855:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2855:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2856:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2856:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2856:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2886:14: sparse: sparse: incorrect type in assignment (different base types)
>> drivers/scsi/qla2xxx/qla_mr.c:2886:14: sparse:    expected restricted __le32 [noderef] [usertype] <asn:2> *wptr
   drivers/scsi/qla2xxx/qla_mr.c:2886:14: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2943:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2943:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2943:47: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:2949:54: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:2949:54: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_mr.c:2949:54: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_mr.c:3117:47: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:3117:47: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mr.c:3117:47: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_out
   drivers/scsi/qla2xxx/qla_mr.c:3182:26: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_mr.c:3182:26: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_mr.c:3182:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_in
   arch/x86/include/asm/bitops.h:77:37: sparse: sparse: cast truncates bits from constant value (ffffff7f becomes 7f)
--
>> drivers/scsi/qla2xxx/qla_nx2.c:3949:35: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_nx2.c:3949:35: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_nx2.c:3949:35: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx2.c:3950:46: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx2.c:3950:46: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx2.c:3950:46: sparse:    got unsigned int [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx2.c:3964:70: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_nx2.c:3964:70: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_nx2.c:3964:70: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx2.c:3965:70: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx2.c:3965:70: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx2.c:3965:70: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx2.c:3966:70: sparse: sparse: incorrect type in argument 1 (different base types)
   drivers/scsi/qla2xxx/qla_nx2.c:3966:70: sparse:    expected restricted __le16 const volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx2.c:3966:70: sparse:    got unsigned short [noderef] <asn:2> *
   drivers/scsi/qla2xxx/qla_nx2.c:3979:32: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_nx2.c:3979:32: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
   drivers/scsi/qla2xxx/qla_nx2.c:3979:32: sparse:    got unsigned int [noderef] <asn:2> *
--
   drivers/scsi/qla2xxx/qla_target.c:5768:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5779:21: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_target.c:5783:29: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5828:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5838:21: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5854:29: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5855:29: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:5858:29: sparse: sparse: restricted __le16 degrades to integer
   drivers/scsi/qla2xxx/qla_target.c:5862:37: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1689:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1691:25: sparse: sparse: restricted __le32 degrades to integer
   drivers/scsi/qla2xxx/qla_target.c:1700:33: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:1700:33: sparse:    expected unsigned short [usertype] srr_flags
   drivers/scsi/qla2xxx/qla_target.c:1700:33: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2132:13: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:2154:13: sparse: sparse: cast to restricted __le32
   drivers/scsi/qla2xxx/qla_target.c:2478:45: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_target.c:2478:45: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_target.c:2478:45: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_out
   drivers/scsi/qla2xxx/qla_target.c:837:13: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:845:19: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1177:19: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1318:36: sparse: sparse: cast to restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:1760:15: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:1760:15: sparse:    expected unsigned int [usertype] f_ctl
   drivers/scsi/qla2xxx/qla_target.c:1760:15: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:1832:15: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:1832:15: sparse:    expected unsigned int [usertype] f_ctl
   drivers/scsi/qla2xxx/qla_target.c:1832:15: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:1905:23: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:1905:23: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:1905:23: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:1924:31: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:1924:31: sparse:    expected restricted __le16 [usertype] ox_id
   drivers/scsi/qla2xxx/qla_target.c:1924:31: sparse:    got unsigned short [usertype] ox_id
   drivers/scsi/qla2xxx/qla_target.c:2218:23: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2218:23: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:2218:23: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2227:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2227:37: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:2227:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2229:38: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2229:38: sparse:    expected unsigned short [usertype] response_len
   drivers/scsi/qla2xxx/qla_target.c:2229:38: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2275:23: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2275:23: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:2275:23: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2284:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2284:37: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:2284:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2286:38: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2286:38: sparse:    expected unsigned short [usertype] response_len
   drivers/scsi/qla2xxx/qla_target.c:2286:38: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.h:382:17: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:2287:34: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2287:34: sparse:    expected unsigned int [usertype] residual
   drivers/scsi/qla2xxx/qla_target.c:2287:34: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2290:45: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_target.c:2290:45: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_target.c:2290:45: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:2576:27: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2576:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_target.c:2576:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2577:22: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2577:22: sparse:    expected unsigned short [usertype] timeout
   drivers/scsi/qla2xxx/qla_target.c:2577:22: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2584:40: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2584:40: sparse:    expected unsigned int [usertype] relative_offset
   drivers/scsi/qla2xxx/qla_target.c:2584:40: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2639:42: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2639:42: sparse:    expected unsigned int [usertype] transfer_length
   drivers/scsi/qla2xxx/qla_target.c:2639:42: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2646:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2646:35: sparse:    expected unsigned short [usertype] dseg_count
   drivers/scsi/qla2xxx/qla_target.c:2646:35: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2808:34: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2808:34: sparse:    expected unsigned int [usertype] residual
   drivers/scsi/qla2xxx/qla_target.c:2808:34: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2809:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2809:37: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:2809:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2830:45: sparse: sparse: invalid assignment: |=
   drivers/scsi/qla2xxx/qla_target.c:2830:45: sparse:    left side has type unsigned short
   drivers/scsi/qla2xxx/qla_target.c:2830:45: sparse:    right side has type restricted __le16
   drivers/scsi/qla2xxx/qla_target.c:2832:46: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2832:46: sparse:    expected unsigned short [usertype] sense_length
   drivers/scsi/qla2xxx/qla_target.c:2832:46: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2835:69: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:2835:69: sparse:    expected unsigned int [usertype]
   drivers/scsi/qla2xxx/qla_target.c:2835:69: sparse:    got restricted __be32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3089:27: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:3089:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_target.c:3089:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3271:60: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:3271:60: sparse:    expected unsigned short [usertype] scsi_status
   drivers/scsi/qla2xxx/qla_target.c:3271:60: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3273:57: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:3273:57: sparse:    expected unsigned int [usertype] residual
   drivers/scsi/qla2xxx/qla_target.c:3273:57: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3089:27: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_target.c:3089:27: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_target.c:3089:27: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_target.c:3449:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3449:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3449:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3449:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3450:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3450:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3450:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3450:26: sparse: sparse: cast to restricted __be16
   drivers/scsi/qla2xxx/qla_target.c:3451:26: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:3451:26: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:3451:26: sparse: sparse: cast to restricted __be32
   drivers/scsi/qla2xxx/qla_target.c:3451:26: sparse: sparse: cast to restricted __be32
--
>> drivers/scsi/qla2xxx/qla_nvme.c:387:45: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_nvme.c:387:45: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_nvme.c:387:45: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_out
   drivers/scsi/qla2xxx/qla_nvme.c:450:31: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nvme.c:450:31: sparse:    expected unsigned short [usertype] nport_handle
   drivers/scsi/qla2xxx/qla_nvme.c:450:31: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_nvme.c:457:35: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nvme.c:457:35: sparse:    expected unsigned short [usertype] nvme_rsp_dsd_len
   drivers/scsi/qla2xxx/qla_nvme.c:457:35: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_nvme.c:461:37: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nvme.c:461:37: sparse:    expected unsigned short [usertype] nvme_cmnd_dseg_len
   drivers/scsi/qla2xxx/qla_nvme.c:461:37: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_nvme.c:464:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nvme.c:464:29: sparse:    expected unsigned short [usertype] dseg_count
   drivers/scsi/qla2xxx/qla_nvme.c:464:29: sparse:    got restricted __le16 [usertype]
   drivers/scsi/qla2xxx/qla_nvme.c:465:29: sparse: sparse: incorrect type in assignment (different base types)
   drivers/scsi/qla2xxx/qla_nvme.c:465:29: sparse:    expected unsigned int [usertype] byte_count
   drivers/scsi/qla2xxx/qla_nvme.c:465:29: sparse:    got restricted __le32 [usertype]
   drivers/scsi/qla2xxx/qla_nvme.c:517:26: sparse: sparse: incorrect type in argument 1 (different base types)
>> drivers/scsi/qla2xxx/qla_nvme.c:517:26: sparse:    expected restricted __le32 volatile [noderef] [usertype] <asn:2> *addr
>> drivers/scsi/qla2xxx/qla_nvme.c:517:26: sparse:    got unsigned int [noderef] [usertype] <asn:2> *req_q_in

vim +1203 drivers/scsi/qla2xxx/qla_os.c

2533cf671da060 Lalit Chandivade 2009-03-24  1179  
a465537ad1a442 Sawan Chandak    2016-07-06  1180  #define ISP_REG_DISCONNECT 0xffffffffU
a465537ad1a442 Sawan Chandak    2016-07-06  1181  /**************************************************************************
a465537ad1a442 Sawan Chandak    2016-07-06  1182  * qla2x00_isp_reg_stat
a465537ad1a442 Sawan Chandak    2016-07-06  1183  *
a465537ad1a442 Sawan Chandak    2016-07-06  1184  * Description:
a465537ad1a442 Sawan Chandak    2016-07-06  1185  *	Read the host status register of ISP before aborting the command.
a465537ad1a442 Sawan Chandak    2016-07-06  1186  *
a465537ad1a442 Sawan Chandak    2016-07-06  1187  * Input:
a465537ad1a442 Sawan Chandak    2016-07-06  1188  *	ha = pointer to host adapter structure.
a465537ad1a442 Sawan Chandak    2016-07-06  1189  *
a465537ad1a442 Sawan Chandak    2016-07-06  1190  *
a465537ad1a442 Sawan Chandak    2016-07-06  1191  * Returns:
a465537ad1a442 Sawan Chandak    2016-07-06  1192  *	Either true or false.
a465537ad1a442 Sawan Chandak    2016-07-06  1193  *
a465537ad1a442 Sawan Chandak    2016-07-06  1194  * Note:	Return true if there is register disconnect.
a465537ad1a442 Sawan Chandak    2016-07-06  1195  **************************************************************************/
a465537ad1a442 Sawan Chandak    2016-07-06  1196  static inline
a465537ad1a442 Sawan Chandak    2016-07-06  1197  uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
a465537ad1a442 Sawan Chandak    2016-07-06  1198  {
a465537ad1a442 Sawan Chandak    2016-07-06  1199  	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
bf6061b17a8d47 Sawan Chandak    2017-03-31  1200  	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
a465537ad1a442 Sawan Chandak    2016-07-06  1201  
bf6061b17a8d47 Sawan Chandak    2017-03-31  1202  	if (IS_P3P_TYPE(ha))
bf6061b17a8d47 Sawan Chandak    2017-03-31 @1203  		return ((RD_REG_DWORD(&reg82->host_int)) == ISP_REG_DISCONNECT);
bf6061b17a8d47 Sawan Chandak    2017-03-31  1204  	else
bf6061b17a8d47 Sawan Chandak    2017-03-31 @1205  		return ((RD_REG_DWORD(&reg->host_status)) ==
bf6061b17a8d47 Sawan Chandak    2017-03-31  1206  			ISP_REG_DISCONNECT);
a465537ad1a442 Sawan Chandak    2016-07-06  1207  }
a465537ad1a442 Sawan Chandak    2016-07-06  1208  

:::::: The code at line 1203 was first introduced by commit
:::::: bf6061b17a8d47ef0d9344d3ef576a4ff0edf793 scsi: qla2xxx: Add fix to read correct register value for ISP82xx.

:::::: TO: Sawan Chandak <sawan.chandak@cavium.com>
:::::: CC: Martin K. Petersen <martin.petersen@oracle.com>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
