From: James Bottomley <James.Bottomley@steeleye.com>
Subject: fwd: [RFD] Explicitly documenting patch submission
Date: 24 May 2004 12:35:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085420112.2255.81.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:6804 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264655AbUEXRfO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2004 13:35:14 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i4OHZCi18664
	for <linux-scsi@vger.kernel.org>; Mon, 24 May 2004 13:35:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The original message from Linus is here:

http://marc.theaimsgroup.com/?l=linux-kernel&m=108529494402563

I've attached the text below as well.  Unless anyone has strong
objections, we'll begin to use this "signed-off-by" tag for SCSI
submissions.

James

==========================begin forwarded message===============

Hola!

This is a request for discussion..

Some of you may have heard of this crazy company called SCO (aka "Smoking
Crack Organization") who seem to have a hard time believing that open
source works better than their five engineers do. They've apparently made
a couple of outlandish claims about where our source code comes from,
including claiming to own code that was clearly written by me over a
decade ago.

People have been pretty good (understatement of the year) at debunking
those claims, but the fact is that part of that debunking involved
searching kernel mailing list archives from 1992 etc. Not much fun.

For example, in the case of "ctype.h", what made it so clear that it was
original work was the horrible bugs it contained originally, and since we
obviously don't do bugs any more (right?), we should probably plan on
having other ways to document the origin of the code.

So, to avoid these kinds of issues ten years from now, I'm suggesting that 
we put in more of a process to explicitly document not only where a patch 
comes from (which we do actually already document pretty well in the 
changelogs), but the path it came through. 

Why the full path, and not just originator?

These days, most of the patches in the kernel don't actually get sent
directly to me. That not just wouldn't scale, but the fact is, there's a
lot of subsystems I have no clue about, and thus no way of judging how
good the patch is. So I end up seeing mostly the maintainers of the
subsystem, and when a bug happens, what I want to see is the maintainer
name, not a random developer who I don't even know if he is active any
more. So at least for me, the _chain_ is actually mostly more important
than the actual originator.

There is also another issue, namely the fact than when I (or anybody else,
for that matter) get an emailed patch, the only thing I can see directly
is the sender information, and that's the part I trust. When Andrew sends
me a patch, I trust it because it comes from him - even if the original
author may be somebody I don't know. So the _path_ the patch came in
through actually documents that chain of trust - we all tend to know the
"next hop", but we do _not_ necessarily have direct knowledge of the full
chain.

So what I'm suggesting is that we start "signing off" on patches, to show 
the path it has come through, and to document that chain of trust.  It 
also allows middle parties to edit the patch without somehow "losing" 
their names - quite often the patch that reaches the final kernel is not 
exactly the same as the original one, as it has gone through a few layers 
of people.

The plan is to make this very light-weight, and to fit in with how we 
already pass patches around - just add the sign-off to the end of the 
explanation part of the patch. That sign-off would be just a single line 
at the end (possibly after _other_ peoples sign-offs), saying:

	Signed-off-by: Random J Developer <random@developer.org>

To keep the rules as simple as possible, and yet making it clear what it
means to sign off on the patch, I've been discussing a "Developer's
Certificate of Origin" with a random collection of other kernel
developers (mainly subsystem maintainers).  This would basically be what
a developer (or a maintainer that passes through a patch) signs up for
when he signs off, so that the downstream (upstream?) developers know
that it's all ok:

	Developer's Certificate of Origin 1.0

	By making a contribution to this project, I certify that:

	(a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
	    indicated in the file; or

	(b) The contribution is based upon previous work that, to the best
	    of my knowledge, is covered under an appropriate open source
	    license and I have the right under that license to submit that
	    work with modifications, whether created in whole or in part
	    by me, under the same open source license (unless I am
	    permitted to submit under a different license), as indicated
	    in the file; or

	(c) The contribution was provided directly to me by some other
	    person who certified (a), (b) or (c) and I have not modified
	    it.

This basically allows people to sign off on other peoples patches, as long
as they see that the previous entry in the chain has been signed off on.  
And at the same time it makes the "personal trust" explicit to people who
don't necessarily understand how these things work. 

The above also allows for companies that have "release criteria" to have
the company "release person" sign off on a patch, so that a company can
easily incorporate their own internal release procedures and see that all
the patches have gone through the right channel. At the same time it is
meant to _not_ cause anybody to have to change how they work (ie there is
no "extra paperwork" at any point).

Comments, improvements, ideas? And yes, I know about digital signatures
etc, and that is _not_ what this is about. This is not about proving
authorship - it's about documenting the process. This does not replace or
preclude things like PGP-signed emails, this is _documenting_ how we work,
so that we can show people who don't understand the open source process.

			Linus



