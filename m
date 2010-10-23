From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the merge window
Date: Sat, 23 Oct 2010 14:48:22 -0700
Message-ID: <ada8w1or36h.fsf@cisco.com>
References: <1287764862.8930.220.camel@mulgrave.site>
	<AANLkTikZ-vePH+Wvf9S0-0PG1h+rRNByKEmXC2XENH1=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:14957 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0JWVtC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Oct 2010 17:49:02 -0400
In-Reply-To: <AANLkTikZ-vePH+Wvf9S0-0PG1h+rRNByKEmXC2XENH1=@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 22 Oct 2010 17:48:35 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

 > There's a _single_ commit that looks like this:
 > 
 >  220 files changed, 34823 insertions(+), 43478 deletions(-)

Hey, you're not using git properly... if I use '-M' to show moved
files, I see:

 212 files changed, 30007 insertions(+), 38662 deletions(-)

which is a lot nicer.

 - R.
