From: Eric Moore <eric.moore@lsil.com>
Subject: Re: What is Target Mode in SATA terminology?
Date: Mon, 9 Oct 2006 21:58:43 -0600
Message-ID: <20061010035842.GA10086@lsil.com>
References: <1160423279.27817.4.camel@home-desk> <200610092215.20396.jli@greshamstorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:26569 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964945AbWJJEEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 00:04:48 -0400
Content-Disposition: inline
In-Reply-To: <200610092215.20396.jli@greshamstorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jli@greshamstorage.com>
Cc: Sean Bruno <sean.bruno@dsl-only.net>, linux-scsi@vger.kernel.org

On Mon, Oct 09, 2006 at 10:15:20PM -0500, Jeremy Linton wrote:
> > Is there an equivalent in SATA / SAS land?  If there is, is there a well
> > supported PCI-(E/X) board out there that I could play with?
> 	Well, the MPT driver for scst should support SAS. I can tell you though that 
> the MPT driver isn't exactly stable for SPI..
> -

As far as I know, there are no scst target mode drivers for fusion.  Or are
there? I've not heard of anyone doing that so far.

The MPTSAS drivers you 'll find in the kernel tree are intiator mode only.
We have a driver called mptstm,  supplied to various customers. Its a
target mode driver. I can supply that per request.

Mike Christie, during OLS, mentioned to me that he could later add target
support, as his done for iscsi, qlogic, other vendors, later this year for
fusion. I forgot what the name of the project for that, but its not scst.

WRT, mptspi, Pls advise me on any instability issues.

Thanks,
Eric Moore





