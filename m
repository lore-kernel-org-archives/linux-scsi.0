From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PATCH] intermediate SCSI updates
Date: Mon, 13 Oct 2008 18:22:05 -0400
Message-ID: <yq163nwcf02.fsf@sermon.lab.mkp.net>
References: <1223909115.5566.13.camel@localhost.localdomain>
	<alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
	<1223925606.5566.20.camel@localhost.localdomain>
	<alpine.LFD.2.00.0810131416410.3288@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:42079 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461AbYJMWXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2008 18:23:03 -0400
In-Reply-To: <alpine.LFD.2.00.0810131416410.3288@nehalem.linux-foundation.org> (Linus Torvalds's message of "Mon\, 13 Oct 2008 14\:22\:13 -0700 \(PDT\)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus> What I'm upset about is that this has apparently gotten not
Linus> even some trivial testing of the _default_ build. I'm not
Linus> talking about any odd config options here. I'm literally
Linus> talking about the only _sane_ config option case.

This one initially slipped through my testing, sorry about that.  I
always compile with the integrity both on and off in my devel tree but
I messed up while rebasing the patches against James' tree.  These
mutually dependent block and SCSI merges are always tricky to deal
with.

However, I wonder why the obvious build fix wasn't merged?  Mike
Anderson sent out a patch for this right after my patch appeared in
the SCSI tree...

-- 
Martin K. Petersen	Oracle Linux Engineering
