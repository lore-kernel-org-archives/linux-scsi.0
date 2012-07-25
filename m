From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [git patches] libata updates
Date: Wed, 25 Jul 2012 18:58:21 -0400
Message-ID: <50107A0D.3060003@pobox.com>
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org> <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com> <50107297.305@pobox.com> <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/25/2012 06:31 PM, Linus Torvalds wrote:
> On Wed, Jul 25, 2012 at 3:26 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
>>
>> Even so, separately, it still needed that post-merge compile fix.
>
> And that's yet another example of how *NOT* to do things.
>
> If the merge has errors like that, then they should be fixed up in the merge.
>
> Please. Don't do this. Let me merge stuff, and you explain in the pull
> request why it gets merge problems. Not this mess.
>
> That merge itself was *trivial*. I do those kinds of fixups in my
> sleep and you don't even need to explain those. The non-trivial part
> you did as a separate commit. But neither of those should have been
> "I'll pre-merge for Linus so that he doesn't see these problems".

What is the right course in when a post-merge change is needed?

	Jeff





