From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Mon, 25 Apr 2016 20:37:31 -0700
Message-ID: <1461641851.2392.32.camel@HansenPartnership.com>
References: <20160419085221.GA29087@gmail.com>
	 <80200c53ae54f6cb34bd6fb51e9da65fdcc03004.1461073602.git.jpoimboe@redhat.com>
	 <20160425160737.r6ewxzgknu7rjles@treble>
	 <yq1lh41gki4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1lh41gki4.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, jamborm@gcc.gnu.org, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-04-25 at 22:40 -0400, Martin K. Petersen wrote:
> > > > > > "Josh" == Josh Poimboeuf <jpoimboe@redhat.com> writes:
> 
> Josh> Can you merge this patch for 4.6?
> 
> I am really not a big fan of working around compiler bugs in a device
> driver.

Me neither

> Are we sure there are no other get_unaligned_be64() calls in the
> kernel that suffer the same fate?

Agree, plus, as I've said before, we have 3-4 weeks before we go final,
so we still have some time before a decision has to be made.  It looks
like the gcc people already have a patch for the compiler, so the
distributions could just push that out through channels.

James
