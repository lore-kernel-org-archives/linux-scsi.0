From: Sir Ace <chandleg@wizardsworks.org>
Subject: Compile problems in 2.4.20 (fwd)
Date: Tue, 21 Jan 2003 14:09:52 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301211409340.27041-100000@wizardsworks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wizardsworks.org (IDENT:1000@localhost [127.0.0.1])
	by wizardsworks.wizardsworks.org (8.12.4/8.12.4) with ESMTP id h0LM9qnO027058
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2003 14:09:52 -0800
Received: from localhost (chandleg@localhost)
	by wizardsworks.org (8.12.4/8.12.4/Submit) with ESMTP id h0LM9qmJ027055
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2003 14:09:52 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I am attempting a compile of linus's tree of 2.4.20 on hppa platform
linux.  I am getting the error below.  I'm not a developer, but after
looking at the code, it really isn't defined anywhere that I could find.

make[2]: Entering directory `/usr/src/linux-2.4.20/drivers/scsi'
make all_targets
make[3]: Entering directory `/usr/src/linux-2.4.20/drivers/scsi'
gcc -D__KERNEL__ -I/usr/src/linux-2.4.20/include -Wall -Wstrict-prototypes
-Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer
-D__linux__ -pipe -fno-strength-reduce -mno-space-regs
-mfast-indirect-calls -mdisable-fpregs -ffunction-sections -march=1.1
-mschedule=7200   -nostdinc -iwithprefix include
-DKBUILD_BASENAME=scsi_merge  -c -o scsi_merge.o scsi_merge.c
scsi_merge.c: In function `__count_segments':
scsi_merge.c:225: warning: implicit declaration of function `page_to_phys'
scsi_merge.c: In function `initialize_merge_fn':
scsi_merge.c:1198: `PCI_DMA_BUS_IS_PHYS' undeclared (first use in this
function)scsi_merge.c:1198: (Each undeclared identifier is reported only
once
scsi_merge.c:1198: for each function it appears in.)
make[3]: *** [scsi_merge.o] Error 1
make[3]: Leaving directory `/usr/src/linux-2.4.20/drivers/scsi'
make[2]: *** [first_rule] Error 2
make[2]: Leaving directory `/usr/src/linux-2.4.20/drivers/scsi'
make[1]: *** [_subdir_scsi] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.20/drivers'
make: *** [_dir_drivers] Error 2
HPTux:/usr/src/linux#


HPTux:/usr/src/linux# gcc --version
3.0.4

HPTux:/usr/src/linux# make --version
GNU Make version 3.79.1, by Richard Stallman and Roland McGrath.
Built for hppa-unknown-linux-gnu
Copyright (C) 1988, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 2000
	Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

Report bugs to <bug-make@gnu.org>.

HPTux:/usr/src/linux#



