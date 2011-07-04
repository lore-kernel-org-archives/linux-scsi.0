From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] isci: sas controller driver for 3.0
Date: Mon, 4 Jul 2011 15:45:29 +0200
Message-ID: <20110704134529.GA8917@lst.de>
References: <1309563349.19567.26.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41030 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab1GDNpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2011 09:45:30 -0400
Content-Disposition: inline
In-Reply-To: <1309563349.19567.26.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, Jacek Danecki <jacek.danecki@intel.com>, hare@suse.de

On Fri, Jul 01, 2011 at 04:35:48PM -0700, Dan Williams wrote:
> James, please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master
> 
> ...to receive the isci driver that supports the integrated 6Gb/s SAS
> capabilities of the upcoming Intel(R) C600 series chipset family.  This
> part is targeted at standard servers / workstations and provides
> up to 8-ports (2x4-port controllers) of SAS beyond the traditional SATA
> ports (surfaced by the ahci driver).

The driver looks okay to me.  It's not stellar, but so much better
than the original.  I'll make sure to keep your TODO list long after
the merge, though :)

