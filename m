From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 05 Apr 2004 09:09:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081174199.1756.0.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave>
	<20040404213307.A29446@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:1763 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262584AbUDEOKs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 10:10:48 -0400
In-Reply-To: <20040404213307.A29446@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-04-04 at 23:33, Patrick Mansfield wrote:
> How is unregister_cdrom(&cd->cdi) called if the device is not open?

Yes, I need to pull the same kobject trick that sd does for the same
reason.

James


