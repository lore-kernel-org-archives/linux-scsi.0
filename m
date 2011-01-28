From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v4 1/3] scsi: Detailed I/O errors
Date: Fri, 28 Jan 2011 09:12:52 +0100
Message-ID: <4D427A84.7090501@fusionio.com>
References: <cover.1295340405.git.hare@suse.de> <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de> <4D357AA3.5070509@interlog.com> <4D358130.6040508@suse.de> <20110127223525.GH14951@redhat.com> <1296168102.3050.83.camel@mulgrave.site> <20110127225431.GI14951@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:47986 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab1A1IMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 03:12:46 -0500
In-Reply-To: <20110127225431.GI14951@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <jbottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "agk@redhat.com" <agk@redhat.com>

On 2011-01-27 23:54, Mike Snitzer wrote:
> On Thu, Jan 27 2011 at  5:41pm -0500,
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
>> On Thu, 2011-01-27 at 17:35 -0500, Mike Snitzer wrote:
>>> On Tue, Jan 18 2011 at  7:01am -0500,
>>> Hannes Reinecke <hare@suse.de> wrote:
>>>
>>>> On 01/18/2011 12:33 PM, Douglas Gilbert wrote:
>>>>
>>>> This patchset is primarily for fixing up multipathing,
>>>> which has the habit of retrying failed I/Os on the
>>>> next path. For some errors this is just pointless
>>>> (eg MEDIUM ERROR), for some errors this is the desired
>>>> behaviour (namely transport errors), and for others
>>>> this is positively damaging (persistent reservation
>>>> failures).
>>>> Just plain EIO simply don't cover the whole range :-)
>>>>
>>>>>
>>>>> BTW might "vulgo" be "ergo" [Latin: therefore]?
>>>>>
>>>> Nope. Correct etymology is from 'sermo vulgaris',
>>>> ie the language of the common people.
>>>> But maybe I should remove it for the next
>>>> round to avoid confusion.
>>>
>>> Is a new round even needed given there haven't been any code issues
>>> raised against v4?
>>>
>>> James, what are your thoughts on this patchset?  Would be great to get
>>> this in scsi-misc for 2.6.39
>>>
>>> Please advise,
>>
>> Well, it covers three subsystems ... I was waiting for Alasdair and Jens
>> to ack ... but I bet they each were waiting for the other two to ack ...
>>
>> So, I'll take it if no objections.
> 
> OK, I just sent a mail to jens and alasdair asking the same ;)

This one will be easier just to take in the SCSI tree, since there's so
little risk for conflict.  You can add my acked-by to the patches.

-- 
Jens Axboe

