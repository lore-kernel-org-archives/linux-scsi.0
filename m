From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.15-rc3
Date: Tue, 12 Dec 2017 09:30:27 -0800
Message-ID: <1513099827.3110.25.camel@HansenPartnership.com>
References: <1513095686.3110.9.camel@HansenPartnership.com>
         <CA+55aFy8hepLBW9Zvfk4MgibG4eHF5qkmon+2Zs6KWLQfFH-fg@mail.gmail.com>
         <yq1indbq2sb.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1indbq2sb.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-12-12 at 12:22 -0500, Martin K. Petersen wrote:
> Linus,
> 
> > 
> > This is utter shite, and doesn't even compile cleanly.
> > 
> > Sure, it's "just" a warning, and the code works. But no, I'm not
> > pulling crap like this. If you save a pointer in an integer
> > "hostdata[0]" field, then you damn well do the proper casts or
> > helper
> > functions or something, you don't just ignore the compiler when it
> > very reasonably warns about it.
> > 
> > What the hell is going on? Nobody compiled this stuff at all? Or
> > nobody cares about new build warnings?
> 
> Arnd and Johannes fixed this up right away:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?
> h=fixes&id=45349821ab3a8d378b8f37e52c6fe1aa1b870c47

Yes, I have that in the current testing batch, how about I push the
combined thing on wednesday.

James
