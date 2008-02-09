From: Joshua Hoblitt <josh@hoblitt.com>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs
	disabled - dmesg filled with warnings
Date: Sat, 9 Feb 2008 09:35:18 -1000
Message-ID: <20080209193518.GC11299@hoblitt.com>
References: <47ADC74B.9080009@control.aau.dk> <1202580076.4254.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48189 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbYBITu0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2008 14:50:26 -0500
Content-Disposition: inline
In-Reply-To: <1202580076.4254.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, dsd@gentoo.org, j_gentoo@hoblitt.com

Hi James,

I can give it a try.  What commit id do you think fixed it?

-J

--
On Sat, Feb 09, 2008 at 12:01:16PM -0600, James Bottomley wrote:
> 
> On Sat, 2008-02-09 at 16:31 +0100, Kim H??jgaard-Hansen wrote:
> > The following was reported by Joshua Hoblitt on Gentoo bugzilla when
> > using the arcmsr driver (see https://bugs.gentoo.org/208493)
> > 
> > When starting up the Areca RAID card http pass through proxy called
> > archttp dmesg is completely filled with messages as:
> > 
> > WARNING: at arch/x86/kernel/pci-dma_64.c:169 dma_free_coherent()
> > Pid: 8232, comm: archttp64 Not tainted 2.6.24-gentoo #1
> 
> Could you check git head, please; I think it's fixed upstream.
> 
> James
> 
> 
