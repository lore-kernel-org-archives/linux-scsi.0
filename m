From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCHv2] iscsi_ibft: Add prefix-len attr and display netmask
Date: Mon, 29 Feb 2016 13:49:19 -0800
Message-ID: <56D4BCDF.7000001@suse.com>
References: <cover.1456423714.git.lduncan@suse.com>
 <21ae62f67edf39ab09f6c5aa842b89fd7d6e1dc6.1456423714.git.lduncan@suse.com>
 <56D491BE.5010705@cs.wisc.edu>
 <CACJDEmr6FRHGNGtSRFt=v-ufS0NEs6M_qs-bmssytDsH+-fESA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbcB2Vwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 16:52:49 -0500
In-Reply-To: <CACJDEmr6FRHGNGtSRFt=v-ufS0NEs6M_qs-bmssytDsH+-fESA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, hare@suse.de

On 02/29/2016 01:04 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Feb 29, 2016 at 1:45 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
>> On 02/25/2016 12:15 PM, Lee Duncan wrote:
>>> From: Hannes Reinecke <hare@suse.de>
>>>
>>> The iBFT table only specifies a prefix length, not a netmask.
>>> And the netmask is pretty much pointless for IPv6.
>>> So introduce a new attribute 'prefix-len' and display the
>>> netmask attribute only for IPv4 addresses.
>>
>> The code looks ok to me, but I think this ipv4 comment was left over
>> from the last posting since it conflicts with the comment below about
>> always displaying it. Maybe it can just be edited when the patch is
>> merged to avoid having to resend again. If so,
>>
>> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
>>
> 
> Cool. Let me roll it up and send the git pull to Linus.

I actually just resent it, but the only change was to truncate the last
line of first paragraph of the comment to:

    So introduce a new attribute 'prefix-len'.


> 
> This does not seem be super-urgent so it can wait for the upcoming merge window?
> 
>>
>>>
>>> Some older user-space code might rely on the netmask attribute
>>> being present, so we should always display it.
>>>
>>> Changes from v1:
>>>  - Combined two patches into one
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> Signed-off-by: Lee Duncan <lduncan@suse.com>
> 

-- 
Lee Duncan
SUSE Labs
