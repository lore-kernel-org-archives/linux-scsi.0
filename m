From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Mon, 11 Feb 2008 13:13:31 -0800
Message-ID: <1202764411.10004.15.camel@brick>
References: <1202432206.3171.53.camel@localhost.localdomain>
	 <1202432647.31361.26.camel@brick>
	 <1202432873.3171.58.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802081001540.18242@anakin>
	 <1202488620.3102.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:62247 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYBKVNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2008 16:13:34 -0500
Received: by rv-out-0910.google.com with SMTP id k20so3478160rvb.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2008 13:13:33 -0800 (PST)
In-Reply-To: <1202488620.3102.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>

On Fri, 2008-02-08 at 10:37 -0600, James Bottomley wrote:
> On Fri, 2008-02-08 at 10:03 +0100, Geert Uytterhoeven wrote:
> > On Thu, 7 Feb 2008, James Bottomley wrote:
> > > On Thu, 2008-02-07 at 17:04 -0800, Harvey Harrison wrote:
> > > > I'm going to guess that this is the entry in feature-removal.txt
> > > > that need an update then:
> > > > 
> > > > ---------------------------
> > > > 
> > > > What:	old NCR53C9x driver
> > > > When:	October 2007
> > > > Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> > > > 	driver can be ported over almost trivially.
> > > > Who:	David Miller <davem@davemloft.net>
> > > > 	Christoph Hellwig <hch@lst.de>
> > > 
> > > Not immediately ... I anticipate a few "where'd my driver go?" type
> > > questions from m68k for which this provides a useful reference to point
> > > to ...
> > 
> > Don't bother, we're fully aware of this.
> > 
> > The shortest feature removal notice in Linux's history (is it?) didn't go
> > unnoticed ;-)

So....would a patch be welcome to remove this entry then?

Harvey


