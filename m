From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 02 Apr 2004 19:16:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080951392.1829.164.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave>
	<20040403001105.GC1472@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:2728 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261400AbUDCARS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 19:17:18 -0500
In-Reply-To: <20040403001105.GC1472@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-04-02 at 19:11, Mike Anderson wrote:
> It looks like cdrom_release always returns 0? Is there some other patch
> outstanding that changes this.

Yes, not that I know of.

However, while it apparently has a return code indicating success or
failure, we should respect it [unless Jens wants to make it a void
function].

James
 

