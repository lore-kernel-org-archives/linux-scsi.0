From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Wed, 21 Apr 2004 16:33:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421163336.A7382@infradead.org>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de> <20040421160257.A6793@infradead.org> <20040421152436.GD29699@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:9992 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263200AbUDUPdi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 11:33:38 -0400
Content-Disposition: inline
In-Reply-To: <20040421152436.GD29699@tpkurt.garloff.de>; from garloff@suse.de on Wed, Apr 21, 2004 at 05:24:36PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Wed, Apr 21, 2004 at 05:24:36PM +0200, Kurt Garloff wrote:
> > Please don't duplicate it in every driver but in scsi_bus_match.  sg uses
> > a completely different attachment path so it shouldn't be affected by that.
> 
> Is it safe to assume it will stay like this?

Yes.  The driver model assumes to zero or one drivers per device, and to
support sg in that world it needs to be a magic special case.

(also needs a respin of the sd.c part of the previous patch, btw - and while
you're at it can you kill the date in the scsi_scan.c comment?  Everyone can
see when it was applied in bk annotate or the web interface for it)
