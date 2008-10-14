From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 0/2] FC pass through support via bsg interface - revised
Date: Tue, 14 Oct 2008 04:26:04 -0700
Message-ID: <8820625E-A0C1-4EBC-AAF4-7F763BEB399E@qlogic.com>
References: <B5FBFF85-C7C0-44F7-905F-9029C54F4F56@qlogic.com> <20081014112308T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:16272 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbYJNL0I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 07:26:08 -0400
In-Reply-To: <20081014112308T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, robert.w.love@intel.com


On Oct 13, 2008, at 7:23 PM, FUJITA Tomonori wrote:

> On Mon, 13 Oct 2008 10:53:18 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>
>> Base on feedback as below, here is revised one for pass through  
>> support.
>> http://marc.info/?l=linux-scsi&m=122123825918741&w=2
>> http://marc.info/?t=121908849700001&r=1&w=2
>>
>> Also, the attached file is updated sample application along with GPL
>> license.
>
> Can you summarize what changes you made since the previous version
> (based on the feedback)?
Here is a list of changes since last submission,
- in the fc_service structure,
	= payload/response has defined
	= srv_request/srv_reply has defined
- asynchronous nature of he service handling - in the LLD at this time  
- has added
- multiple SG support added
- timeout value has included part of the service request
- and some cleanups have been done

There are many other things to be done, among them, I'm looking at  
following as follow up,
- abort mechanism is not in place, not sure what is right approach,  
please comment on this
- timeout feature in fc transport layer

Thanks,
Seokmann

