From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: aic79xx+ASC39320A crash
Date: Sun, 31 Dec 2006 11:29:43 -0800
Message-ID: <1167593383.27998.16.camel@home-desk>
References: <1167559635.5863.28.camel@tycho.astronomy.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:47198 "EHLO iron2.pdx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030379AbWLaTg0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Dec 2006 14:36:26 -0500
In-Reply-To: <1167559635.5863.28.camel@tycho.astronomy.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjarne Thomsen <bjarne.thomsen@get2net.dk>
Cc: linux-scsi@vger.kernel.org


On Sun, 2006-12-31 at 11:07 +0100, Bjarne Thomsen wrote:
> I have had this problem with an Adaptec ASC-39320A for more than 2 years
> (using the x86_64 version of the aic79xx driver).
> The 39320A board has been tried on the Tyan 2882 and 2885 MBs with
> the same result: I can copy a few small files, byt when I try to
> copy a directory tree with a few hundred MB the system freezes
> without any traces in the syslog or on the screen.
> Two older Ultra 160 Adaptec boards work fine with the 2 Tyan MBs.
> The raid option has been disabled for the ASC-39320A.
> 
> Tho years ago I gave up, but I have now tested the board
> with some newer linux distributions using the Tyan 2885 MB
> with the latest available BIOS (for both 2885 and 39320A):
> ubuntu 6.06 LTS x86_64 (2.6.15 kernel)
> Mandriva 2007 x86_64 (2.6.17 and 2.6.19 kernels)
> Fedora core 6 (2.6.18 kernel)
> 
> The symptom is the same: the system freezes during the copy
> of files from an IDE harddisk to a SCSI disk on the 39320 controller.
> I am about to give up, again.

Is there any crash dump or panic information on your screen?

Also, try resetting the board to defaults in it's BIOS and see if that
makes a difference.

Sean

