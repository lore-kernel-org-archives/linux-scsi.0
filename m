From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 9 Jul 2005 23:34:31 -0400
Message-ID: <20050710033431.GB13883@havoc.gtf.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:32721 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S261839AbVGJDed (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jul 2005 23:34:33 -0400
Content-Disposition: inline
In-Reply-To: <20050709230656.GS29099@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sat, Jul 09, 2005 at 07:06:56PM -0400, Ben Collins wrote:
> I can understand that TYPE_RDC is what we had as TYPE_SDAD. Now, in our
> tree for TYPE_RDC, we converted it to TYPE_DISK. We also did a lot of mode
> conversions for DISK/RDC/ROM types.

This isn't correct.

RBC is a separate, valid disk type defined by the SCSI T10 committee.
It has its own spec.  Of course, SBP2 isn't wholly RBC compliant, even
though it reports itself as an RBC device.


> My question is, why were the conversions all removed? The conversions, as
> far as I know, are related to SBP protocol, and not SCSI, so why would the
> SCSI maintainers feel the need to rip out an important part of the SBP2
> driver?

It's a standard conversion that we've been ripping out of all drivers,
because it is unnecessary.

I understand you're a bit hacked off by all these changes occurring, but
how about debugging the failure you're seeing, before ripping out stuff?
"doesn't work at all" is untrue.  So who are the failure cases, and what
makes them different from the working case(s)?

	Jeff



