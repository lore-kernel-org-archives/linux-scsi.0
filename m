From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 1/2] alua: clarify messages when blk_execute_rq fails
Date: Fri, 02 Sep 2011 16:21:15 -0400
Message-ID: <4E613ABB.7020404@redhat.com>
References: <1313182877-31377-1-git-send-email-revers@redhat.com>	 <4E5D4318.6010809@redhat.com> <1314740248.7613.1.camel@dabdike.conference.net> <4E5D8A8F.6000104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab1IBUVZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Sep 2011 16:21:25 -0400
In-Reply-To: <4E5D8A8F.6000104@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

  On 08/30/2011 09:12 PM, Rob Evers wrote:
>  On 08/30/2011 05:37 PM, James Bottomley wrote:
>> On Tue, 2011-08-30 at 16:07 -0400, Rob Evers wrote:
>>> On 08/12/2011 05:01 PM, Rob Evers wrote:
>>>> replace numeric messages with string error messages when 
>>>> blk_execute_rq
>>>> fails.  Also add printing of sense info.
>>>>
>>>> Mike Christie suggested adding printing of sense info here
>>>>
>>>> Signed-off-by: Rob Evers<revers@redhat.com>
>>>>
>>> Hi James,
>>>
>>> Do you have any feedback on these patches?
>>>
>>> (I already noticed the 2nd patch is a reply to the first)
>>>
>>> I didn't see them in the last update of scsi-misc.
>> I don't really see any point in removing messages.
>
> "Unhandled error/sense code" can be interpreted as something going
> wrong when nothing actually went wrong.
>
> For lack of ideas that were accurate, yet not alarming, removing the 
> message
> altogether seemed like the right option.

Hi James,

Just a bit more info on these patches.

We are getting user reports that messages addressed
are causing confusion during fabric faults.

"Unhandled error code"

gets reported with no functional problems being reported.

and...

alua: rtpg failed with 10000
alua: rtpg failed with 800000

Which are cryptic.  I tried to clarify these.  Perhaps
Hannes will consider these.

I tried to address all the instances consistently even
though some are not actually being reported.

Apologies for not explaining the user reports at first.

Rob

