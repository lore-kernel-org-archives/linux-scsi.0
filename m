From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2] sd: Try READ CAPACITY 16 first for SBC-2 devices
Date: Sat, 14 Mar 2009 17:47:00 -0600
Message-ID: <20090314234700.GF14127@parisc-linux.org>
References: <1236882030-27964-1-git-send-email-willy@linux.intel.com> <1236882030-27964-3-git-send-email-willy@linux.intel.com> <1237063291.3907.64.camel@localhost.localdomain> <20090314224843.GE14127@parisc-linux.org> <1237073695.3907.84.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40658 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZCNXrS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Mar 2009 19:47:18 -0400
Content-Disposition: inline
In-Reply-To: <1237073695.3907.84.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, Martin Petersen <mkp@mkp.net>

On Sat, Mar 14, 2009 at 06:34:55PM -0500, James Bottomley wrote:
> Actually, afraid not, you're trapped in the confusing maze of ASC/ASCQ
> codes, all sounding alike but meaning slightly different things:
> 0x24/0x00 is Invalid Field in CDB.  The problem I'm having is 0x20/00
> (Invalid Command Operation Code).

Ooh, so close!

> This will fix it, though ... I'll just merge it into your patch.

That's fine.  I'd like it if we had a set of inline functions called things
like 'invalid_command_operation_code()', but we don't, so I have no
objections to this patch.  I think merging it in is probably best.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
