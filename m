From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Patches for SCSI scanning
Date: Tue, 20 Apr 2004 13:04:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420130414.A24817@infradead.org>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:41994 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262398AbUDTMEY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 08:04:24 -0400
Content-Disposition: inline
In-Reply-To: <20040420115419.GG4356@tpkurt.garloff.de>; from garloff@suse.de on Tue, Apr 20, 2004 at 01:54:19PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

> * Patch 2: Drop REPORT_LUN config option and introduce 
>   noreportlun and reportlun2 parameters (the latter allowing SCSI-2
>   devs to be scanned with REPORT_LUNS).

I'm all for this one.

> * Patch 3: Allow host adapters to avoid REPORT_LUNS.

Alson sounds okay, do you already have drivers that would set it?

> * Patch 4: allow_ghost_devices parameter

I still think this should be a blacklist flag as it's really a spec
violation from EMC if they really don't get it right.  And I still
haven't an answer why they can't work around it by setting those
magic devices online from userland.

> * Patch 5: inq_timeout parameter

Maybe this one should actually be a per-device tunable in sysfs?  Sure,
to actually make use of it for the root device you'd need an initrd but
the distros do that anyway.

> Sidenote: We should drop SCSI_FORCELUN and CONFIG_SCSI_MULTI_LUN, otherwise 
> people will misconfigure their kernel (such as the HP guy) and start to want 
> every multi-lun device listed.

Agreed.
