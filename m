From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Attributes
Date: 16 Apr 2004 09:26:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082125583.2357.6.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C01698@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:62938 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263204AbUDPO0a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 10:26:30 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C01698@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

nOn Fri, 2004-04-16 at 08:55, Smart, James wrote:
> Think of something as simple as telling a specific instance what link
> topology type to initialize as. With the idea that you want to have this
> value persist through reboots of the system - and where the boot disk may be
> on that instance.  In all the questions I've thrown about - the only
> mechanism that appears to also handle boot is to hardcode it in the driver
> and recompile the driver for the persistence.

But this isn't a persistent property of the driver, is it?  It's a
property the user wants to set up and have loaded each time.  That can
easily be accommodated via a user daemon and sysfs attributes.

James


