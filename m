From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xxdrivers
Date: Mon, 21 Jun 2004 12:09:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D70837.8070303@adaptec.com>
References: <20040621161441.20dfcee6.ak@suse.de> <40D6FEFC.9050005@adaptec.com> <1087832273.2702.14.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:3000 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266295AbUFUQJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 12:09:31 -0400
In-Reply-To: <1087832273.2702.14.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 2004-06-21 at 17:30, Luben Tuikov wrote:
> 
>>Thank you Andi for the patches. aic7xxx drivers are due for update
>>to use the new timeout infrastructure. I'll incorporate them in,
>>and do some testing.
> 
> 
> cool.
> Would you please consider the update to be done in small incremental
> changes/steps ? Eg each separate change/bugfix a separate patch ?
> Would make life a lot easier for me (distro kernel guy) and for James to
> be able to diagnose regressions a lot better by binary searching
> changesets etc etc.

Yep, no problem.

Current kernel version of, say, aic79xxx is 1.3.11, and I have
2.0.12, they are 226 patches away. Each patch is a submission
into perforce.  I can extract each and every one of those 226
and can post them somewhere on a website (hosting anyone? ;-) ),
so that anyone can review them.

I can also provide a single patch from 1.3.11 to 2.0.11 so
that a "to<-->from" picture can be seen as some patches in
between may "cancel" each other out.

And I'll also provide a bk-send and a tar.gz of the whole thing
as it looks in my tree.

Let me know if anything else is needed.

Thanks,
-- 
Luben


