From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5] gdth: update deprecated pci_find_device
Date: Thu, 14 Feb 2008 14:45:14 -0600
Message-ID: <1203021914.3158.19.camel@localhost.localdomain>
References: <47B48CAE.2020705@panasas.com> <47B48DB5.1040303@panasas.com>
	 <47B4A0ED.5090401@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39615 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbYBNUpW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 15:45:22 -0500
In-Reply-To: <47B4A0ED.5090401@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2008-02-14 at 15:13 -0500, Jeff Garzik wrote:
> Boaz Harrosh wrote:
> > From: Sergio Luis <sergio@larces.uece.br>
> > 
> > Fix compilation warning in gdth.c, which was using the deprecated
> > pci_find_device.
[...]
> This patch is already upstream...  (unfortunately)

I think, in spite of the cover name (patches for stable), these are for
the set of testers who're based on 2.6.24.

James


