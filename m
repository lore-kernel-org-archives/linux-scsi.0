From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: 53C8XX /sys/devices/pci*/*/config revisited
Date: Sun, 15 May 2005 13:13:23 +0200
Message-ID: <1116155603.6270.16.camel@laptopd505.fenrus.org>
References: <m3br7c4ur6.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:32914 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261604AbVEOLN1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 May 2005 07:13:27 -0400
In-Reply-To: <m3br7c4ur6.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Sun, 2005-05-15 at 13:02 +0200, Matthias Andree wrote:
> Matthew,
> 
> remember the discussion we had in Late November last year about root
> reading the upper 128 bytes of SYM53C8XX's /sys/devices/pci/*/*/config
> file? See <http://marc.theaimsgroup.com/?l=linux-scsi&m=110113027015843&w=2>
> 
> The bug also affects a different user-space package, Freedesktop's
> "hal", that now ships with the new SUSE Linux 9.3.
> 
> I filed two bug reports/additions against the user space, SUSE Ticket ID
> [20050515990000057] and FreeDesktop's bugzilla as #1852.
> <https://bugs.freedesktop.org/show_bug.cgi?id=1852>
> 
> BTW, the hald bug #1852 has been open since 2004-11-14, and so is
> actually older than the discussion we had here, but SUSE wasn't using
> HAL at that time so I was unaware - I've posted the contents of my
> addition to that bug on the HAL list but if they haven't fixed the bug
> in half a year, I don't see why they'd fix the bug just now.

if hal reads more than 64 bytes of config space (heck if it reads config
space at all) then it's terminally broken.


