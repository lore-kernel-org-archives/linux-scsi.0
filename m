From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fc: force inlining of wwn conversion functions
Date: Mon, 25 Apr 2016 22:40:51 -0400
Message-ID: <yq1lh41gki4.fsf@sermon.lab.mkp.net>
References: <20160419085221.GA29087@gmail.com>
	<80200c53ae54f6cb34bd6fb51e9da65fdcc03004.1461073602.git.jpoimboe@redhat.com>
	<20160425160737.r6ewxzgknu7rjles@treble>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160425160737.r6ewxzgknu7rjles@treble> (Josh Poimboeuf's
	message of "Mon, 25 Apr 2016 11:07:37 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Denys Vlasenko <dvlasenk@redhat.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, jamborm@gcc.gnu.org, Ingo Molnar <mingo@kernel.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Josh" == Josh Poimboeuf <jpoimboe@redhat.com> writes:

Josh> Can you merge this patch for 4.6?

I am really not a big fan of working around compiler bugs in a device
driver.

Are we sure there are no other get_unaligned_be64() calls in the kernel
that suffer the same fate?

-- 
Martin K. Petersen	Oracle Linux Engineering
