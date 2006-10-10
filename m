From: Jeremy Linton <jli@greshamstorage.com>
Subject: Re: What is Target Mode in SATA terminology?
Date: Tue, 10 Oct 2006 09:26:08 -0500
Message-ID: <200610100926.08656.jli@greshamstorage.com>
References: <1160423279.27817.4.camel@home-desk> <200610092215.20396.jli@greshamstorage.com> <20061010035842.GA10086@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from austin.greshamstorage.com ([216.143.252.250]:38674 "EHLO
	austin.greshamstorage.com") by vger.kernel.org with ESMTP
	id S932137AbWJJOos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 10:44:48 -0400
In-Reply-To: <20061010035842.GA10086@lsil.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: Sean Bruno <sean.bruno@dsl-only.net>, linux-scsi@vger.kernel.org

On Monday 09 October 2006 22:58, Eric Moore wrote:
> On Mon, Oct 09, 2006 at 10:15:20PM -0500, Jeremy Linton wrote:
> > > Is there an equivalent in SATA / SAS land?  If there is, is there a
> > > well supported PCI-(E/X) board out there that I could play with?
> >
> > 	Well, the MPT driver for scst should support SAS. I can tell you though
> > that the MPT driver isn't exactly stable for SPI..
> > -
>
> As far as I know, there are no scst target mode drivers for fusion.  Or are
> there? I've not heard of anyone doing that so far.
	One of the scst project members has a port of some LSI MPT target drivers to 
scst. They are here http://bj.soulinfo.com/%7Ehugang/scst/tgt/. I've been 
trying to get them working with a 53c1030 series LVD card and they don't get 
past exporting basic inquiry data. The contact for the drivers hasn't 
responded to any of my email's either, and the main project doesn't support 
them.

> The MPTSAS drivers you 'll find in the kernel tree are intiator mode only.
> We have a driver called mptstm,  supplied to various customers. Its a
> target mode driver. I can supply that per request.
	That would be excellent, if you have one newer than 1.00.13.


