From: Andi Kleen <andi@firstfloor.org>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Thu, 10 Jan 2008 01:38:06 +0100
Message-ID: <20080110003806.GD18480@one.firstfloor.org>
References: <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de> <4785304A.60109@gmail.com> <20080109205850.GU16309@parisc-linux.org> <47853FA7.9050506@s5r6.in-berlin.de> <20080109222308.GE15612@one.firstfloor.org> <478552DF.1050203@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:51821 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbYAJAfe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 19:35:34 -0500
Content-Disposition: inline
In-Reply-To: <478552DF.1050203@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>, Jon Watte <jwatte@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Thu, Jan 10, 2008 at 12:03:59AM +0100, Stefan Richter wrote:
> Andi Kleen wrote:
> > On Wed, Jan 09, 2008 at 10:41:59PM +0100, Stefan Richter wrote:
> >> However, this further obfuscates the fact that libata uses Linux' SCSI
> >> midlayer and highlevel.  Which is a bad thing.  For example, there are
> > 
> > People are not interested in how libata is implemented internally.
> > They just want their SATA interfaces to work.
> > 
> > Kconfig is also not an educational facility or high level
> > design description of the code, but a pragmatic tool to get the job
> > done.
> 
> I did not talk about education or design decription.  I did talk about
> appropriately showing what the Kconfig options do.

That's "high level design description"

-Andi
