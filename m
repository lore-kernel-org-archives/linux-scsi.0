From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] [SCSI] eata_pio: missing break statement
Date: Tue, 10 May 2016 22:01:26 -0400
Message-ID: <yq1twi5nyix.fsf@sermon.lab.mkp.net>
References: <20160504061341.GA22064@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34466 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcEKCBl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 22:01:41 -0400
In-Reply-To: <20160504061341.GA22064@mwanda> (Dan Carpenter's message of "Wed,
	4 May 2016 09:13:41 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> This missing break statement bug predates git.  It's a very minor
Dan> thing, it means that we print a '?' instead of a 'z' in dmesg.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
