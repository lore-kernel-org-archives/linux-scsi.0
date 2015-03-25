From: Mark Hounschell <markh@compro.net>
Subject: Re: BUG: SCSI aic7xxx driver and AMD IOMMU
Date: Wed, 25 Mar 2015 12:36:34 -0400
Message-ID: <5512E412.9040807@compro.net>
References: <54E1FFFA.1060403@compro.net> <54F60D33.8090401@compro.net> <20150323150304.GQ4441@8bytes.org> <5511513D.6090106@compro.net> <20150325135937.GR4441@8bytes.org> <20150325151332.GT4441@8bytes.org>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp78.ord1c.emailsrvr.com ([108.166.43.78]:38000 "EHLO
	smtp78.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbbCYQgg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2015 12:36:36 -0400
In-Reply-To: <20150325151332.GT4441@8bytes.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org >> SCSI development list" <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

On 03/25/2015 11:13 AM, Joerg Roedel wrote:
> Hi again,
>
> On Wed, Mar 25, 2015 at 02:59:37PM +0100, Joerg Roedel wrote:
>> On Tue, Mar 24, 2015 at 07:57:49AM -0400, Mark Hounschell wrote:
>>> I'll be happy to test it.
>>
>> Okay, here you go:
>>
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux.git amd-iommu
>
> I just added more patches to implement the use of the contiguous memory
> allocator for the dma_alloc_coherent path. Since you asked for it, can
> you test this as well?
>
>

Sure. No problem. If I update my tree from the above, will I get it.

BTW, so far the first 2 patches are working well. I was going to wait 
until the end of the day to report but so far I have been unable to 
produce the problems I was seeing. And I am in the middle of some driver 
work so lots of unloading/loading going on.

Regards
Mark

