From: Joshua Hoblitt <josh@hoblitt.com>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs
	disabled - dmesg filled with warnings
Date: Tue, 12 Feb 2008 12:21:09 -1000
Message-ID: <20080212222109.GC7640@hoblitt.com>
References: <47ADC74B.9080009@control.aau.dk> <1202580076.4254.24.camel@localhost.localdomain> <20080209193518.GC11299@hoblitt.com> <1202586219.4254.35.camel@localhost.localdomain> <20080212205345.GB7640@hoblitt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36304 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYBLWVM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 17:21:12 -0500
Content-Disposition: inline
In-Reply-To: <20080212205345.GB7640@hoblitt.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, dsd@gentoo.org, j_gentoo@hoblitt.com

I've got a few compilation errors on head.  Before I try it, is it
possible to backport the 76d78300a6eb8b7f08e47703b7e68a659ffc2053 change
to 2.6.24.y?

-J

--
On Tue, Feb 12, 2008 at 10:53:45AM -1000, Joshua Hoblitt wrote:
> I tried doing a build from that commit id but I get an oops from an
> unrelated subsystem.  I'll try again from the head of the tree.
> 
> -J
> 
> --
> On Sat, Feb 09, 2008 at 01:43:39PM -0600, James Bottomley wrote:
> > 
> > On Sat, 2008-02-09 at 09:35 -1000, Joshua Hoblitt wrote:
> > > Hi James,
> > > 
> > > I can give it a try.  What commit id do you think fixed it?
> > 
> > commit 76d78300a6eb8b7f08e47703b7e68a659ffc2053
> > Author: Nick Cheng <nick.cheng@areca.com.tw>
> > Date:   Mon Feb 4 23:53:24 2008 -0800
> > 
> >     [SCSI] arcmsr: updates (1.20.00.15)
> > 
> > James
> > 
> > 
