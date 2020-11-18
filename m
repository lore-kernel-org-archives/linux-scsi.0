Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC74C2D0E4
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0272A221FB
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 01:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgKRBVk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 20:21:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:7287 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbgKRBVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 20:21:40 -0500
IronPort-SDR: nPn+sFRZwZvnKfbj+P2wQ/a2/t9Yody+IJpG2DTs/mYQ/Q4bRb90s5H6tsylCxcGCqsa1bg7OB
 bJxgHclnKuMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9808"; a="158077816"
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="158077816"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 17:21:39 -0800
IronPort-SDR: MAYuiPPJ6h8H2Dtpl7mj+OrVGXqgAk7sdvO7TLKTW7CHDvUTbK8TTxKlNhb8JMyqNp3+f3khTG
 hX4KL1VGo3Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="534025770"
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.159.39])
  by fmsmga005.fm.intel.com with ESMTP; 17 Nov 2020 17:21:34 -0800
Date:   Wed, 18 Nov 2020 09:16:54 +0800
From:   Philip Li <philip.li@intel.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     kernel test robot <oliver.sang@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        0day robot <lkp@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org
Subject: Re: [LKP] Re: [block, scsi, ide] 3e3b42fee6:
 kmsg.sd#:#:#:#:[sdf]Asking_for_cache_data_failed
Message-ID: <20201118011654.GB19125@intel.com>
References: <20201117143350.GA17824@xsang-OptiPlex-9020>
 <38bed525-3453-f614-7310-ad01f1bc2605@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38bed525-3453-f614-7310-ad01f1bc2605@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2020 at 08:46:46AM -0800, Bart Van Assche wrote:
> On 11/17/20 8:00 AM, kernel test robot wrote:
> > on test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz with 32G memory
> > 
> > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> Please fix the test bot. The DID_ERROR messages are reported during test
sorry for the false positive, we will resolve this problem soon. Thanks
for your feedback.

> block/001 and in the attached dmesg output I found the following:
> 
> block/001 (stress device hotplugging)                        [passed]
> 
> Bart.
> _______________________________________________
> LKP mailing list -- lkp@lists.01.org
> To unsubscribe send an email to lkp-leave@lists.01.org
