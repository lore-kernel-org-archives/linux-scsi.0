From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 1/1] Cleanup namespace collision with ktimers in drivers/scsi/*53c8xx.*
Date: Thu, 27 Oct 2005 20:04:05 +0100
Message-ID: <20051027190405.GB16211@infradead.org>
References: <200510251755.j9PHtd8n021013@shell0.pdx.osdl.net> <20051026041602.GA11040@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53634 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932163AbVJ0TEJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 15:04:09 -0400
Content-Disposition: inline
In-Reply-To: <20051026041602.GA11040@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@osdl.org, willy@debian.org, linux-scsi@vger.kernel.org, tglx@linutronix.de, James.Bottomley@steeleye.com, mingo@elte.hu

On Tue, Oct 25, 2005 at 10:16:02PM -0600, Matthew Wilcox wrote:
> On Tue, Oct 25, 2005 at 10:55:12AM -0700, akpm@osdl.org wrote:
> > Rename the time related macros in *53c8xx.* to cleanup the namespace
> > collision introduced by the ktimers patch.
> 
> wowYuckMixedCase?WhatIsThisJava?
> 
> How about we just delete that crap instead?  It boots ... but I've been
> up for 20 hours at this point, so I'm not prepared to guarantee I got
> all the conversions right.

Yeah, removing the ktime_ mess sounds much better.

