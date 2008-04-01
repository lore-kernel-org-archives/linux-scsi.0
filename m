From: Jos van der Ende <seraph@xs4all.nl>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
 udev
Date: Wed, 2 Apr 2008 00:30:01 +0200
Message-ID: <20080402003001.ebfbe93f.seraph@xs4all.nl>
References: <bug-10374-10286@http.bugzilla.kernel.org/>
	<20080401011518.eb683cff.akpm@linux-foundation.org>
	<1207059115.3100.9.camel@localhost.localdomain>
	<20080401210521.abbb443c.seraph@xs4all.nl>
	<1207081169.3100.20.camel@localhost.localdomain>
	<20080401225717.7d936f91.seraph@xs4all.nl>
	<1207084454.3100.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1207084454.3100.31.camel@localhost.localdomain>
Sender: sparclinux-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 01 Apr 2008 16:14:14 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Yes ... that's what I guess.  Just as one last grasp at a straw, is
> there any difference in /proc/iomem or /proc/ioports for the working
> case (sungem loaded first followed by sym2)?

Nope, exactly the same.

> > > I'm afraid I can't see anything relevant looking over the sym2 changes,
> > > so you might need to bisect this to identify the culprit.

First results are in: 2.6.23-rc1 could not boot, 2.6.23-rc2 already had the problem.


-- 
Jos van der Ende <seraph@xs4all.nl>
