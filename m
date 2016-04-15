From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] pm80xx: Remove bogus address masking in pm8001_ioremap()
Date: Thu, 14 Apr 2016 22:38:16 -0400
Message-ID: <yq1vb3jsijr.fsf@sermon.lab.mkp.net>
References: <1460582816-12703-1-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46801 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbcDOCil (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2016 22:38:41 -0400
In-Reply-To: <1460582816-12703-1-git-send-email-ddaney.cavm@gmail.com> (David
	Daney's message of "Wed, 13 Apr 2016 14:26:56 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, pmchba@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>

>>>>> "David" == David Daney <ddaney.cavm@gmail.com> writes:

David> It is unclear what the original intent of the masking was, but it
David> is clearly incorrect to truncate a physical address before
David> calling ioremap().  On systems where there are valid physical
David> address bits above bit-31 (arm64 for example) the result is an
David> eventual OOPs when initializing the driver.

David> Remove the bogus code to fix it.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
