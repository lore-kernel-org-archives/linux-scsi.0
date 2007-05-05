From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] tmscsim: Remove the last bus_to_virt()
Date: Sat, 5 May 2007 10:38:59 +0100
Message-ID: <20070505093859.GC9422@infradead.org>
References: <Pine.LNX.4.60.0705042259430.21060@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36794 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423252AbXEEJjA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 May 2007 05:39:00 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0705042259430.21060@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, May 04, 2007 at 11:00:49PM +0200, Guennadi Liakhovetski wrote:
> Dynamically map the buffer for PIO for the residue byte.

This look okay.  Btw, is there a chance you could run tmscsim.c
through scripts/Lindent before your next round of bigger changes?

