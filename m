From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] gdth: Isolate driver-global variables using helpers
Date: Sat, 21 Jul 2007 12:01:31 +0100
Message-ID: <20070721110131.GB22627@infradead.org>
References: <20070721022032.GA7264@havoc.gtf.org> <20070721022303.GD7264@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41428 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbXGULBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Jul 2007 07:01:32 -0400
Content-Disposition: inline
In-Reply-To: <20070721022303.GD7264@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

On Fri, Jul 20, 2007 at 10:23:03PM -0400, Jeff Garzik wrote:
>     [SCSI] gdth: Isolate driver-global variables using helpers
>     
>     Sanitizes access to some driver-global variables, in preparation for
>     making them dynamic rather than statically-sized.
>     
>     This equivalent-transform style change blissfully ignores the fact that
>     gdth_ctr_vtab[] is never used (only assigned), and that the driver
>     itself seems to get a bit confused between gdth_ctr_count and
>     gdth_ctr_vcount.  The whole virtual-controller stuff needs reviewing
>     for edge cases.

NACK.  This crap should mostly go away entirely and not beeing isolated.
I have patches for that somewhere deep down in my patchqueue.  I can't
surprise to have them forward ported today, but I'll try.

