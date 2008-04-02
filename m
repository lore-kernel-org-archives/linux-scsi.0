From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with udev
Date: Wed, 2 Apr 2008 06:06:51 -0600
Message-ID: <20080402120651.GS16451@parisc-linux.org>
References: <bug-10374-10286@http.bugzilla.kernel.org/> <20080401011518.eb683cff.akpm@linux-foundation.org> <1207059115.3100.9.camel@localhost.localdomain> <20080401210521.abbb443c.seraph@xs4all.nl> <1207081169.3100.20.camel@localhost.localdomain> <20080401225717.7d936f91.seraph@xs4all.nl> <1207084454.3100.31.camel@localhost.localdomain> <20080402122944.7fe8e924.seraph@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080402122944.7fe8e924.seraph@xs4all.nl>
Sender: sparclinux-owner@vger.kernel.org
To: Jos van der Ende <seraph@xs4all.nl>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 02, 2008 at 12:29:44PM +0200, Jos van der Ende wrote:
> Maybe it's nothing, but I did notice that sym53c8xx compiles with a warning of a possibly uninitialized variable:
> 
>   CC [M]  drivers/scsi/sym53c8xx_2/sym_glue.o
> drivers/scsi/sym53c8xx_2/sym_glue.c: In function 'sym_eh_handler':
> drivers/scsi/sym53c8xx_2/sym_glue.c:612: warning: 'io_reset' may be used uninitialized in this function

Yeah, that's nothing.  It's actually a bug in GCC that produces that
warning (and it's code that'll never be executed on your platform anyway).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
