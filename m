From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH2/5] mpt fusion: Added msi enable disable for FC,SPI,SAS
	[Resendig updated patch]
Date: Thu, 08 Jan 2009 09:00:31 -0600
Message-ID: <1231426831.3237.3.camel@localhost.localdomain>
References: <20090108085716.GA4116@lsi.com>
	 <20090108145303.GA6936@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60736 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbZAHPAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 10:00:37 -0500
In-Reply-To: <20090108145303.GA6936@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Kashyap, Desai" <kashyap.desai@lsi.com>, linux-scsi@vger.kernel.org, eric.moore@lsi.com, sathya.prakash@lsi.com

On Thu, 2009-01-08 at 07:53 -0700, Matthew Wilcox wrote:
> On Thu, Jan 08, 2009 at 02:27:16PM +0530, Kashyap, Desai wrote:
> > Added support for MSI enable/disable for different buses FC,SPI,SAS instead
> > of having single MSI enable/disable feature.
> 
> Why do you think you need this?
> 
> Either the system supports MSI or it doesn't.  The original reason for
> only enabling MSI on SPI cards was that it reduced the number of bug
> reports since FC and SAS cards are likely to be used on machines with
> functional MSI.
> 
> This is of course a horrible hack.  The right thing to do is to detect
> that you've never received an interrupt, disable MSI, enable regular
> interrupts and try again.

Right ... we actually had agreement on this and a set of patches to
implement some of it that went via the PCI list ... I'll see if I can
find them.

James


