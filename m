From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [git patches] libata updates
Date: Thu, 26 Jul 2012 09:44:24 +0200
Message-ID: <20120726074424.GB8421@gmail.com>
References: <20120725203551.GA19762@havoc.gtf.org>
 <20120725204350.GA20530@havoc.gtf.org>
 <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com>
 <50107297.305@pobox.com>
 <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
 <50107A0D.3060003@pobox.com>
 <CA+55aFwi7wS3SFZA-45d+KwKi+hqn1GXqRExYmOw6gnSipv5Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwi7wS3SFZA-45d+KwKi+hqn1GXqRExYmOw6gnSipv5Rg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I couldn't find an example of that in a quick look, it's 
> fairly uncommon to have non-conflicting merges that had 
> semantic - but not contextual - conflicts. [...]

This:

  git log --grep='Semantic merge\|Semantic conflict'

gives over a dozen examples of such semantic merges I've done in 
the past 4 years. I fully agree that they are best done in the 
merge commit - in hindsight perhaps with a tad more explanation 
than I did.

Thanks,

	Ingo
