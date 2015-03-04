From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] xen-scsiback: use DRV_PFX in the pr macros and DPRINTK
Date: Wed, 4 Mar 2015 10:34:31 +0000
Message-ID: <54F6DFB7.2080402@citrix.com>
References: <1425493951-41801-1-git-send-email-boby.chen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.citrix.com ([66.165.176.63]:53368 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbbCDKee (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 05:34:34 -0500
In-Reply-To: <1425493951-41801-1-git-send-email-boby.chen@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tao Chen <boby.chen@huawei.com>, jgross@suse.com, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com
Cc: xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wu.wubin@huawei.com, rudy.zhangmin@huawei.com

On 04/03/15 18:32, Tao Chen wrote:
> Defined the string of {xen-pvscsi: } as DRV_PFX, then use it in the pr sentences and DPRINTK.
> Also fixed up some comments just as eliminate redundant white spaces and format the code.
> These will make the code easier to read.

I have already said you needed to use:

#define pr_fmt(fmt)

to do this.

David
