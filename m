From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: What is Target Mode in SATA terminology?
Date: Mon, 09 Oct 2006 21:46:47 -0700
Message-ID: <1160455607.27817.8.camel@home-desk>
References: <1160423279.27817.4.camel@home-desk>
	 <200610092215.20396.jli@greshamstorage.com>
	 <20061010035842.GA10086@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron.pdx.net ([207.149.241.18]:32691 "EHLO iron.pdx.net")
	by vger.kernel.org with ESMTP id S964969AbWJJEqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 00:46:54 -0400
In-Reply-To: <20061010035842.GA10086@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: Jeremy Linton <jli@greshamstorage.com>, linux-scsi@vger.kernel.org

On Mon, 2006-10-09 at 21:58 -0600, Eric Moore wrote:
> On Mon, Oct 09, 2006 at 10:15:20PM -0500, Jeremy Linton wrote:
> > > Is there an equivalent in SATA / SAS land?  If there is, is there a well
> > > supported PCI-(E/X) board out there that I could play with?
> > 	Well, the MPT driver for scst should support SAS. I can tell you though that 
> > the MPT driver isn't exactly stable for SPI..
> > -
> 
> As far as I know, there are no scst target mode drivers for fusion.  Or are
> there? I've not heard of anyone doing that so far.
> 
> The MPTSAS drivers you 'll find in the kernel tree are intiator mode only.
> We have a driver called mptstm,  supplied to various customers. Its a
> target mode driver. I can supply that per request.
> 
hmmm...Is that something that you would need an NDA for?

Sean



