From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: ybin on powerpc
Date: Sat, 19 Aug 2006 19:56:30 -0600
Message-ID: <20060820015629.GU4340@parisc-linux.org>
References: <20060819111919.a60dca49.akpm@osdl.org> <1156024644.5803.73.camel@localhost.localdomain> <20060819182818.bf3ff5bc.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:24005 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932102AbWHTB4a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 21:56:30 -0400
Content-Disposition: inline
In-Reply-To: <20060819182818.bf3ff5bc.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sat, Aug 19, 2006 at 06:28:18PM -0700, Andrew Morton wrote:
> Bisection shows that this brokenness is introduced by git-scsi-misc.patch.
> 
> Someone has gone in and made some ill-advised "improvements" to
> /proc/scsi/scsi.  The switch from "Direct-Access" to "Direct access" broke
> ofpath.  I fixed that (in ofpath) but it remains broken for other reasons.
> 
> James, this is a non-compatible change to the kernel->userspace interface.  Please
> drop it like a hot potato.

This one's my fault.  I didn't realise that bit got exposed to userspace
like that.  James, do you want a replacement patch for the bad one, or
an incremental one which restores the old spelling?

BTW, the SCSI specs changed the name from CD-ROM to CD/DVD.  I'd like to
reflect that change in /proc/scsi/scsi; is there any userspace currently
relying on that spelling?
