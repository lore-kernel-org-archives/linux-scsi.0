From: Chris Webb <chris@arachsys.com>
Subject: Re: oops during scsi scanning disk setup
Date: Fri, 21 Aug 2009 23:59:50 +0100
Message-ID: <20090821225950.GC10323@arachsys.com>
References: <20090820180549.GD7542@arachsys.com> <1250807161.4302.167.camel@mulgrave.site> <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com> <20090821092326.GF32115@arachsys.com> <1250863216.3844.1.camel@mulgrave.site> <20090821145141.GR32115@arachsys.com> <1250869674.7363.89.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:52543 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736AbZHUXED (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 19:04:03 -0400
Content-Disposition: inline
In-Reply-To: <1250869674.7363.89.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@suse.de> writes:

> Can you try this as a partial fix?  (It should prevent the oops, but
> you'll still lose the disk).

Hi James. Many thanks for this. Do you think it's worth adding a printk() to
flag up when this happens so we can detect when this case happens and
confirm the issue given how rare the crashes are, or is this difficult to
arrange?

Cheers,

Chris.
