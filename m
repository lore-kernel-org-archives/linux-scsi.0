From: Greg KH <greg@kroah.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Wed, 26 Jan 2005 08:48:01 -0800
Message-ID: <20050126164800.GB3438@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:8425 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262390AbVAZQsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jan 2005 11:48:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: 'Patrick Mansfield' <patmans@us.ibm.com>, "Mukker, Atul" <Atulm@lsil.com>, 'James Bottomley' <James.Bottomley@steeleye.com>, 'Linux Kernel' <linux-kernel@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

> Thanks for the suggestion. After more exploration, looks like different
> distribution have different implementations for /sbin/hotplug. This may
> aggravate the issue for applications. For now, we will stick with a wait and
> watch after bus scan :-(

What do you mean?  Just use the /etc/dev.d notification stuff that all
distros that use udev have.

And what do you mean "different implementations for /sbin/hotplug"?
What distros do not use the standard "linux-hotplug" type scripts, or if
not the scripts, the same functionality?

thanks,

greg k-h
