From: Adrian Sandu <dexter@d3xt3r01.tk>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in usb3 port
Date: Thu, 27 Sep 2012 19:45:36 +0300
Message-ID: <CAEG-z29bZGu4HLF=ZD2Rfk9c87Axo=vP-_s0VreuYMy5yA19sg@mail.gmail.com>
References: <CAEG-z28Whi7BufhFnUD8xLZAXjiV0qANc1JNF_62Toget_9CXg@mail.gmail.com>
 <Pine.LNX.4.44L0.1209271031340.1596-100000@iolanthe.rowland.org>
 <CAEG-z2-JCSsuiTOauUc9P9U7fNvbC0AB2Y=RmfRKrWb_d1SisQ@mail.gmail.com> <20120927152526.26675.qmail@stuge.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38764 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2I0Qp5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2012 12:45:57 -0400
Received: by padhz1 with SMTP id hz1so1500419pad.19
        for <linux-scsi@vger.kernel.org>; Thu, 27 Sep 2012 09:45:57 -0700 (PDT)
In-Reply-To: <20120927152526.26675.qmail@stuge.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Sandu <dexter@d3xt3r01.tk>, Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

> Adrian Sandu wrote:
>> I tried with a 3.3.8 , same thing happened. I don't understand why my
>> gentoo (asrock) fails and fedora(laptop) didn't ! :|
>
> Try what Alan suggested, start the Gentoo userland with the Fedora
> kernel.

I tried booting a Fedora-17-x86_64-Live-Desktop.iso .. same thing
happened on the asrock, will try and see if it happens on my laptop
too ..

> Do you have some crazy USE flags for your toolchain?
>
> If the Fedora kernel works, I would suggest to re-emerge binutils and
> gcc with USE=vanilla, and then build a fresh kernel.

[ebuild   R    ] sys-devel/binutils-2.22-r1  USE="cxx nls zlib
-multislot -multitarget -static-libs -test -vanilla" 37 kB
[ebuild   R    ] sys-devel/gcc-4.5.4  USE="cxx fortran mudflap
(multilib) nls nptl openmp (-altivec) -bootstrap -build -doc
(-fixed-point) -gcj -graphite -gtk (-hardened) (-libssp) -lto
-multislot -nocxx -nopie -nossp -objc -objc++ -objc-gc -test -vanilla"
0 k
