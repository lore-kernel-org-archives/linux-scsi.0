From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] mptfusion: Use snprintf() instead of open coded divisions
Date: Wed, 17 Jan 2018 01:14:21 -0500
Message-ID: <yq1inc1t3k2.fsf@oracle.com>
References: <20180115170558.86823-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45448 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbeAQGO1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 01:14:27 -0500
In-Reply-To: <20180115170558.86823-1-andriy.shevchenko@linux.intel.com> (Andy
        Shevchenko's message of "Mon, 15 Jan 2018 19:05:58 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org


Andy,

> Numbers up to 100 snprintf() prints without using a division.
> Besides that the code looks more readable.

Applied to 4.16/scsi-queue (despite not really being a fan of cleaning
up dead code). Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
