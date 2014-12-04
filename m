From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 00/12] nobody loves the advansys driver
Date: Thu, 4 Dec 2014 10:13:53 +0100
Message-ID: <20141204091353.GB23891@lst.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <20141203152141.GA6175@lst.de> <201412031634.48711.linux@rainbow-software.org> <1417621350.2206.3.camel@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57355 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaLDJN4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:13:56 -0500
Content-Disposition: inline
In-Reply-To: <1417621350.2206.3.camel@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux@rainbow-software.org" <linux@rainbow-software.org>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "hare@suse.de" <hare@suse.de>, "matthew@wil.cx" <matthew@wil.cx>

On Wed, Dec 03, 2014 at 03:42:19PM +0000, James Bottomley wrote:
> That's the problem: The driver as-is works in all of the use cases, so
> no-one has any motivation to fix it.  Plus the complexity is pretty
> daunting.  It's not even the worst driver we have (that prize goes to
> atp870u which still has internal bus scanning code).  I'm not saying
> don't do the conversion, but I am saying it will have to be validated
> and tested before it can go in because lots of people still seem to use
> this family of devices in odd corners of the world.

The split itself actually is really easy - every single method has
a "if (ASC_NARROW_BOARD(boardp)) { ... } else { ... }" so the
code actually is separate.  But now that we have Hannes interested
in the wide side, and also a tester for the the narrow side I think we're
fine anyway.
