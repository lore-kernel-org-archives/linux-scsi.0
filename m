From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: broken reverse_scan in aic7xxx
Date: Sun, 09 Jul 2006 10:44:43 +0200
Message-ID: <1152434683.3255.36.camel@laptopd505.fenrus.org>
References: <Pine.GSO.3.95.1060708171547.28320A-100000@rcs52.urz.tu-dresden.de>
	 <20060708154449.GE1605@parisc-linux.org>
	 <20060708174844.GB29602@infradead.org>
	 <20060708183752.GF1605@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:51138 "EHLO
	laptopd505.fenrus.org") by vger.kernel.org with ESMTP
	id S932404AbWGIIos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jul 2006 04:44:48 -0400
In-Reply-To: <20060708183752.GF1605@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, Stephan Seidl <stephan.seidl@tu-dresden.de>, linux-scsi@vger.kernel.org

On Sat, 2006-07-08 at 12:37 -0600, Matthew Wilcox wrote:
> On Sat, Jul 08, 2006 at 06:48:44PM +0100, Christoph Hellwig wrote:
> > On Sat, Jul 08, 2006 at 09:44:49AM -0600, Matthew Wilcox wrote:
> > > It's a simple choice between reverse_scan and supporting PCI hotplug.
> > > You can't have both, and we chose the latter.  The same choice has been
> > > made in virtually every other device driver.
> > 
> > Or you could submit a patch to implement a reverse scanning option in
> > the core PCI code..
> 
> You'd want to specify that on a per-driver basis, though, surely.  Or
> all your ethernet cards would get reversed too.  Oh, but it wouldn't be
> enough for sym2 (iterate through card types instead of through pci ids),
> so you'd want another option for that.
> 
> In the end it becomes a hideous mess and it's just easier to adapt
> userspace.
> 
> Hey, anyone want to implement SIOCSIFNAME for scsi devices?  ;-)

it's called udev, and it sets device names by UUID already ;-)

