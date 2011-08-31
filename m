From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH 1/2] alua: clarify messages when blk_execute_rq fails
Date: Tue, 30 Aug 2011 21:12:47 -0400
Message-ID: <4E5D8A8F.6000104@redhat.com>
References: <1313182877-31377-1-git-send-email-revers@redhat.com>	 <4E5D4318.6010809@redhat.com> <1314740248.7613.1.camel@dabdike.conference.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab1HaBMs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 21:12:48 -0400
In-Reply-To: <1314740248.7613.1.camel@dabdike.conference.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

  On 08/30/2011 05:37 PM, James Bottomley wrote:
> On Tue, 2011-08-30 at 16:07 -0400, Rob Evers wrote:
>> On 08/12/2011 05:01 PM, Rob Evers wrote:
>>> replace numeric messages with string error messages when blk_execute_rq
>>> fails.  Also add printing of sense info.
>>>
>>> Mike Christie suggested adding printing of sense info here
>>>
>>> Signed-off-by: Rob Evers<revers@redhat.com>
>>>
>> Hi James,
>>
>> Do you have any feedback on these patches?
>>
>> (I already noticed the 2nd patch is a reply to the first)
>>
>> I didn't see them in the last update of scsi-misc.
> I don't really see any point in removing messages.

"Unhandled error/sense code" can be interpreted as something going
wrong when nothing actually went wrong.

For lack of ideas that were accurate, yet not alarming, removing the 
message
altogether seemed like the right option.

