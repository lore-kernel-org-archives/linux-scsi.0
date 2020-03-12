Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D686C2BB1D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 16:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FF1420663
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 16:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgCLQZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 12:25:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:7804 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbgCLQZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 12:25:09 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 09:25:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="322522522"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001.jf.intel.com with ESMTP; 12 Mar 2020 09:25:05 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jCQdv-0092ut-3b; Thu, 12 Mar 2020 18:25:07 +0200
Date:   Thu, 12 Mar 2020 18:25:07 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-nvme@lists.infradead.org, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v1] asm-generic: Provide generic {get, put}_unaligned_{l,
 b}e24()
Message-ID: <20200312162507.GF1922688@smile.fi.intel.com>
References: <20200312113941.81162-1-andriy.shevchenko@linux.intel.com>
 <efe5daa3-8e37-101a-9203-676be33eb934@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efe5daa3-8e37-101a-9203-676be33eb934@acm.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 12, 2020 at 08:18:07AM -0700, Bart Van Assche wrote:
> On 2020-03-12 04:39, Andy Shevchenko wrote:
> > There are users in kernel that duplicate {get,put}_unaligned_{l,b}e24()
> > implementation. Provide generic helpers once for all.
> 
> Hi Andy,
> 
> Thanks for having done this work. In case you would not yet have noticed
> the patch series that I posted some time ago but for which I did not
> have the time to continue working on it, please take a look at
> https://lore.kernel.org/lkml/20191028200700.213753-1-bvanassche@acm.org/.

Can you send a new version?

Also, consider to use byteshift to avoid this limitation:
"Only use get_unaligned_be24() if reading p - 1 is allowed."


-- 
With Best Regards,
Andy Shevchenko


