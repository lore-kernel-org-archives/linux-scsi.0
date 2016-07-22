From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] cxlflash: Regression patch and updating Maintainers list
Date: Fri, 22 Jul 2016 16:21:10 -0400
Message-ID: <yq1bn1pbf0p.fsf@sermon.lab.mkp.net>
References: <1469133772-14953-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27253 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbcGVUVV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 16:21:21 -0400
In-Reply-To: <1469133772-14953-1-git-send-email-ukrishn@linux.vnet.ibm.com>
	(Uma Krishnan's message of "Thu, 21 Jul 2016 15:42:52 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

>>>>> "Uma" == Uma Krishnan <ukrishn@linux.vnet.ibm.com> writes:

Uma> First patch in this set fixes a regression that was casued by the
Uma> Commit 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL
Uma> Flash cards"), which is currently staged for 4.8 in next/master.
Uma> Second patch updates the Maintainers list for cxlflash driver.

Uma> This series is intended for 4.8 and is bisectable. These patches
Uma> are cut against next/master that contains the original commit.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
