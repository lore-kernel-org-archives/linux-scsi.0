From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 09 Apr 2004 06:28:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081510086.1759.2.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave>
	<20040404213307.A29446@beaverton.ibm.com>
	<1081199233.2105.45.camel@mulgrave>  <20040408230656.GO15125@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:52369 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261187AbUDIL2f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 07:28:35 -0400
In-Reply-To: <20040408230656.GO15125@kroah.com>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-08 at 18:06, Greg KH wrote:
> Why not just use a kref for this?  That's what they were created for?
> :)

Heh, I was waiting for you to say that.  Took you five days to notice,
though ....

I'll convert both sr and sd to use krefs.

James


