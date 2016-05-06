From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] cxlflash: Fix to resolve dead-lock during EEH recovery
Date: Thu, 05 May 2016 21:03:08 -0400
Message-ID: <yq11t5gxak3.fsf@sermon.lab.mkp.net>
References: <1462292801-33954-1-git-send-email-ukrishn@linux.vnet.ibm.com>
	<1462292854-34014-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47454 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbcEFBDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2016 21:03:30 -0400
In-Reply-To: <1462292854-34014-1-git-send-email-ukrishn@linux.vnet.ibm.com>
	(Uma Krishnan's message of "Tue, 3 May 2016 11:27:34 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

>>>>> "Uma" == Uma Krishnan <ukrishn@linux.vnet.ibm.com> writes:

Uma> When a cxlflash adapter goes into EEH recovery and multiple
Uma> processes (each having established its own context) are active, the
Uma> EEH recovery can hang if the processes attempt to recover in
Uma> parallel. The symptom logged after a couple of minutes is:

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
