From: "John L. Males" <jlmales@gmail.com>
Subject: Request for Information Required for Linux Kernel Hard Lockup with
 PCMCIA SYM53C895a Card
Date: Fri, 28 Dec 2012 10:38:24 -0500
Message-ID: <20121228103824.e87b8aa4.jlmales@gmail.com>
Reply-To: jlmales@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45698 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2L1Pir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Dec 2012 10:38:47 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so12955961ieb.33
        for <linux-scsi@vger.kernel.org>; Fri, 28 Dec 2012 07:38:47 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Mathew,

I have a PCMCIA SYM53C895a based card that has been no end of
challenges for a few years.  It worked with one Debian kernel a
couple years ago, but only one and for the life of me I cannot
find the notes for what version.  I can advise you I did try to
find the Debian source code for that kernel version and it was
nowhere to be found as is sadly the case with Debian.  I even
tried going back one point release of that Debian version with
no success in finding a kernel that would work with the PCMCIA
SYM53C895a based card.  The general area that it was last known
that the PCMCIA SYM53C895a card worked was a network install
between 5.0.2 to 5.0.3 or 5.0.3 to 5.0.4 as best my memory can
recall.

What I like to know is is there any other information that will
be required besides the standing information in the kernel
source tarball on what information is required to submit a
Linux Kernel bug?

As an FYI I am currently running 3.4.24 which is the last
kernel version I used to see if the PCMCIA SYM53C895a bug was
resolved.


Regards,

John L. Males
Toronto, Ontario
Canada
28 December 2012 10:38


==============================================================
2012-12-28 10:24:49.735853695-0500-EST

28 Dec 10:24:49 ntpdate[4757]: ntpdate 4.2.6p2@1.2194-o Sun Oct
17 13:35:14 UTC 2010 (1)

28 Dec 10:25:09 ntpdate[4762]: step time server 199.102.46.72
offset 0.154124 sec

Linux 3.4.24-kernel.org-jlm-010-amd64 #1 SMP PREEMPT Sun Dec 23
10:06:41 EST 2012

Modified Debian GNU/Linux 6.0.3 (squeeze)
(Evaluating alternatives to Debian)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDdvPAACgkQ+V/XUtB6aBBkxwCg3rJJQ9b5PKTzcIzv0ApVLokS
lx8AoM5CAND9pcXes20oJIYnG5oeUJPW
=liOe
-----END PGP SIGNATURE-----
