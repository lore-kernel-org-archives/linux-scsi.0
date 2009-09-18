From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v2 PATCH 0/19] A kernel-level configfs enabled generic target
	engine for Linux v2.6.32
Date: Fri, 18 Sep 2009 15:07:36 -0700
Message-ID: <1253311656.4498.143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:23278 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752532AbZIRWKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:10:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Daniel Walker <dwalker@fifo99.com>

Greetings all,

This is the second round of request for comments for TCM/ConfigFS v3.2 from lio-core-2.6.git.
Thanks to the folks who made comments, and I again invite people to take a look and make
recommendations on how the code can be futher improved to use the best available upstream
interfaces.

Also, the standalone patches for TCM v3.2 are now available from:

http://kernel.org/pub/linux/kernel/people/nab/target_core_mod-patches/

The first posting from 09112009 can be found here:

http://marc.info/?l=linux-kernel&m=125272088024636

The changelog since the posting on 09112009, which can be found here:

*) Convert to struct mutex for struct sempahore initialized with init_MUTEX() (mentioned by Daniel Walker)
*) Convert to struct completion for struct semaphore initialized with init_MUTEX_LOCKED() (mentioned by Daniel Walker)
*) Convert to use Kbuild instead of Makefile for drivers/target/ (mentioned by Boaz Harrosh)
*) Use include/asm-generic/div64.h for unsigned long long division on 32-bit architectures
*) Use include/linux/math64.h for unsigned long long modulo on 32-bit architectures

The lio-core-2.6.git tree can be found here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

More Information about Target_Core_Mod/ConfigFS, and PR and ALUA:

http://www.linux-iscsi.org/index.php/Target_Core_Mod/ConfigFS
http://www.linux-iscsi.org/index.php/Persistent_Reservations
http://www.linux-iscsi.org/index.php/ALUA

The complete v3.x TCM CLI operations set can be found here:

http://www.linux-iscsi.org/index.php/Lio-utils#v3.1_TCM_CLI_operations

Instructions and examples for getting setup:

http://www.linux-iscsi.org/builds/docs/LIO-3.0-Users_Reference_Manual.pdf
http://www.linux-iscsi.org/index.php/Howto#Start_target_core_mod

Constructive comments are welcome,

Thank you!

--nab

[RFC PATCH 1/19] Target_Core_Mod Asymmetric Logical Unit Assignment (ALUA) support
[RFC PATCH 2/19] Target_Core_Mod ConfigFS infrastructure
[RFC PATCH 3/19] Target_Core_Mod device core infrastructure
[RFC PATCH 4/19] Target_Core_Mod FILEIO <-> Linux/VFS subsystem
[RFC PATCH 5/19] Target_Core_Mod HBA core infrastructure
[RFC PATCH 6/19] Target_Core_Mod IBLOCK <-> Linux/Block subsystem plugin
[RFC PATCH 7/19] Target_Core_Mod SCSI MIBs
[RFC PATCH 8/19] Target_Core_Mod Subsystem and SE Object plugin infrastructure
[RFC PATCH 9/19] Target_Core_Mod SPC-4 Persistent Reservations
[RFC PATCH 10/19] Target_Core_Mod PSCSI <-> Linux/SCSI subsystem plugin
[RFC PATCH 11/19] Target_Core_Mod RAMDISK_DR and RAMDISK_MCP subsystem plugin
[RFC PATCH 12/19] Target_Core_Mod READ/WRITE command descriptor block generation code
[RFC PATCH 13/19] Target_Core_Mod Storage Engine Object infrastructure
[RFC PATCH 14/19] Target_Core_Mod Task Management infrastructure
[RFC PATCH 15/19] Target_Core_Mod portal group endpoint infrastructure
[RFC PATCH 16/19] Target_Core_Mod Generic Transport Core
[RFC PATCH 17/19] Target_Core_Mod Unit Attention emulation support
[RFC PATCH 18/19] Target_Core_Mod base and fabric_module includes
[RFC PATCH 19/19] Target_Core_Mod Kbuild/Kconfig

