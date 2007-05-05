From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/3] tmscsim: Remove the last bus_to_virt()
Date: Sat, 5 May 2007 23:19:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0705052318360.9593@poirot.grange>
References: <Pine.LNX.4.60.0705042259430.21060@poirot.grange>
 <20070505093859.GC9422@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48907 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933647AbXEEVTh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 May 2007 17:19:37 -0400
In-Reply-To: <20070505093859.GC9422@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Sat, 5 May 2007, Christoph Hellwig wrote:

> On Fri, May 04, 2007 at 11:00:49PM +0200, Guennadi Liakhovetski wrote:
> > Dynamically map the buffer for PIO for the residue byte.
> 
> This look okay.  Btw, is there a chance you could run tmscsim.c
> through scripts/Lindent before your next round of bigger changes?

Sure, with great pleasure:-)

And thanks for reviewing these patches!

Guennadi
---
Guennadi Liakhovetski
