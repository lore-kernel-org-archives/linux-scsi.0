From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
Date: Mon, 10 Nov 2008 14:52:21 +0200
Message-ID: <49182E85.9010405@panasas.com>
References: <48876009.8010701@panasas.com>	<491073BB.4000900@panasas.com>	<20081104111923.bb19c238.akpm@linux-foundation.org>	<4916FAB3.4010409@panasas.com> <20081110102607.378c3279.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:10087 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754701AbYKJMwN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 07:52:13 -0500
In-Reply-To: <20081110102607.378c3279.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, linux-next@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>, linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Boaz,
> 
> On Sun, 09 Nov 2008 16:58:59 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
>> I have prepared a branch for linux-next based on today's Linus tree
>> It is here:
>>     git://git.open-osd.org/linux-open-osd.git linux-next
>> This is if it's OK with James, as these bits are his responsibility.
>> They need only sit in linux-next for a couple of weeks to get some wider
>> compilation exposure. Other then that they are totally new code and
>> are safe. Eventually they should be included into Linux-next through
>> scsi-misc-2.6.
> 
> I have added that tree to linux-next for today.
> 
> What I say to everyone:  commits in that branch must have been posted
> somewhere appropriate, reviewed, unit tested and destined for the next
> merge window.  Also, note that my (new) practise is to temporarily drop a
> tree if it causes non-trivial conflicts (especially with Linus' tree), so
> don't be too upset if you get a message from me to that effect.
> 

Thank you Stephen, very much

This has proven itself already. I found some warnings on some ARCHs
concerning printk of u64 types. I have made a sweep and fixed all these
places and others.
(same place: git://git.open-osd.org/linux-open-osd.git linux-next)

If you could keep it for the next round it could be grate. So I can make
sure I got rid of all the warnings.

Thanks again
Boaz
