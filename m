From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen-scsiback: use DRV_PFX in the pr macros
Date: Tue, 3 Mar 2015 10:09:09 +0000
Message-ID: <54F58845.1040001@citrix.com>
References: <1425371832-55072-1-git-send-email-boby.chen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.citrix.com ([66.165.176.63]:54368 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbbCCKJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2015 05:09:15 -0500
In-Reply-To: <1425371832-55072-1-git-send-email-boby.chen@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tao Chen <boby.chen@huawei.com>, jgross@suse.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, rudy.zhangmin@huawei.com, wu.wubin@huawei.com

On 03/03/15 08:37, Tao Chen wrote:
> Replace the string of {xen-pvscsi:} in the pr sentences with DRV_PFX,
> it makes the code easier to read.

You need to #define pr_fmt(fmt) to add a prefix like this.

>  	struct ids_tuple v;		/* translate from */
> -	struct scsiback_tpg *tpg;	/* translate to   */
> +	struct scsiback_tpg *tpg;	/* translate to */

Please don't make unrelated whitespace changes.

David
