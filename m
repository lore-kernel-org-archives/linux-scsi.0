From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] libata updates
Date: Wed, 25 Jul 2012 16:30:27 -0700
Message-ID: <CA+55aFwi7wS3SFZA-45d+KwKi+hqn1GXqRExYmOw6gnSipv5Rg@mail.gmail.com>
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org>
 <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com>
 <50107297.305@pobox.com> <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
 <50107A0D.3060003@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <50107A0D.3060003@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 25, 2012 at 3:58 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
>
> What is the right course in when a post-merge change is needed?

Just describe the issue and the required change. Than I can just do it
as part of the merge, and now the whole series is bisectable,
including the merge itself.

Here's a (fairly bad) example:

  http://www.spinics.net/lists/netdev/msg192349.html

and the reason I call that a bad example is not because that's a bad
pull request, but simply that those are all real data conflicts, not
the more subtle kind of "it merges fine, but because new code
introduced uses an interface that changed, you need to do xyz".

I couldn't find an example of that in a quick look, it's fairly
uncommon to have non-conflicting merges that had semantic - but not
contextual - conflicts. (Although it does happen, and sometimes it's
actually not the developer, but Stephen Rothwell who notices it in
-next and lets me know before the merge).

                  Linus
