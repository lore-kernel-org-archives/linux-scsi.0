From: Joshua Hoblitt <josh@hoblitt.com>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs
	disabled - dmesg filled with warnings
Date: Tue, 12 Feb 2008 10:53:45 -1000
Message-ID: <20080212205345.GB7640@hoblitt.com>
References: <47ADC74B.9080009@control.aau.dk> <1202580076.4254.24.camel@localhost.localdomain> <20080209193518.GC11299@hoblitt.com> <1202586219.4254.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56620 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763649AbYBLUxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 15:53:48 -0500
Content-Disposition: inline
In-Reply-To: <1202586219.4254.35.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, dsd@gentoo.org, j_gentoo@hoblitt.com

I tried doing a build from that commit id but I get an oops from an
unrelated subsystem.  I'll try again from the head of the tree.

-J

--
On Sat, Feb 09, 2008 at 01:43:39PM -0600, James Bottomley wrote:
> 
> On Sat, 2008-02-09 at 09:35 -1000, Joshua Hoblitt wrote:
> > Hi James,
> > 
> > I can give it a try.  What commit id do you think fixed it?
> 
> commit 76d78300a6eb8b7f08e47703b7e68a659ffc2053
> Author: Nick Cheng <nick.cheng@areca.com.tw>
> Date:   Mon Feb 4 23:53:24 2008 -0800
> 
>     [SCSI] arcmsr: updates (1.20.00.15)
> 
> James
> 
> 
