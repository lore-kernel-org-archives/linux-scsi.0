From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] Add and use media change notification
Date: Mon, 05 Nov 2007 18:17:09 -0500
Message-ID: <472FA475.5030106@garzik.org>
References: <20071104150711.GA29087@havoc.gtf.org> <alpine.LFD.0.999.0711041755120.15101@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0711041755120.15101@woody.linux-foundation.org>
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 4 Nov 2007, Jeff Garzik wrote:
>> The end to CD-ROM polling...  newer SATA ATAPI hardware will emit
>> 'asynchronous notification' events when media is changed.  This adds
>> support.
> 
> I *really* didn't want to pull this.
> 
> Not only is it after the -rc1 period, but I also think you pushed this ina 
> really offensive manner, and I don't like how you and James have made this 
> whole thing personal. You guys need to sort it out, and there is no way 
> you can blame James for all your troubles, since I've heard the same kind 
> of complaints about every single maintainer out there (including you) 
> about some driver or other infrastructure issue.
> 
> So I'm unhappy about pulling this.
> 
> That said, I did finally decide to just pull it. Partly because the 
> concept apparently has been in -mm for a while anyway (even if the final 
> patch has not - but the patch itself isn't that large, I'd worry more 
> about thngs like certain hardware simply not doing things right), but 
> mostly because I hate it when others hold up driver features, and I 
> decided that in this case this really is something that is better done 
> earlier rather than later, to get exposure as soon as possible.
> 
> But I really think you need to lay off James, and help him rather than 
> make every single complaint a big flame-war!
> 
> Please, Jeff?

Fair enough...

	Jeff



