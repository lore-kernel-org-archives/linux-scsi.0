From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] Re: bug 2400
Date: Tue, 6 Apr 2004 08:52:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404060852.34169.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0404032026590.30873-100000@netrider.rowland.org> <4071EA82.3020901@pacbell.net> <1081214360.1756.330.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.kontent.de ([81.88.34.36]:50871 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S263641AbUDFGwi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 02:52:38 -0400
In-Reply-To: <1081214360.1756.330.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>


> The point is that all the disconnection event does is inform a subsystem
> that the entity represented by the other object has gone.  What it
> chooses to do with the information is up to it.  It could set it's own
> connected object to degraded, never use the other object again and drop
> the reference.  Or, it could simply ignore the indication and continue
> to use the other object (even though it will return errors for every
> operation).

Pure refcounting can never protect you against races with freeing objects.
The counters themselves must be protected. Try as you might you need
locks for that and rules on how this locks are to be used.

	Regards
		Oliver

