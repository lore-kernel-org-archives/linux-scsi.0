From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Wed, 2 Oct 2002 23:30:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002233045.A12192@bitwizard.nl>
References: <OF4F84AA07.A8C2EDB0-ON87256C46.0062DDBA@boulder.ibm.com> <1033588299.23661.34.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1033588299.23661.34.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Scott Merritt <Scsi@PragmaSoft.com>, linux-scsi@vger.kernel.org

On Wed, Oct 02, 2002 at 08:51:39PM +0100, Alan Cox wrote:
> On Wed, 2002-10-02 at 19:10, Bryan Henderson wrote:
> > But when we speak of inhibiting partition table reading, I think that's
> > another (missing) feature:  I should be able to control whether Linux
> > considers there to be partitions on my disk or not (and change the fact
> 
> Why do you want to. Linux always offers you the entire disk anyway. 

Andries has argued this before, but I encountered a real-life example
today.

Today I was asked to recover data from a device where reading one
of the "bad" blocks would cause an immediate "lockup" of the device:
It would report ALL future blocks as bad as well. Only a power-cycle
could revert it to reporting other blocks as "working". 

In this case, the partition table luckily didn't reference any of the
bad blocks. But if it did, it would have made the recoverable 99% of
the device unaccessable. 

		Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
* The Worlds Ecosystem is a stable system. Stable systems may experience *
* excursions from the stable situation. We are currenly in such an       * 
* excursion: The stable situation does not include humans. ***************
