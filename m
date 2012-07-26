From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [git patches] libata updates
Date: Wed, 25 Jul 2012 22:10:06 -0400
Message-ID: <5010A6FE.7000604@pobox.com>
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org> <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com> <50107297.305@pobox.com> <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com> <50107A0D.3060003@pobox.com> <CA+55aFwi7wS3SFZA-45d+KwKi+hqn1GXqRExYmOw6gnSipv5Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwi7wS3SFZA-45d+KwKi+hqn1GXqRExYmOw6gnSipv5Rg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/25/2012 07:30 PM, Linus Torvalds wrote:
> On Wed, Jul 25, 2012 at 3:58 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
>>
>> What is the right course in when a post-merge change is needed?
>
> Just describe the issue and the required change. Than I can just do it
> as part of the merge, and now the whole series is bisectable,
> including the merge itself.
>
> Here's a (fairly bad) example:
>
>    http://www.spinics.net/lists/netdev/msg192349.html
>
> and the reason I call that a bad example is not because that's a bad
> pull request, but simply that those are all real data conflicts, not
> the more subtle kind of "it merges fine, but because new code
> introduced uses an interface that changed, you need to do xyz".

Thanks, so noted.  I guess if the merge gets more complex than something 
easily described in an email, that implies that maintainers should do 
more cross-coordination and maybe a merge tree.

What's the best way for libata to move forward, now that this hideous 
merge has been pushed out to the Well Known libata branches?  The 
pre-jgarzik-merge commit you would have pulled is 
dc7f71f486f4f5fa96f6dcf86833da020cde8a11 had my pull request been proper.

I can lop off the top 3 commits and force-update the libata-dev.git 
branches, then send a new pull request -- but you have grumbled at that 
sort of behavior in maintainer trees before too...

	Jeff


