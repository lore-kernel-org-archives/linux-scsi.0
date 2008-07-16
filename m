From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Date: Wed, 16 Jul 2008 16:46:02 +0200
Message-ID: <20080716144602.GB4369@elte.hu>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu> <20080716131543.GA3673@elte.hu> <1216216320.3230.1.camel@localhost.localdomain> <20080716141805.GB22631@elte.hu> <20080716144106.GD25255@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:49735 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759893AbYGPOqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 10:46:13 -0400
Content-Disposition: inline
In-Reply-To: <20080716144106.GD25255@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jul 16, 2008 at 04:18:05PM +0200, Ingo Molnar wrote:
> > btw., about the technical aspects of the solution, i'm not sure i like 
> > these big #ifdef blocks:
> 
> It's partly the nature of the beast.  There's already several large
> #ifdef blocks in compat_ioctl.c -- CONFIG_NET, CONFIG_VT, 
> #CONFIG_SPARC, etc.  I think what would help is a bit more grouping so 
> #individual blocks get bigger.

yeah, that's OK - but why is scsi.h #ifdef-ed? For example we can 
include blkdev.h without #ifdef CONFIG_BLOCK.

	Ingo
