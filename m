Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEC6C388F7
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 14:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 660F52463B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 14:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900797AbgJVOVR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 10:21:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:55111 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900764AbgJVOVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 10:21:17 -0400
IronPort-SDR: /HO3qUQvHxRbTNjN0qc7oKvslPof9r0ZvIQzF6StIoL5CCPY2Gv6PiOR7R5xQEd2N4iafpnxMq
 HxlWzEFCAgrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="154485999"
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="154485999"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 07:21:15 -0700
IronPort-SDR: /BIOu7vwq2pI3cd9ST+/ILnIqGeUW4ipyIJtNqfiM6qBFpvhmE6GTW6FRPYf7d7ui4uxBShqKl
 8AN5ZEE4T9JQ==
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="524295100"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 07:21:11 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kVbTp-00DL3d-T9; Thu, 22 Oct 2020 17:22:13 +0300
Date:   Thu, 22 Oct 2020 17:22:13 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Luo Jiaxing <luojiaxing@huawei.com>
Cc:     akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        john.garry@huawei.com, himanshu.madhani@cavium.com,
        felipe.balbi@linux.intel.com, gregkh@linuxfoundation.org,
        uma.shankar@intel.com, anshuman.gupta@intel.com,
        animesh.manna@intel.com, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v1 1/5] seq_file: Introduce DEFINE_STORE_ATTRIBUTE()
 helper macro
Message-ID: <20201022142213.GC4077@smile.fi.intel.com>
References: <1603355997-32350-1-git-send-email-luojiaxing@huawei.com>
 <1603355997-32350-2-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603355997-32350-2-git-send-email-luojiaxing@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 22, 2020 at 04:39:53PM +0800, Luo Jiaxing wrote:
> We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
> for read-only file, but we found many of drivers want a helper marco for
> read-write file too.

I would expect that DEFINE_STORE maps to WO attribute...
For RW SHOW_STORE would be more appropriate.

Otherwise I think it makes sense.

-- 
With Best Regards,
Andy Shevchenko


