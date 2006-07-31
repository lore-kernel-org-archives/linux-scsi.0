From: Kyle McMartin <kyle@parisc-linux.org>
Subject: Re: [PATCH] Fix scsi/scsi_transport.h compile error
Date: Mon, 31 Jul 2006 10:38:39 -0400
Message-ID: <20060731143839.GC6087@athena.road.mcmartin.ca>
References: <200607310943.25384.eike-kernel@sf-tec.de> <20060731131446.GB6087@athena.road.mcmartin.ca> <44CE07AA.9030202@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:57793 "EHLO
	stout.engsoc.carleton.ca") by vger.kernel.org with ESMTP
	id S1750770AbWGaOjR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 10:39:17 -0400
Content-Disposition: inline
In-Reply-To: <44CE07AA.9030202@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Mon, Jul 31, 2006 at 03:37:46PM +0200, Stefan Richter wrote:
> > This should be solved with a "struct scsi_device;" decl, instead of
> > Yet More Header Dependancies...
> 
> That function accesses members of the struct, i.e. the compiler needs to
> know offsets into struct scsi_device at this point. Therefore it needs
> the definition, not a declaration.

Odd, ISTR that it only needed to be defined at the point the inline was
used. Oh well, my bad.

--Kyle
