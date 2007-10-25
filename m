From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/4] [SCSI] ips: remove ips_ha members that duplicate
 struct pci_dev members
Date: Thu, 25 Oct 2007 18:06:19 +0200
Message-ID: <4720BEFB.9050408@panasas.com>
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234827.74AD61F81A1@havoc.gtf.org> <20071024212710.ae6e5120.akpm@linux-foundation.org> <4720251E.1030206@garzik.org> <4720B086.4070505@panasas.com> <20071025152849.GP27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:28948 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750998AbXJYQGf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 12:06:35 -0400
In-Reply-To: <20071025152849.GP27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Oct 25, 2007 at 05:04:38PM +0200, Boaz Harrosh wrote:
>> I found that lint, even with the command line options recommended by 
> 
> Do you mean Lindent / indent?
> 
Yes "indent". I found that there are better switches to indent than
what's in Lindent. But both are crap as for instance it does not
understand the linux style multi-line-comments and mess them up,
or it tabafy's broken-out-lines. Which is not what we usually
want. And lots of other stuff. astyle does a much better job
just by being less aggressive.

>> kernel, is to aggressive, and leaves lots of work to be fixed by hand.
>> (e.g it will touch the comments)
> 
> It's not perfect, but code beautification is an art, not a science ;-)
> 
> A lot of ugly code can't be made beautiful by a simple parser like
> indent because what it really needs is refactoring.  But you can't
> refactor until you've made it at least partially readable, so Lindent is
> the first step.
> 

I think I disagree 89% and agree 11%.
- remove trailing spaces
- Indent, 
- Convert "Indents" to tabs
- split long lines to multi lines, indent up to the last indent
  level, than fill with spaces, right align.
These can all be done by a machine, the Linux way.

Than
- Adjust broken out lines, like if and while statements to be more
  readable 
- Remove/add blank lines for readability or after end of locals.
That can be adjusted by a person.

But I think with a given code it can be made 89% acceptable by
a machine and 11% adjusted by a man. That is before I start
a single char of coding.

Boaz
 
