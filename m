From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUGFIX 1/2] gdth: scan for scsi devices
Date: Tue, 12 Feb 2008 13:05:25 -0500
Message-ID: <20080212180525.GA14745@infradead.org>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47B1D7A8.8010108@panasas.com> <47B1D8DA.6000109@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772AbYBLSFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 13:05:32 -0500
Content-Disposition: inline
In-Reply-To: <47B1D8DA.6000109@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sven K?hler <skoehler@upb.de>, linux-scsi <"linux-scsi"@vger.kernel.org>, James Bottomley <"James.Bottomley"@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>

On Tue, Feb 12, 2008 at 07:35:22PM +0200, Boaz Harrosh wrote:
> 
> The patch: "gdth: switch to modern scsi host registration"
> 
> missed one simple fact when moving a way from scsi_module.c.
> That is to call scsi_scan_host() on the probed host.
> With this the gdth driver from 2.6.24 is again able to
> see drives and boot.

Doh, someone please hand me a brown paper bag.  My first series
of patches had this but it got dropped when I rebased it over various
janitor cleanups.

The patch looks obviously correct, thanks.

