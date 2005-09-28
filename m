From: Olivier Galibert <galibert@pobox.com>
Subject: Re: Infinite interrupt loop, INTSTAT = 0
Date: Wed, 28 Sep 2005 18:42:37 +0200
Message-ID: <20050928164237.GA40806@dspnet.fr.eu.org>
References: <20050928134514.GA19734@dspnet.fr.eu.org> <1127919909.4852.7.camel@mulgrave> <20050928160744.GA37975@dspnet.fr.eu.org> <1127924686.4852.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dspnet.fr.eu.org ([213.186.44.138]:7688 "EHLO dspnet.fr.eu.org")
	by vger.kernel.org with ESMTP id S1751423AbVI1Qmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2005 12:42:46 -0400
Content-Disposition: inline
In-Reply-To: <1127924686.4852.11.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Hack inc." <linux-kernel@vger.kernel.org>

On Wed, Sep 28, 2005 at 11:24:46AM -0500, James Bottomley wrote:
> On Wed, 2005-09-28 at 18:07 +0200, Olivier Galibert wrote:
> > scsi1:0:0:0: Attempting to abort cmd ffff8101b1cdf880: 0x28 0x0 0x0
> > 0xbc 0x0 0x3f 0x0 0x0 0x8 0x0
> 
> Hmm, that message doesn't appear in the current kernel driver.
> 
> Is this a non-standard kernel or non-standard aic79xx driver?

Hmmm, indeed, a leftover from when I was trying to debug some things
(a message in ahd_linux_abort).  Lemme recompile a perfectly vanilla
2.6.13.2.

  OG.
