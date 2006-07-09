From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: broken reverse_scan in aic7xxx
Date: Sun, 9 Jul 2006 06:19:04 -0600
Message-ID: <20060709121904.GI1605@parisc-linux.org>
References: <Pine.GSO.3.95.1060708171547.28320A-100000@rcs52.urz.tu-dresden.de> <20060708154449.GE1605@parisc-linux.org> <20060708174844.GB29602@infradead.org> <20060708183752.GF1605@parisc-linux.org> <1152434683.3255.36.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:30115 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1030470AbWGIMTF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jul 2006 08:19:05 -0400
Content-Disposition: inline
In-Reply-To: <1152434683.3255.36.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@fenrus.demon.nl>
Cc: Christoph Hellwig <hch@infradead.org>, Stephan Seidl <stephan.seidl@tu-dresden.de>, linux-scsi@vger.kernel.org

On Sun, Jul 09, 2006 at 10:44:43AM +0200, Arjan van de Ven wrote:
> On Sat, 2006-07-08 at 12:37 -0600, Matthew Wilcox wrote:
> > Hey, anyone want to implement SIOCSIFNAME for scsi devices?  ;-)
> 
> it's called udev, and it sets device names by UUID already ;-)

That's not true.  The kernel has a name for the scsi disc with major 8,
minor 0 and it's 'sda'.  It uses it in all the printks from sd.c.  The
poor user now has the job of mapping UUID <-> sdN <-> bus address <->
physical location, for we use the first three and often what they really
need to know is the fourth.

