From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/4] [SCSI] ips: remove ips_ha members that duplicate struct pci_dev members
Date: Thu, 25 Oct 2007 09:28:50 -0600
Message-ID: <20071025152849.GP27248@parisc-linux.org>
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234827.74AD61F81A1@havoc.gtf.org> <20071024212710.ae6e5120.akpm@linux-foundation.org> <4720251E.1030206@garzik.org> <4720B086.4070505@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37070 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbXJYP2v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 11:28:51 -0400
Content-Disposition: inline
In-Reply-To: <4720B086.4070505@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Thu, Oct 25, 2007 at 05:04:38PM +0200, Boaz Harrosh wrote:
> I found that lint, even with the command line options recommended by 

Do you mean Lindent / indent?

> kernel, is to aggressive, and leaves lots of work to be fixed by hand.
> (e.g it will touch the comments)

It's not perfect, but code beautification is an art, not a science ;-)

A lot of ugly code can't be made beautiful by a simple parser like
indent because what it really needs is refactoring.  But you can't
refactor until you've made it at least partially readable, so Lindent is
the first step.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
