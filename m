From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48241] oops when setting up LVM
Date: Wed,  3 Oct 2012 15:13:30 +0000 (UTC)
Message-ID: <20121003151330.49D3D11FC3E@bugzilla.kernel.org>
References: <bug-48241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43662 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab2JCPNl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D1ED620480
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 15:13:36 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 51B0B2047A
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 15:13:30 +0000 (UTC)
In-Reply-To: <bug-48241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48241





--- Comment #3 from Daniel Santos <daniel.santos@pobox.com>  2012-10-03 15:13:29 ---
Oh, I forgot my compiler:

$ gcc -v
Using built-in specs.
COLLECT_GCC=/usr/x86_64-pc-linux-gnu/gcc-bin/4.7.1/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-pc-linux-gnu/4.7.1/lto-wrapper
Target: x86_64-pc-linux-gnu
Configured with: /tmp/portage/sys-devel/gcc-4.7.1/work/gcc-4.7.1/configure
--prefix=/usr --bindir=/usr/x86_64-pc-linux-gnu/gcc-bin/4.7.1
--includedir=/usr/lib/gcc/x86_64-pc-linux-gnu/4.7.1/include
--datadir=/usr/share/gcc-data/x86_64-pc-linux-gnu/4.7.1
--mandir=/usr/share/gcc-data/x86_64-pc-linux-gnu/4.7.1/man
--infodir=/usr/share/gcc-data/x86_64-pc-linux-gnu/4.7.1/info
--with-gxx-include-dir=/usr/lib/gcc/x86_64-pc-linux-gnu/4.7.1/include/g++-v4
--host=x86_64-pc-linux-gnu --build=x86_64-pc-linux-gnu --disable-altivec
--disable-fixed-point --with-ppl --with-cloog --disable-ppl-version-check
--with-cloog-include=/usr/include/cloog-ppl --enable-lto --enable-nls
--without-included-gettext --with-system-zlib --enable-obsolete
--disable-werror --enable-secureplt --enable-multilib
--with-multilib-list=m32,m64 --enable-libmudflap --disable-libssp
--enable-libgomp
--with-python-dir=/share/gcc-data/x86_64-pc-linux-gnu/4.7.1/python
--enable-checking=release --enable-java-awt=gtk --enable-objc-gc
--enable-languages=c,c++,java,objc,obj-c++,fortran --enable-shared
--enable-threads=posix --enable-__cxa_atexit --enable-clocale=gnu
--enable-targets=all --with-bugurl=http://bugs.gentoo.org/
--with-pkgversion='Gentoo 4.7.1'
Thread model: posix
gcc version 4.7.1 (Gentoo 4.7.1)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
