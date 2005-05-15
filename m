From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: 53C8XX /sys/devices/pci*/*/config revisited
Date: Sun, 15 May 2005 14:56:59 +0200
Message-ID: <20050515125658.GA17625@merlin.emma.line.org>
References: <m3br7c4ur6.fsf@merlin.emma.line.org> <1116155603.6270.16.camel@laptopd505.fenrus.org> <1116156415.6270.19.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:55698 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S262828AbVEOM5K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 May 2005 08:57:10 -0400
Content-Disposition: inline
In-Reply-To: <1116156415.6270.19.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthias Andree <matthias.andree@gmx.de>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, gregkh@kroah.com

On Sun, 15 May 2005, Arjan van de Ven wrote:

> 
> > if hal reads more than 64 bytes of config space (heck if it reads config
> > space at all) then it's terminally broken.
> 
> this brings up a bug in the kernel though....
> the config file is user readable! That's just plain dangerous and imo it
> should be a root-only file as a result.

The user can access only the first 64 bytes, but hald is apparently
meant to run as root so it can hack /etc/fstab for subfs file systems
and such. SUSE Linux 9.3 runs hald as root.

BTW, - note I have little clue of how PCI works - if the PCI
configuration space is only 64 bytes tall, then why the f* is the sysfs
.../config file listed as 256 bytes in the first place, even for root?

Relevant pointers to free copies of the PCI standard (the old 32 bit 33
MHz variant is sufficient) welcome, if such are available.

-- 
Matthias Andree
