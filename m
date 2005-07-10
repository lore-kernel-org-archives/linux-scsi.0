From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 9 Jul 2005 23:29:14 -0400
Message-ID: <20050710032914.GA13883@havoc.gtf.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709233138.GT29099@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:55740 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S261829AbVGJD3P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jul 2005 23:29:15 -0400
Content-Disposition: inline
In-Reply-To: <20050709233138.GT29099@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sat, Jul 09, 2005 at 07:31:38PM -0400, Ben Collins wrote:
> Thing is, these don't seem to be working for SBP2. I assume these
> conversions came from libata

Incorrect.


> (since that's the only other user of them).

Incorrect.


> Was the logic compared to the SBP2 conversions before
> being moved over to using them?

Ask Al Viro, the author of the changes in question.


> Reverting this portion wont break anything, correct?

Probably correct.

	Jeff



