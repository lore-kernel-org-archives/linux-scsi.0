From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Mon, 29 Oct 2007 13:27:42 -0400
Message-ID: <4726180E.5030909@garzik.org>
References: <1193671019.3383.13.camel@localhost.localdomain>	 <1193676852.2655.21.camel@lov.site>	 <1193677071.3383.56.camel@localhost.localdomain>	 <20071029181814.25410e00@gondolin.boeblingen.de.ibm.com> <1193678646.3383.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56308 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbXJ2R1u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 13:27:50 -0400
In-Reply-To: <1193678646.3383.76.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> visibility and creation are the same thing, aren't they?  An invisible
> attribute doesn't appear in the sysfs directory, so it's equivalent to
> the file for it not being created.


What about the case where it's visible at creation time, but then needs 
to be made selectively invisible later on?

That implies either a remove operation or dentry checks on each lookup?

	Jeff


