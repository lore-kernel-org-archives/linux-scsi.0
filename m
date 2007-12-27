From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
Date: Thu, 27 Dec 2007 11:15:37 +0530
Message-ID: <47733C01.1080002@linux.vnet.ibm.com>
References: <20071224044850.GA11449@linux.vnet.ibm.com> <20071227121108L.fujita.tomonori@lab.ntt.co.jp> <47732C41.7000003@linux.vnet.ibm.com> <20071227134335O.fujita.tomonori@lab.ntt.co.jp>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37213 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbXL0Fpy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Dec 2007 00:45:54 -0500
In-Reply-To: <20071227134335O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Thu, 27 Dec 2007 10:08:25 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Mon, 24 Dec 2007 10:18:50 +0530
>>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>
>> [snip]
>>
>>> I might break the IOMMU code. Can you reproduce it easily? If so,
>>> reverting my IOMMU patches (I've attached a patch to revert them) fix
>>> the problem?
>> [snip]
>>
>>
>> Yes, this patch fixes the problem for me.
> 
> Thanks, so you can reproduce it easily, right?
> 

Yes, quite easily

> The problem is that I don't want to revert these changes. I'll see
> how these changes cause the problem shortly.

I'll try and find some bandwidth to review/test the patches and help you
figure out the right solution.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
