From: Joshua Hoblitt <josh@hoblitt.com>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs
	disabled - dmesg filled with warnings
Date: Fri, 15 Feb 2008 10:56:57 -1000
Message-ID: <20080215205657.GB23625@hoblitt.com>
References: <47ADC74B.9080009@control.aau.dk> <1202580076.4254.24.camel@localhost.localdomain> <20080209193518.GC11299@hoblitt.com> <1202586219.4254.35.camel@localhost.localdomain> <20080212205345.GB7640@hoblitt.com> <20080212222109.GC7640@hoblitt.com> <1202855436.3137.153.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43878 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764704AbYBOU5B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2008 15:57:01 -0500
Content-Disposition: inline
In-Reply-To: <1202855436.3137.153.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, dsd@gentoo.org, j_gentoo@hoblitt.com

Hi James,

Daniel took the time to patch up the 2.6.24 version.  I've tested it and
the warning messages are gone.  Please take a look at:

http://bugs.gentoo.org/attachment.cgi?id=143585

Thanks,

-J

--
On Tue, Feb 12, 2008 at 04:30:36PM -0600, James Bottomley wrote:
> 
> On Tue, 2008-02-12 at 12:21 -1000, Joshua Hoblitt wrote:
> > I've got a few compilation errors on head.  Before I try it, is it
> > possible to backport the 76d78300a6eb8b7f08e47703b7e68a659ffc2053 change
> > to 2.6.24.y?
> 
> I don't see any reason why not but I'd have to cherry pick it to see ...
> so you could save me the bother by trying it yourself ...
> 
> James
> 
> 
