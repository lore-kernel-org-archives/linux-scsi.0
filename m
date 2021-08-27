Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0903AC4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 08:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E479C60187
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 08:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244617AbhH0IrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 04:47:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:23139 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244548AbhH0IrS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 04:47:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="278936755"
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="278936755"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 01:46:28 -0700
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="599107092"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 01:46:26 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mJXVE-00EGyS-UN; Fri, 27 Aug 2021 11:46:20 +0300
Date:   Fri, 27 Aug 2021 11:46:20 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Joe Perches <joe@perches.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-scsi@vger.kernel.org, storagedev@microchip.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH 0/5] vsprintf and uses: Add upper case output to %*ph
 extension
Message-ID: <YSimXPUVcy9zhpYG@smile.fi.intel.com>
References: <cover.1630003183.git.joe@perches.com>
 <YSiZlyQzgW8umsjj@smile.fi.intel.com>
 <4b8e2987c1ff384bac497a20fcd75f9051990cff.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b8e2987c1ff384bac497a20fcd75f9051990cff.camel@perches.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 27, 2021 at 01:10:41AM -0700, Joe Perches wrote:
> On Fri, 2021-08-27 at 10:51 +0300, Andy Shevchenko wrote:
> > On Thu, Aug 26, 2021 at 11:43:00AM -0700, Joe Perches wrote:
> > > Several sysfs uses that could use %*ph are upper case hex output.
> > > Add a flag to the short hex formatting routine in vsprintf to support them.
> > > Add documentation too.
> >
> > Thanks!
> >
> > Unfortunately I have got only first patch and this cover letter. Can you,
> > please, Cc entire series?
> 
> It's on lore.
> 
> https://lore.kernel.org/lkml/cover.1630003183.git.joe@perches.com/T/#u

Thanks. So, you won't me to review them in a regular way :-)

TBH, I think those examples may pretty much be safe to use small
letters always.

-- 
With Best Regards,
Andy Shevchenko


