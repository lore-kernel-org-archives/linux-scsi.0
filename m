From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: scsi/arm/fas216.c compile error
Date: Sun, 10 Feb 2008 16:37:39 +0200
Message-ID: <47AF0C33.5020505@panasas.com>
References: <20080209000413.GE6505@cs181133002.pp.htv.fi>	 <47AEF6FD.8080801@panasas.com>	 <20080210135851.GB25703@flint.arm.linux.org.uk> <1202653224.3136.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:16669 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154AbYBJOiD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Feb 2008 09:38:03 -0500
In-Reply-To: <1202653224.3136.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Adrian Bunk <adrian.bunk@movial.fi>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Feb 10 2008 at 16:20 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Sun, 2008-02-10 at 13:58 +0000, Russell King wrote:
>> On Sun, Feb 10, 2008 at 03:07:09PM +0200, Boaz Harrosh wrote:
>>> It's in mainline 84ac86ca8c6787f9efff28bc04b1b65fe0a5c310
>>>   [SCSI] arm: convert to accessors and !use_sg cleanup
>>>
>>> Thanks for checking. This patch was in scsi-pending tree since forever, And we were unable
>>> to get a responsive maintainer to ACK on them. until the breakage cause went into mainline
>>> we finally managed a Tested-by:.
>>>
>>> I guess sometimes people are so busy, you need a bulldozer to shove 20 minutes into they're
>>> schedule.
>> Oh, I was ill for most of December, particularly at the time that you
>> sent the patch, and by the time I recovered, it was buried in my mailbox.
>>
>> Suggest you have some consideration for others who might not be able to
>> do your beg and call at the immediate moment that you want it, and
>> consider that their email management skills may not be as l33t as yours.
> 
> OK, sorry about this, it's a bit of a cockup all around.  The patch that
> fixes this problem is still in SCSI pending largely because it's patch
> description:
> 
>     [SCSI] fas216: Use scsi_eh API for REQUEST_SENSE invocation
> 
> Doesn't lead one to think it might be build critical, so I concentrated
> on getting the other arm patch out.
> 
All the patches I pushed are build critical. The complete
"Use scsi_eh API for REQUEST_SENSE" and the error refactoring patches 
were in support for the scsi_data_buffer effort. Well that was the last 
one so all is well I guess.

(With out these patches, code is still pushing none-use_sg requests,
apart from the members rename of scsi_cmnd)

> Russell, could you give it a quick test, and I'll put it in with a
> tested-by tag?
> 
> Thanks,
> 
> James
> 

Thanks to all
Boaz
