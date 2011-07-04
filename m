From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PULL] isci: sas controller driver for 3.0
Date: Mon, 4 Jul 2011 08:38:08 -0600
Message-ID: <20110704143808.GA389@parisc-linux.org>
References: <1309563349.19567.26.camel@dwillia2-linux> <20110704134529.GA8917@lst.de> <4E11C908.8020706@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41488 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1GDOiL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2011 10:38:11 -0400
Content-Disposition: inline
In-Reply-To: <4E11C908.8020706@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, James Bottomley <JBottomley@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, Jacek Danecki <jacek.danecki@intel.com>, hare@suse.de

On Mon, Jul 04, 2011 at 04:07:04PM +0200, Douglas Gilbert wrote:
> On 11-07-04 03:45 PM, Christoph Hellwig wrote:
>> On Fri, Jul 01, 2011 at 04:35:48PM -0700, Dan Williams wrote:
>>> James, please pull from:
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master
>>>
>>> ...to receive the isci driver that supports the integrated 6Gb/s SAS
>>> capabilities of the upcoming Intel(R) C600 series chipset family.  This
>>> part is targeted at standard servers / workstations and provides
>>> up to 8-ports (2x4-port controllers) of SAS beyond the traditional SATA
>>> ports (surfaced by the ahci driver).
>
> s/surfaced/serviced/

"surfaced" seems to be a popular term within Intel.  I believe it comes
from Windows.  It means "the ahci driver is responsible for creating
the device entries for the SATA ports".

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
