From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Wed, 21 Apr 2004 16:02:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421160257.A6793@infradead.org>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:47367 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263173AbUDUPDB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 11:03:01 -0400
Content-Disposition: inline
In-Reply-To: <20040421141417.GV28633@tpkurt.garloff.de>; from garloff@suse.de on Wed, Apr 21, 2004 at 04:14:17PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Patrick Mansfield <patmans@us.ibm.com>

On Wed, Apr 21, 2004 at 04:14:17PM +0200, Kurt Garloff wrote:
> 
> Bugfix
> 
> Don't attach high level drivers (except sg) to devices with peripheral
> qualifier indicating not connected (1) or not capable (3).
> SPC3, 7.4.2.

Please don't duplicate it in every driver but in scsi_bus_match.  sg uses
a completely different attachment path so it shouldn't be affected by that.

