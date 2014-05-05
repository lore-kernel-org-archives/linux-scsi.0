From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] qla2xxx: fix incorrect debug printk
Date: Mon, 5 May 2014 12:45:06 +0300
Message-ID: <20140505094506.GM4963@mwanda>
References: <20140503202135.GD32753@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30863 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbaEEJp3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 05:45:29 -0400
Content-Disposition: inline
In-Reply-To: <20140503202135.GD32753@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Sat, May 03, 2014 at 11:21:35PM +0300, Dan Carpenter wrote:
> There are missing curly braces here so it prints that the recovery
> failed even when it succeeded.
> 

That's strange.  This patch got corrupted somehow.  I will resend.

regards,
dan carpenter


