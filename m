From: Lee Duncan <lduncan@suse.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] LIO Target Synchronization with
 sysfs [resend]
Date: Mon, 29 Feb 2016 13:02:41 -0800
Message-ID: <56D4B1F1.6040600@suse.com>
References: <56D1CC7C.7050609@suse.com>
 <1456610092.1750.34.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbcB2VHt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 16:07:49 -0500
In-Reply-To: <1456610092.1750.34.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

On 02/27/2016 01:54 PM, Nicholas A. Bellinger wrote:
> On Sat, 2016-02-27 at 08:19 -0800, Lee Duncan wrote:
>> [Apologies for the resend.]
>>
>> I would like to attend LSF/MM this year. I would like to discuss
>> problems I've had dealing with LIO targets and their inherent
>> asynchronicity in sysfs. I believe that with judicious use of kernel
>> events we can help user space handle target changes more cleanly.
>>
> 
> I assume you mean configfs, and not sysfs.  ;)

Apologies. Yes.

> 
>> As for other topics:
>>
>> As one of the maintainers of LIO at SUSE, I'd dearly love to see our
>> iSCSI targets merged.
>>
> 
> You're talking about Mike's (CC'ed) original target_core_rbd.c driver,
> right..?
> 
> He's been working on porting the PR related changes to a generic
> interface that can be consumed by multiple backend using
> target_core_iblock.c.
> 

Actually, no. I'm aware of that work because one of the groups I'm in is
working in that area. And that is of interest to me to.

But I meant the scst/lio merge, one of the proposed LSF/MM topics.
-- 
Lee Duncan
