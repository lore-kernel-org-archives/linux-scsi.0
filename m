From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [PATCH 0/2] Fix the qla2xxx loopback selftests
Date: Mon, 22 Oct 2012 11:06:56 -0500
Message-ID: <CCAB6B63.F32A%saurav.kashyap@qlogic.com>
References: <CAL1RGDXtxmRS=D4vOW5rPEkCcjDxtP8B7EpU1Si1uejMLca2aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:31660 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755588Ab2JVQHg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Oct 2012 12:07:36 -0400
In-Reply-To: <CAL1RGDXtxmRS=D4vOW5rPEkCcjDxtP8B7EpU1Si1uejMLca2aA@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>, Chad Dupuis <chad.dupuis@qlogic.com>
Cc: "steve@purestorage.com" <steve@purestorage.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>




>On Tue, Aug 14, 2012 at 2:15 PM, Chad Dupuis <chad.dupuis@qlogic.com>
>wrote:
>>
>>
>> On Tue, 14 Aug 2012, steve@purestorage.com wrote:
>>
>>> From: Steve Hodgson <steve@purestorage.com>
>>>
>>> A few months ago our 2.6.39 based kernel started crashing almost 100%
>>> of the time when running the selftests, after seeminly unrelated kernel
>>> changes. In the end it was traced down to this use after free.
>>>
>>> Whilst here fix an error path memory leak.
>>>
>>> Thanks,
>>>
>>> Steve
>>>
>>> Steve Hodgson (2):
>>>  qla2xxx: Fix use after free in qla2x000_process_loopback.
>>>  qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()
>>>
>>> drivers/scsi/qla2xxx/qla_bsg.c |   17 +++++++++--------
>>> 1 file changed, 9 insertions(+), 8 deletions(-)
>>>
>>>
>>
>> Hi Steve, thanks for the patches. We'll look into them and let you know
>>if
>> there is anything extra needed.
>
>Looking at the 3.7-rc code, it looks like the use-after-free is still
>there.
>Any plans on merging these patches?

Hi Roland,
The above changes are applicable to other bsg calls also, the changes are
under test and will be submitted in the next submission.

Thanks,
~Saurav


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

