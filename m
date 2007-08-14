From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8885] New: Unable to access memory card reader
 anymore
Date: Mon, 13 Aug 2007 20:13:54 -0700
Message-ID: <20070813201354.baffcaba.akpm@linux-foundation.org>
References: <bug-8885-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065AbXHNDPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 23:15:00 -0400
In-Reply-To: <bug-8885-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel-announce@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, Pierre Ossman <drzeus@drzeus.cx>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: bugme-daemon@bugzilla.kernel.org, casteyde.christian@free.fr

On Mon, 13 Aug 2007 09:07:36 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8885
> 
>            Summary: Unable to access memory card reader anymore
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.23-rc3
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: io_scsi@kernel-bugs.osdl.org
>         ReportedBy: casteyde.christian@free.fr
> 
> 
> Most recent kernel where this bug did not occur: 2.6.22.1, maybe 2.6.23-rc2
> Distribution: Slackware 12.0
> Hardware Environment: Athlon64 3000, laptop Aspire 1511LMi, nForce3 150
> Software Environment: Kernel 2.6.23-rc3, blockdev, udev, KDE 3.5.7
> Problem Description:
> With kernel 2.6.22.1, when I plug a memory card in the integrated card reader
> of my laptop, the card is detected and KDE(via udev) asks me for mounting the
> device.
> With kernel 2.6.23-rc3, this does not happens anymore:
> - first, at boot, there are some new lines in dmesg saying /dev/sda is seen but
> size cannot be get (normal: there is no memory card in the reader);
> - second, plugging the card does nothing;
> - third, issuing "blockdev --rereadpt /dev/sda" does not work;
> - finally, fdisk /dev/sda fails (unable to open /dev/sda).
> So the device seems to be completly unusable now (this is a Thomson card reader
> if I remember well).
> 
> dmesg output for 2.6.22.1-cfs19 and 2.6.23-rc3 appended to show the
> differences.
> 
> Steps to reproduce:
> Maybe the problem is specific to my hardware. I presume: boot with an empty
> card reader connected, the plug the card and see it is inaccessible?
> 

I'm struggling a bit to work out if this is a scsi bug, a USB bug, an MMC bug
or whatever.  But it's a bug.

Michal, can you please track this as a post-2.6.22 regression?

Others: can you please take a look at the dmesg output, see if we can work
out which subsystem is (newly) failing?

Thanks.
