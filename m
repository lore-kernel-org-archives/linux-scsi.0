From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Is there a grand plan for FC failover?
Date: 28 Jan 2004 17:16:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075328212.2534.14.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C013B0@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:3994 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266189AbUA1WRW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 17:17:22 -0500
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C013B0@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: 'Patrick Mansfield' <patmans@us.ibm.com>, "Philip R. Auld" <pauld@egenera.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

On Wed, 2004-01-28 at 16:02, Smart, James wrote:
> I'd add one additional issue :
> 
> 3) SCSI Reservations
> 
> I guess this could be considered a part of (2), but given that reservations
> bring in a host of additional problems, and potentially brings up multi-host
> configs/clusters as well...

The current crop of cluster implementations that use reservations manage
quite well in user space alone.  Certainly, though, the presence of
reservations can interfere with failover code and may be considered a
problem that needs to be solved in multi-path...it all depends on how
the multi-path devices react to path switching in the face of
reservations.

I'm open to suggestions on this,  but I think it should be done
separately as part of a device ownership API.

James


