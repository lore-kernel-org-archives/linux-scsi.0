From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] isci merge candidate
Date: Fri, 13 May 2011 13:34:20 -0700
Message-ID: <BANLkTim3igaB8XXQkDY6GEutWfbK-o840A@mail.gmail.com>
References: <1305317680.21099.83.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758983Ab1EMUfO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2011 16:35:14 -0400
In-Reply-To: <1305317680.21099.83.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James.Bottomley@hansenpartnership.com, Christoph Hellwig <hch@lst.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Jeff Garzik <jeff@garzik.org>

On Fri, May 13, 2011 at 1:14 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
>
> [ Linus, only cc'ing you in case a new-driver merge exception can be
> entertained at this very late date. =A0James made clear he needed thi=
s in
> advance of rc7, and this still needs Christoph's ack, but I would be
> remiss not to send this after reaching this milestone...]

So I can merge new drivers at any stage in the development cycle, but
I only do that for drivers with mass appeal.

What's the likely user base of this? Why is it a SCSI driver rather
than SATA? Why is it so f&*%ing big?

The size may be a massive improvement over what it has been, but if
this is some kind of replacement for the current AHCI situation, it's
still a massive step backwards.

So what does that mean in practical terms:

 "This driver supports the 6Gb/s SAS/SATA capabilities of the upcoming
Intel(R) C600 series chipset family"

exactly? What's the market for that C600 series? Does that chipset
also do some AHCI emulation capability (making this driver be a "if
you need full capabilties thing" etc) Yadda yadda.

I don't want to merge 30k lines of driver that nobody will practically
speaking actually use.

                    Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
