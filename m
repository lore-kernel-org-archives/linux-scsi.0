From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] hpsa: set the enclosure identifier to zero
Date: Mon, 25 Apr 2016 22:02:07 -0400
Message-ID: <yq1eg9ti0v4.fsf@sermon.lab.mkp.net>
References: <20160414093744.GJ16549@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19201 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbcDZCCX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2016 22:02:23 -0400
In-Reply-To: <20160414093744.GJ16549@mwanda> (Dan Carpenter's message of "Thu,
	14 Apr 2016 12:37:44 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, iss_storagedev@hp.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> This has only called from show_sas_rphy_enclosure_identifier().
Dan> The caller expects that we set an identifier, otherwise it uses an
Dan> unintialized variable.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
