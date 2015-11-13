From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] hpsa: logical vs bitwise AND typo
Date: Fri, 13 Nov 2015 16:50:21 -0500
Message-ID: <yq14mgpzi02.fsf@sermon.lab.mkp.net>
References: <20151112094338.GB28432@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35951 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbbKMVub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2015 16:50:31 -0500
In-Reply-To: <20151112094338.GB28432@mwanda> (Dan Carpenter's message of "Thu,
	12 Nov 2015 12:43:38 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Don Brace <don.brace@pmcs.com>, Scott Teel <scott.teel@pmcs.com>, "James E.J. Bottomley" <JBottomley@odin.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> HPSA_DIAG_OPTS_DISABLE_RLD_CACHING is a mask and bitwise AND was
Dan> intended here instead of logical &&.  This bug is essentially
Dan> harmless, it means that sometimes we don't print a warning message
Dan> which we wanted to print.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
