From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v2 6/6] cxlflash: Enable device id for future IBM CXL
 adapter
Date: Tue, 15 Dec 2015 14:11:00 +1100
Message-ID: <566F84C4.1000203@au1.ibm.com>
References: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1450127263-48261-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44957 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbLODMH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 22:12:07 -0500
Received: from localhost
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Tue, 15 Dec 2015 13:12:04 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id D7FCF2CE8059
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 14:11:58 +1100 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBF3Bgg011010094
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 14:11:50 +1100
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBF3BPUH024625
	for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2015 14:11:26 +1100
In-Reply-To: <1450127263-48261-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: Daniel Axtens <dja@ozlabs.au.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>

On 15/12/15 08:07, Uma Krishnan wrote:
> From: Manoj Kumar <manoj@linux.vnet.ibm.com>
>
> This drop enables a future card with a device id
> of 0x0600 to be recognized by the cxlflash driver.

If you do a V3 - this could be better worded in the imperative mood as: 
"Add a new device ID (0x0600) for a future IBM CXL Flash Adapter card."

>
> As per the design, the Accelerator Function Unit (AFU)
> for this new IBM CXL Flash Adapter retains the same
> host interface as the previous generation. For the early
> prototypes of the new card, the driver with this change
> behaves exactly as the driver prior to this behaved with
> the earlier generation card. Therefore, no card specific
> programming has been added. These card specific changes
> can be staged in later if needed.
>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Assuming that the final card won't break in a particularly nasty way in 
the absence of later code changes, all looks good.

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan@au1.ibm.com  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

