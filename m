From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15503] insmod: error inserting '/lib/aic7xxx.ko': -1 Invalid
 modulkjournald starting
Date: Thu, 18 Mar 2010 23:05:14 GMT
Message-ID: <201003182305.o2IN5EnT028972@demeter.kernel.org>
References: <bug-15503-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47877 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0CRXFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 19:05:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2IN5EdE028973
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2010 23:05:14 GMT
In-Reply-To: <bug-15503-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15503


Will L Givens <wlgivens@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #6 from Will L Givens <wlgivens@gmail.com>  2010-03-18 23:05:07 ---
Kernel-2.6.33 seem to build without issue with a couple of patches and from the
looks of things, aka lack of complaints, appear to be pretty much an Alpha
related coding problem.

Linux jericho.southkc.net 2.6.33 #2 Thu Mar 18 17:30:33 CDT 2010 alpha alpha
alpha GNU/Linux


[root@jericho src]# gcc-4.3.4 -v
Using built-in specs.
Target: alphaev67-alpha-linux
Configured with: ../gcc-4.3.4/configure --build=alphaev67-alpha-linux
--host=alphaev67-alpha-linux --program-suffix=-4.3.4 --prefix=/usr
--mandir=/usr/share/man --infodir=/usr/share/info --enable-shared
--enable-threads=posix --enable-checking=release --with-system-zlib
--enable-__cxa_atexit --disable-libunwind-exceptions --enable-libgcj-multifile
--enable-languages=c,c++,objc,obj-c++,java,fortran --disable-dssi
--with-java-home=/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre --with-long-double-128
Thread model: posix
gcc version 4.3.4 (GCC)

[root@jericho src]# as -v
GNU assembler version 2.20.1 (alphaev5-alpha-linux) using BFD version (GNU
Binutils) 2.20.1.20100303

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
