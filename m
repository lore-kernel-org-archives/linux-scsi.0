From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6] cxlflash: Updated date of the driver
Date: Mon, 14 Dec 2015 13:29:55 -0600
Message-ID: <566F18B3.6040907@linux.vnet.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1449788043-23131-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <87d1udkejd.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:57655 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbbLNT3w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 14:29:52 -0500
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Mon, 14 Dec 2015 12:29:51 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 9361B19D8040
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 12:17:52 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBEJTlI230867654
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 12:29:47 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBEJTkXA026805
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 12:29:47 -0700
In-Reply-To: <87d1udkejd.fsf@gamma.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

On 12/10/2015 6:35 PM, Daniel Axtens wrote:
> Hi Uma,
>
> It looks like CXLFLASH_DRIVER_DATE is only used once, on init, and it's
> just printed. Is it necessary? It looks like having it will require
> sending a patch to update it quite often.
>

Hi Daniel,

Valid point. I will pull this out from the code. This should be included
in the second version of the patch series.

Thanks,
Uma Krishnan

