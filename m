From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH] 2.4.25-rc2 more devices to  scsi_scan.c's blacklist
Date: Wed, 18 Feb 2004 14:42:55 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040218144255.A13153@lists.us.dell.com>
References: <402BB921.2000808@wanadoo.es> <402C0900.6080104@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:48801 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S267375AbUBRUnJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 15:43:09 -0500
Content-Disposition: inline
In-Reply-To: <402C0900.6080104@wanadoo.es>; from xose@wanadoo.es on Fri, Feb 13, 2004 at 12:15:12AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 13, 2004 at 12:15:12AM +0100, Xose Vazquez Perez wrote:
> hi,
> 
> new and better patch with _additions_ from linux-kernel ml, SLES y RHEL.
> 
> There are some _modifications_ from SuSE, but they were not added.
> Does anybody know what are right ? kernel.org vs. SuSE(and one of RH)

> --- linux/drivers/scsi/scsi_scan.c	2004-01-05 15:39:12.000000000 +0100
> +++ n/drivers/scsi/scsi_scan.c	2004-02-12 23:56:32.000000000 +0100
> @@ -206,6 +208,22 @@
(snip)
> +	{"DELL", "PV-136T-FC", "*", BLIST_FORCELUN},

I can ack this one.  It's got a tape autoloader at LUN 1, hence the
FORCELUN necessary to autodetect it.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
