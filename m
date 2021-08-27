Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A4CC4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE83B60FD9
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244530AbhH0Hw4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:52:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:44331 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244507AbhH0Hwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 03:52:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="303492623"
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="303492623"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:52:02 -0700
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="457447060"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:51:59 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mJWeV-00EFZG-TS; Fri, 27 Aug 2021 10:51:51 +0300
Date:   Fri, 27 Aug 2021 10:51:51 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Joe Perches <joe@perches.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-scsi@vger.kernel.org, storagedev@microchip.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH 0/5] vsprintf and uses: Add upper case output to %*ph
 extension
Message-ID: <YSiZlyQzgW8umsjj@smile.fi.intel.com>
References: <cover.1630003183.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1630003183.git.joe@perches.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 26, 2021 at 11:43:00AM -0700, Joe Perches wrote:
> Several sysfs uses that could use %*ph are upper case hex output.
> Add a flag to the short hex formatting routine in vsprintf to support them.
> Add documentation too.

Thanks!

Unfortunately I have got only first patch and this cover letter. Can you,
please, Cc entire series?

-- 
With Best Regards,
Andy Shevchenko


