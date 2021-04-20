Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C959C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A112613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhDTPZT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 11:25:19 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42876 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232910AbhDTPZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 11:25:09 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 33199413B8;
        Tue, 20 Apr 2021 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1618932274;
         x=1620746675; bh=0eIYA74qGdLkfs4Zvg1YeU6bDvOKM8s0DUNeGdhY/Gc=; b=
        D+j5IieF2ypupt9SUam8EMoIU0ZZGFRfwiXR8/DmrkOG9DKbfvOXKIFvNgR10vaB
        d7nfBsP9dWavUgKn7j389rVB6Y1u+u2muBjhfq2ehVfRGvylFxvhGIH6CS+j5Yb2
        za3iwJePHUv/O41rf/q33VQbiFbsw68TjMU9honntLM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jiFE39XJcbqr; Tue, 20 Apr 2021 18:24:34 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A172841380;
        Tue, 20 Apr 2021 18:24:33 +0300 (MSK)
Received: from yadro.com (10.199.0.12) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 20
 Apr 2021 18:24:33 +0300
Date:   Tue, 20 Apr 2021 18:24:30 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     kernel test robot <lkp@intel.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, <kbuild-all@lists.01.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 2/2] scsi: target: Add the VERSION DESCRIPTOR fields to
 the INQUIRY data
Message-ID: <YH7yLuCdwf/sL4sl@yadro.com>
References: <20210412224427.101167-3-k.shelekhin@yadro.com>
 <202104191409.Cq0ExT9f-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <202104191409.Cq0ExT9f-lkp@intel.com>
X-Originating-IP: [10.199.0.12]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2021 at 02:57:10PM +0800, kernel test robot wrote:
> Hi Konstantin,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on mkp-scsi/for-next]
> [also build test WARNING on scsi/for-next v5.12-rc8 next-20210416]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Konstantin-Shelekhin/scsi-target-Introduce-the-version-descriptors/20210413-064553
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: ia64-randconfig-s031-20210419 (attached as .config)
> compiler: ia64-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.3-330-g09ec74f6-dirty
>         # https://github.com/0day-ci/linux/commit/88a1d08b46b716d2e970659571d353faa4475a88
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Konstantin-Shelekhin/scsi-target-Introduce-the-version-descriptors/20210413-064553
>         git checkout 88a1d08b46b716d2e970659571d353faa4475a88
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' W=1 ARCH=ia64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
>    drivers/target/target_core_spc.c: note: in included file (through arch/ia64/include/asm/unaligned.h):
>    include/linux/unaligned/be_byteshift.h:26:16: sparse: sparse: cast truncates bits from constant value (460 becomes 60)
> >> include/linux/unaligned/be_byteshift.h:26:16: sparse: sparse: cast truncates bits from constant value (4c0 becomes c0)
> 
> vim +26 include/linux/unaligned/be_byteshift.h
> 
> 064106a91be5e7 Harvey Harrison 2008-04-29  22  
> 064106a91be5e7 Harvey Harrison 2008-04-29  23  static inline void __put_unaligned_be16(u16 val, u8 *p)
> 064106a91be5e7 Harvey Harrison 2008-04-29  24  {
> 064106a91be5e7 Harvey Harrison 2008-04-29  25  	*p++ = val >> 8;
> 064106a91be5e7 Harvey Harrison 2008-04-29 @26  	*p++ = val;
> 064106a91be5e7 Harvey Harrison 2008-04-29  27  }
> 064106a91be5e7 Harvey Harrison 2008-04-29  28  

This looks like a sparse issue to me, no?
