From: Jens Axboe <axboe@suse.de>
Subject: Re: bug 2400
Date: Tue, 6 Apr 2004 11:22:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040406092210.GG28109@suse.de>
References: <20040401131502.41136788.akpm@osdl.org> <1080862354.2118.78.camel@mulgrave> <1080949016.1804.161.camel@mulgrave> <20040405140309.GF9422@suse.de> <1081199307.2107.50.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:49366 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263673AbUDFJWX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 05:22:23 -0400
Content-Disposition: inline
In-Reply-To: <1081199307.2107.50.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Apr 05 2004, James Bottomley wrote:
> On Mon, 2004-04-05 at 09:03, Jens Axboe wrote:
> > Doesn't quite work, how about something like this as a work-around?
> 
> I'm not sure we want to be introducing yet another refcount.  What was
> the problem?

Same as in this thread, cdrom gets unregister'ed and freed too early.
Your patch looks better though, the new one that is.

-- 
Jens Axboe

