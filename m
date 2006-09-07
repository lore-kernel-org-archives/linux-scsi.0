From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] scsi_transport_sas: make minimum and maximum
	linkratesettable quantities
Date: Thu, 07 Sep 2006 09:22:55 -0500
Message-ID: <1157638975.3462.10.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D702E36E6@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:53161 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932212AbWIGOXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 10:23:00 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D702E36E6@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: dougg@torque.net, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2006-09-07 at 08:16 -0600, Moore, Eric wrote:
> I hope to do this soon, as well as implementing a internal smp
> passthru so we can handle the other cases, such as phy link/hard
> reset,
> and link errors for expanders via the same callback handler for hba's
> phys.
> Right now I'm trying to get caught up on sles10 issues and
> enahancements.
> I hope things to be caught up in the next week.

Good ... I'm starting to think we might junk all the function callbacks
and simply have even the HBA configured via SMP (i.e. the driver would
interpret SMP messages and set the HBA phys appropriately).

James


