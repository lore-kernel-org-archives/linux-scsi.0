From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patchset 0/24] Lots of the Accessors patches and !use_sg cleanup
Date: Wed, 10 Oct 2007 13:14:24 -0600
Message-ID: <20071010191424.GE2730@parisc-linux.org>
References: <46E6F92D.2090409@panasas.com> <470D18EE.3090608@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38715 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbXJJTO0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2007 15:14:26 -0400
Content-Disposition: inline
In-Reply-To: <470D18EE.3090608@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

On Wed, Oct 10, 2007 at 08:24:46PM +0200, Boaz Harrosh wrote:
> I just did a rebase for all drivers they patch and compile
> over current scsi-misc. Save one, qlogicpti.c, a fix will follow.
> (I keep stumbling over Matthew's patches ;)

At least this time I only deleted some code you were patching.  It's
nothing on the mess in the gdth driver ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
