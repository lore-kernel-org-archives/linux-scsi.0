From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Tue, 26 Apr 2016 09:22:46 +0200
Message-ID: <5249561.9VpAPLD61M@wuerfel>
References: <20160419085221.GA29087@gmail.com> <yq1lh41gki4.fsf@sermon.lab.mkp.net> <1461641851.2392.32.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461641851.2392.32.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, jamborm@gcc.gnu.org, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com
List-Id: linux-scsi@vger.kernel.org

On Monday 25 April 2016 20:37:31 James Bottomley wrote:
> On Mon, 2016-04-25 at 22:40 -0400, Martin K. Petersen wrote:
> > > > > > > "Josh" == Josh Poimboeuf <jpoimboe@redhat.com> writes:
> > 
> > Josh> Can you merge this patch for 4.6?
> > 
> > I am really not a big fan of working around compiler bugs in a device
> > driver.
> 
> Me neither
> 
> > Are we sure there are no other get_unaligned_be64() calls in the
> > kernel that suffer the same fate?
> 
> Agree, plus, as I've said before, we have 3-4 weeks before we go final,
> so we still have some time before a decision has to be made.  It looks
> like the gcc people already have a patch for the compiler, so the
> distributions could just push that out through channels.

I don't think we can realistically blacklist gcc-4.9.{0,1,2,3},
gcc-5.{0,1,2,3}.* and gcc-6.0 and require everyone to upgrade to compilers
that have not been released yet in order to build a linux-4.6 kernel.

	Arnd
