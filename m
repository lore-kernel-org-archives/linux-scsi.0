From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Tue, 26 Apr 2016 01:35:16 -0700
Message-ID: <20160426083516.GC364@infradead.org>
References: <20160419085221.GA29087@gmail.com>
 <yq1lh41gki4.fsf@sermon.lab.mkp.net>
 <1461641851.2392.32.camel@HansenPartnership.com>
 <5249561.9VpAPLD61M@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5249561.9VpAPLD61M@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, jamborm@gcc.gnu.org, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 26, 2016 at 09:22:46AM +0200, Arnd Bergmann wrote:
> > Agree, plus, as I've said before, we have 3-4 weeks before we go final,
> > so we still have some time before a decision has to be made.  It looks
> > like the gcc people already have a patch for the compiler, so the
> > distributions could just push that out through channels.
> 
> I don't think we can realistically blacklist gcc-4.9.{0,1,2,3},
> gcc-5.{0,1,2,3}.* and gcc-6.0 and require everyone to upgrade to compilers
> that have not been released yet in order to build a linux-4.6 kernel.

Agreed.  What about just removing the wrappers?  They seem fairly
pointless to start with.
