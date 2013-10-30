From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] aacraid: prevent ZERO_SIZE_PTR dereference
Date: Wed, 30 Oct 2013 10:47:56 +0300
Message-ID: <20131030074756.GH20521@mwanda>
References: <20131025144452.GA28451@ngolde.de>
 <20131029191007.GD21820@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25223 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3J3Hsn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2013 03:48:43 -0400
Content-Disposition: inline
In-Reply-To: <20131029191007.GD21820@longonot.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, security@kernel.org

On Tue, Oct 29, 2013 at 10:10:07PM +0300, Dan Carpenter wrote:

> Due to a missing capable() check in the compat ioctls then this error
> can be triggered without CAP_SYS_RAWIO.  I have fixed that in a separate
> patch.

Actually, CAP_SYS_RAWIO is checked at the start of the function.

However my other patch which adds the check in the compat ioctl should
probably still be applied so it matches the regular ioctl.

regards,
dan carpenter

