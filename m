From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] cxlflash: Enable device id for future IBM CXL adapter
Date: Mon, 14 Dec 2015 11:18:39 -0600
Message-ID: <566EF9EF.8020800@linux.vnet.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1449788087-23282-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <566E3BEE.9070307@au1.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:44456 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbbLNRSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 12:18:37 -0500
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Mon, 14 Dec 2015 10:18:34 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 3094D19D8040
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 10:06:35 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBEHIUuj29687848
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 10:18:30 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBEHITbH014545
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 10:18:30 -0700
In-Reply-To: <566E3BEE.9070307@au1.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>

On 12/13/2015 9:47 PM, Andrew Donnellan wrote:
> On 11/12/15 09:54, Uma Krishnan wrote:
>> From: Manoj Kumar <manoj@linux.vnet.ibm.com>
>>
>> This drop enables a future card with a device id
>> of 0x0600 to be recognized by the cxlflash driver.
>> No card specific programming has been added. These
>> card specific changes will be staged in later.
>>
>> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>
> Without the card-specific code, how does the driver behave if the new
> card is plugged in?

Andrew:

As per the design, the Accelerator Function Unit (AFU)
for this new IBM CXL Flash Adapater retains the same host
interface as the previous generation. For the early prototypes
of the new card, the driver with this change behaves exactly as
the driver prior to this behaved with the earlier generation
card. i.e. No card specific changes are required. However, I
left the staging comment in there, in case later versions of the
card deviate from the prototype.

- Manoj

