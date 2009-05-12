From: Nick Piggin <npiggin@suse.de>
Subject: Re: Next May 11 : BUG during scsi initialization
Date: Tue, 12 May 2009 08:56:01 +0200
Message-ID: <20090512065601.GA19079@wotan.suse.de>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au> <4A081002.4050802@in.ibm.com> <20090511115233.GB8112@parisc-linux.org> <4A081437.7000409@in.ibm.com> <20090511122135.GC8112@parisc-linux.org> <20090512045716.GC32535@wotan.suse.de> <20090512155613.881fa2ec.sfr@canb.auug.org.au> <20090512055918.GF32535@wotan.suse.de> <20090512160352.4a97d2f4.sfr@canb.auug.org.au> <20090512165245.78b6bf83.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60003 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbZELG4C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 02:56:02 -0400
Content-Disposition: inline
In-Reply-To: <20090512165245.78b6bf83.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <matthew@wil.cx>, Sachin Sant <sachinp@in.ibm.com>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linuxppc-dev@ozlabs.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Tue, May 12, 2009 at 04:52:45PM +1000, Stephen Rothwell wrote:
> Hi Nick,
> 
> On Tue, 12 May 2009 16:03:52 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > This is what I have been getting for the last few days:
> 
> bisected into the net changes, I will follow up there, sorry.

No problem. Phew, yours was looking like a nasty one if it was indeed
an SLQB bug ;) 

Thanks,
Nick
