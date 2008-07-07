From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: linux-next: scsi tree build failure
Date: Tue, 08 Jul 2008 08:05:50 +1000
Message-ID: <1215468350.8970.129.camel@pasglop>
References: <20080707222528.280f0b9e.sfr@canb.auug.org.au>
	 <1215441589.3274.17.camel@localhost.localdomain>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:38097 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758611AbYGGWGH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2008 18:06:07 -0400
In-Reply-To: <1215441589.3274.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, Robert Jennings <rcj@linux.vnet.ibm.com>, Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2008-07-07 at 09:39 -0500, James Bottomley wrote:
> > Caused because commit 341b56db6804040aa9559e913865108424e3b18b
> ("[SCSI]
> > ibmvscsi: driver enablement for CMO"), which was 15/16 in a series,
> has
> > been merged before any of the other patches in the series.  I have
> > reverted that commit.
> 
> Do I detect the fact that IBM sent a patch for a SCSI driver for which
> the core features weren't yet enabled (and which I couldn't check, not
> having a ppc build system)?

I suspect the sender (Robert) was asking for comments/review :-) In any
case, Robert, next time make it explicit on a patch CCed to a separate
list from the rest of the serie that it isn't to be merged without
dependencies.

James, if you ack it, I'll put it in powerpc.git.

Cheers,
Ben.

