From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] Miscellaneous patches to support cxlflash in PowerVM
Date: Tue, 08 Mar 2016 21:21:08 -0500
Message-ID: <yq1bn6owfvv.fsf@sermon.lab.mkp.net>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35403 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbcCICVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2016 21:21:31 -0500
In-Reply-To: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
	(Uma Krishnan's message of "Fri, 4 Mar 2016 15:53:44 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

>>>>> "Uma" == Uma Krishnan <ukrishn@linux.vnet.ibm.com> writes:

Uma> The first 5 patches of this series contain fixes to support the
Uma> cxlflash driver in a PowerVM guest. For the cxlflash driver to be
Uma> functional in a PowerVM guest, a corresponding set of cxl patches
Uma> (currently being upstreamed) is required. Note that this cxlflash
Uma> patch series does not have any build dependencies on the new cxl
Uma> code.

Uma> The sixth patch in the series is a fix to dynamically swap between
Uma> the AFU's internal LUN and an actual LUN detected on the fabric.

Uma> The last patch in the series is a performance enhancement to
Uma> improve throughput with cxlflash driver.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
