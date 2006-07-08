From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: broken reverse_scan in aic7xxx
Date: Sat, 8 Jul 2006 09:44:49 -0600
Message-ID: <20060708154449.GE1605@parisc-linux.org>
References: <Pine.GSO.3.95.1060708171547.28320A-100000@rcs52.urz.tu-dresden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:31442 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S964873AbWGHPou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 11:44:50 -0400
Content-Disposition: inline
In-Reply-To: <Pine.GSO.3.95.1060708171547.28320A-100000@rcs52.urz.tu-dresden.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephan Seidl <stephan.seidl@tu-dresden.de>
Cc: linux-scsi@vger.kernel.org

On Sat, Jul 08, 2006 at 05:21:59PM +0200, Stephan Seidl wrote:
> A victim of the cleaning operation is the option `aic7xxx=reverse_scan'
> which is still documented, but, which does no longer work. Here is some
> output.
> 
> Since `aic7xxx=reverse_scan' is part of my disaster recovery concept,
> I would like to ask whether anybody has the resources to reactivate
> this driver option as it was before ?

The documentation should be removed ;-)

It's a simple choice between reverse_scan and supporting PCI hotplug.
You can't have both, and we chose the latter.  The same choice has been
made in virtually every other device driver.

I'm afraid you're going to have to change your concept.
