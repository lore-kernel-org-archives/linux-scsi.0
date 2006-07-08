From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: broken reverse_scan in aic7xxx
Date: Sat, 8 Jul 2006 12:37:52 -0600
Message-ID: <20060708183752.GF1605@parisc-linux.org>
References: <Pine.GSO.3.95.1060708171547.28320A-100000@rcs52.urz.tu-dresden.de> <20060708154449.GE1605@parisc-linux.org> <20060708174844.GB29602@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60361 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S964939AbWGHShx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 14:37:53 -0400
Content-Disposition: inline
In-Reply-To: <20060708174844.GB29602@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephan Seidl <stephan.seidl@tu-dresden.de>, linux-scsi@vger.kernel.org

On Sat, Jul 08, 2006 at 06:48:44PM +0100, Christoph Hellwig wrote:
> On Sat, Jul 08, 2006 at 09:44:49AM -0600, Matthew Wilcox wrote:
> > It's a simple choice between reverse_scan and supporting PCI hotplug.
> > You can't have both, and we chose the latter.  The same choice has been
> > made in virtually every other device driver.
> 
> Or you could submit a patch to implement a reverse scanning option in
> the core PCI code..

You'd want to specify that on a per-driver basis, though, surely.  Or
all your ethernet cards would get reversed too.  Oh, but it wouldn't be
enough for sym2 (iterate through card types instead of through pci ids),
so you'd want another option for that.

In the end it becomes a hideous mess and it's just easier to adapt
userspace.

Hey, anyone want to implement SIOCSIFNAME for scsi devices?  ;-)
