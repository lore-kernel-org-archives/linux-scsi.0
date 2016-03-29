From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/2] Fix regression and performance issue in cxlflash
Date: Mon, 28 Mar 2016 20:55:35 -0400
Message-ID: <yq1mvpit854.fsf@sermon.lab.mkp.net>
References: <1458933920-28788-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31066 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbcC2Az6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2016 20:55:58 -0400
In-Reply-To: <1458933920-28788-1-git-send-email-ukrishn@linux.vnet.ibm.com>
	(Uma Krishnan's message of "Fri, 25 Mar 2016 14:25:20 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

>>>>> "Uma" == Uma Krishnan <ukrishn@linux.vnet.ibm.com> writes:

Hey Uma,

Uma> This series has a couple of patches in cxlflash.  The first patch
Uma> is critical as it fixes a regression that was introduced by Commit
Uma> 6ded8b3cbd9a ("cxlflash: Unmap problem state area before detaching
Uma> master context") as part of the first SCSI push for v4.6.

Uma> The second patch addresses a performance issue.

main.c |  138 ++++++++++++++++++++++++++++++++++++++++++++---------------------
main.h |    5 --
2 files changed, 97 insertions(+), 46 deletions(-)

This starts to push the limits of what constitutes "a bug fix".

I let it slide because you submitted inside the merge window. Applied to
4.6/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
