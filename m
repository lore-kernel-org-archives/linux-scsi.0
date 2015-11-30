From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 1/1] scsi_debug: check for bigger value first
Date: Mon, 30 Nov 2015 12:14:21 -0500
Message-ID: <yq1d1urif4i.fsf@sermon.lab.mkp.net>
References: <1448562170-122075-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25097 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbbK3RPO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2015 12:15:14 -0500
In-Reply-To: <1448562170-122075-1-git-send-email-andriy.shevchenko@linux.intel.com>
	(Andy Shevchenko's message of "Thu, 26 Nov 2015 20:22:50 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

>>>>> "Andy" == Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

Andy> Even for signed types we have to check for bigger positive value
Andy> first.  Otherwise it will be never happened.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
