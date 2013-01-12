From: wenxiong@linux.vnet.ibm.com
Subject: Re: linux-next: build failure after merge of the scsi tree
Date: Fri, 11 Jan 2013 21:23:08 -0500
Message-ID: <20130111212308.Horde.EQ70Mpir309Q8MkMJXuEiEA@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Quoting James Bottomley <James.Bottomley@hansenpartnership.com>:

> On Fri, 2013-01-11 at 11:35 -0600, Brian King wrote:
>> On 01/11/2013 10:05 AM, Greg KH wrote:
>> > On Fri, Jan 11, 2013 at 03:37:17PM +0000, James Bottomley wrote:
>> >> On Fri, 2013-01-11 at 09:27 -0600, Brian King wrote:
>> >>> It looks like this was a due to the fact that the new patches
>> >>> added __devinit tags in the same merge window the __devinit tag
>> >>> itself was getting removed.
>> >>
>> >> Not exactly.  The patch which makes them nops went into 3.8.  Now
>> >> there's a patch queued in, Gregs tree I presume, to remove them all and
>> >> the #defines which causes the compile failure.
>> >>
>> >>> As to the sparse warnings, this patch fixed the ones that
>> >>> were actual bugs in the new code, although we could have
>> >>> made that more clear in the patch description.
>> >>>
>> >>> http://marc.info/?l=linux-scsi&m=135716576204083&w=2
>> >>
>> >> Ah, thanks ... I've been on holiday for a while, so I did miss that.
>> >>
>> >>> There is one outstanding issue I am aware of which was an
>> >>> array bounds compiler warning which looks to be a misdetection
>> >>> by the compiler. Wendy and I discussed adding a BUG_ON
>> >>> to stop the compiler from complaining.
>> >>>
>> >>> Wendy - lets queue these two changes up ASAP. They should both
>> >>> be very simple changes.
>> >>
>> >> If it's a simple gcc bug, just ignore it.
>> >>
>> >> I do need you to redo the patches to remove the __dev annotations,
>> >> though.  We can't risk introducing a bisect killing compile breakage if
>> >> Greg's tree merges before mine in the next merge window.
>> >
>> > This change should be pushed to Linus in time for 3.8-final, so there
>> > should not be any bisect issues.
>>
>> We can do this either way.
>>
>> James - what is your preference? Drop everything and do a resend of the
>> entire series or delta patches on top of what is currently in your tree?
>
> Drop everything and resend still, I think.  There's still a rebase
> problem, because the merge failure will happen if I rebase the misc tree
> to beyond Greg's merge point and I'd rather not have to worry about it.
>
> Thanks,
>
> James

Hi James, I just re-sent all patches which are against
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git.
This kernel already have Greg's "Drivers: scsi: remove _dev*  
attributes" patch.

Let me know if you have any questions for these patches.

Thanks for for your help!
Wendy
