From: Mark Hounschell <markh@compro.net>
Subject: Re: [PATCH] sd: Disable support for 256 byte/sector disks
Date: Wed, 13 May 2015 10:29:21 -0400
Message-ID: <55535FC1.90304@compro.net>
References: <1431506949-11398-1-git-send-email-hare@suse.de>	 <1431525655.2363.13.camel@HansenPartnership.com> <55535B30.8080602@suse.de> <1431526662.2363.22.camel@HansenPartnership.com>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp94.ord1c.emailsrvr.com ([108.166.43.94]:45822 "EHLO
	smtp94.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964925AbbEMO3X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 10:29:23 -0400
In-Reply-To: <1431526662.2363.22.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>
Cc: Mark Hounschell <dmarkh@cfl.rr.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On 05/13/2015 10:17 AM, James Bottomley wrote:
> On Wed, 2015-05-13 at 16:09 +0200, Hannes Reinecke wrote:
>> On 05/13/2015 04:00 PM, James Bottomley wrote:
>>> On Wed, 2015-05-13 at 10:49 +0200, Hannes Reinecke wrote:
>>>> 256 bytes per sector support has been broken since 2.6.X,
>>>> and no-one stepped up to fix this.
>>>> So disable support for it.
>>>
>>> I assume this should have a
>>>
>>> From: Mark Hounschell <dmarkh@cfl.rr.com>
>>>
>>> at the top?
>>>
>>> James
>>>
>> I wasn't sure, as I've pulled the patch off bugzilla.
>> But do whatever you see fit.
>
> It needs authorship (From: field) of whoever wrote it and put it on
> bugzilla in the first place.  According to the entry, it was him:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=16058#c18
>

I am the author of that patch. What would you like me to do? My home 
email address is what I used in bugzilla "dmarkh@cfl.rr.com" years back 
when I originally submitted the bug. I'm sending this email from work.

I am Mark Hounschell and am the author of that patch and you can do with 
it whatever you see fit?

Regards
Mark


