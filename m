From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 13:43:08 -0400
Message-ID: <4844312C.7010403@garzik.org>
References: <12124164141515-patch-mail.ibm.com>	 <48441AEE.6050605@garzik.org>  <48441F82.6060706@linux.vnet.ibm.com> <1212425124.3369.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35479 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbYFBRnN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2008 13:43:13 -0400
In-Reply-To: <1212425124.3369.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com, Tejun Heo <htejun@gmail.com>

James Bottomley wrote:
> The problems seem to come at us from the 1:1 relationship between a
> 'port' and a host in libata.  Is there no way we can perhaps recast what
> we think of as a phy as what libata thinks of as a link and thus keep us
> at one host per actual physical device?


It's difficult to do that universally, but OTOH it would be quite 
reasonable to do that for modern SATA controllers, leaving the older 
master/slave controllers as one-host-per-port.

I've been wanting to do that for a while, even.

The main thing holding me back is not any technical issue, but desire to 
avoid breakage caused by abrupt topology change.

	Jeff



