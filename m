Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EA5C3F2D7
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C45C9246B6
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137000;
	bh=rZJ+CcKIYyR2ItuN0MZ7YWdlHOp4oX/xlp/ESAP4Vbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hiT1JU+5xguDacR/7xrv5SrtwKYNewM+Q1vXOmnK16iXtH2BbQoIYPrYH5Bibka7O
	 L60cifBb+2KgTrNCMYeVUc5SnMLq1ViH/Pv6LRhoQH6LbRWPSJjUcAeahBkQY9QuvE
	 Bx3ni9c10iaHtIeE+jRycowTY/FbZrLdSQGuk5G4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgCBIQk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbgCBIQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:25 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC6A524705;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136980;
        bh=rZJ+CcKIYyR2ItuN0MZ7YWdlHOp4oX/xlp/ESAP4Vbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+lDL6g19OhSpbcyp2xvnFLexJT3mfb21mYholXg+9YEkUOQyQ9AQlkOmSi9eLE1k
         RQuy4BIQPkdSp/RbdmNSFl6vxQNWnrmNTbeufNNANux+p0AnubrmalU6V5vfToS6y+
         4sHA/1t1S3O3+DcvFYeeHHccK9ByveCKBUNhUZ4E=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003zU-Vi; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 36/42] docs: scsi: convert st.txt to ReST
Date:   Mon,  2 Mar 2020 09:16:09 +0100
Message-Id: <6b2ddb36983e81e7028de6e5fd0c643c2fb4c6c9.1583136624.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1583136624.git.mchehab+huawei@kernel.org>
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/scsi/index.rst           |   1 +
 Documentation/scsi/scsi-parameters.rst |   4 +-
 Documentation/scsi/{st.txt => st.rst}  | 301 ++++++++++++++++---------
 MAINTAINERS                            |   2 +-
 drivers/scsi/Kconfig                   |   2 +-
 drivers/scsi/st.c                      |   2 +-
 6 files changed, 197 insertions(+), 115 deletions(-)
 rename Documentation/scsi/{st.txt => st.rst} (79%)

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index ff98919faed7..0cc2cfca7474 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -40,5 +40,6 @@ Linux SCSI Subsystem
    scsi
    sd-parameters
    smartpqi
+   st
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/scsi-parameters.rst b/Documentation/scsi/scsi-parameters.rst
index 0c4bbb1aee94..9aba897c97ac 100644
--- a/Documentation/scsi/scsi-parameters.rst
+++ b/Documentation/scsi/scsi-parameters.rst
@@ -73,7 +73,7 @@ parameters may be changed at runtime by the command
 
 	osst=		[HW,SCSI] SCSI Tape Driver
 			Format: <buffer_size>,<write_threshold>
-			See also Documentation/scsi/st.txt.
+			See also Documentation/scsi/st.rst.
 
 	scsi_debug_*=	[SCSI]
 			See drivers/scsi/scsi_debug.c.
@@ -105,7 +105,7 @@ parameters may be changed at runtime by the command
 			See header of drivers/scsi/sim710.c.
 
 	st=		[HW,SCSI] SCSI tape parameters (buffers, etc.)
-			See Documentation/scsi/st.txt.
+			See Documentation/scsi/st.rst.
 
 	wd33c93=	[HW,SCSI]
 			See header of drivers/scsi/wd33c93.c.
diff --git a/Documentation/scsi/st.txt b/Documentation/scsi/st.rst
similarity index 79%
rename from Documentation/scsi/st.txt
rename to Documentation/scsi/st.rst
index ec0acf6acccd..d3b28c28d74c 100644
--- a/Documentation/scsi/st.txt
+++ b/Documentation/scsi/st.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+The SCSI Tape Driver
+====================
+
 This file contains brief information about the SCSI tape driver.
 The driver is currently maintained by Kai Mäkisara (email
 Kai.Makisara@kolumbus.fi)
@@ -5,7 +11,8 @@ Kai.Makisara@kolumbus.fi)
 Last modified: Tue Feb  9 21:54:16 2016 by kai.makisara
 
 
-BASICS
+Basics
+======
 
 The driver is generic, i.e., it does not contain any code tailored
 to any specific tape drive. The tape parameters can be specified with
@@ -110,15 +117,17 @@ tape in the drive (commands trying to write something return error if
 attempted).
 
 
-MINOR NUMBERS
+Minor Numbers
+=============
 
 The tape driver currently supports up to 2^17 drives if 4 modes for
 each drive are used.
 
-The minor numbers consist of the following bit fields:
+The minor numbers consist of the following bit fields::
+
+    dev_upper non-rew mode dev-lower
+    20 -  8     7    6 5  4      0
 
-dev_upper non-rew mode dev-lower
-  20 -  8     7    6 5  4      0
 The non-rewind bit is always bit 7 (the uppermost bit in the lowermost
 byte). The bits defining the mode are below the non-rewind bit. The
 remaining bits define the tape device number. This numbering is
@@ -126,7 +135,8 @@ backward compatible with the numbering used when the minor number was
 only 8 bits wide.
 
 
-SYSFS SUPPORT
+Sysfs Support
+=============
 
 The driver creates the directory /sys/class/scsi_tape and populates it with
 directories corresponding to the existing tape devices. There are autorewind
@@ -148,10 +158,11 @@ bit definitions are the same as those used with MTSETDRVBUFFER in setting the
 options.
 
 A link named 'tape' is made from the SCSI device directory to the class
-directory corresponding to the mode 0 auto-rewind device (e.g., st0). 
+directory corresponding to the mode 0 auto-rewind device (e.g., st0).
 
 
-SYSFS AND STATISTICS FOR TAPE DEVICES
+Sysfs and Statistics for Tape Devices
+=====================================
 
 The st driver maintains statistics for tape drives inside the sysfs filesystem.
 The following method can be used to locate the statistics that are
@@ -160,10 +171,10 @@ available (assuming that sysfs is mounted at /sys):
 1. Use opendir(3) on the directory /sys/class/scsi_tape
 2. Use readdir(3) to read the directory contents
 3. Use regcomp(3)/regexec(3) to match directory entries to the extended
-        regular expression "^st[0-9]+$"
+   regular expression "^st[0-9]+$"
 4. Access the statistics from the /sys/class/scsi_tape/<match>/stats
-        directory (where <match> is a directory entry from /sys/class/scsi_tape
-        that matched the extended regular expression)
+   directory (where <match> is a directory entry from /sys/class/scsi_tape
+   that matched the extended regular expression)
 
 The reason for using this approach is that all the character devices
 pointing to the same tape drive use the same statistics. That means
@@ -171,29 +182,41 @@ that st0 would have the same statistics as nst0.
 
 The directory contains the following statistics files:
 
-1.  in_flight - The number of I/Os currently outstanding to this device.
-2.  io_ns - The amount of time spent waiting (in nanoseconds) for all I/O
+1.  in_flight
+      - The number of I/Os currently outstanding to this device.
+2.  io_ns
+      - The amount of time spent waiting (in nanoseconds) for all I/O
         to complete (including read and write). This includes tape movement
         commands such as seeking between file or set marks and implicit tape
         movement such as when rewind on close tape devices are used.
-3.  other_cnt - The number of I/Os issued to the tape drive other than read or
+3.  other_cnt
+      - The number of I/Os issued to the tape drive other than read or
         write commands. The time taken to complete these commands uses the
         following calculation io_ms-read_ms-write_ms.
-4.  read_byte_cnt - The number of bytes read from the tape drive.
-5.  read_cnt - The number of read requests issued to the tape drive.
-6.  read_ns - The amount of time (in nanoseconds) spent waiting for read
+4.  read_byte_cnt
+      - The number of bytes read from the tape drive.
+5.  read_cnt
+      - The number of read requests issued to the tape drive.
+6.  read_ns
+      - The amount of time (in nanoseconds) spent waiting for read
         requests to complete.
-7.  write_byte_cnt - The number of bytes written to the tape drive.
-8.  write_cnt - The number of write requests issued to the tape drive.
-9.  write_ns - The amount of time (in nanoseconds) spent waiting for write
+7.  write_byte_cnt
+      - The number of bytes written to the tape drive.
+8.  write_cnt
+      - The number of write requests issued to the tape drive.
+9.  write_ns
+      - The amount of time (in nanoseconds) spent waiting for write
         requests to complete.
-10. resid_cnt - The number of times during a read or write we found
+10. resid_cnt
+      - The number of times during a read or write we found
 	the residual amount to be non-zero. This should mean that a program
 	is issuing a read larger thean the block size on tape. For write
 	not all data made it to tape.
 
-Note: The in_flight value is incremented when an I/O starts the I/O
-itself is not added to the statistics until it completes.
+.. Note::
+
+   The in_flight value is incremented when an I/O starts the I/O
+   itself is not added to the statistics until it completes.
 
 The total of read_cnt, write_cnt, and other_cnt may not total to the same
 value as iodone_cnt at the device level. The tape statistics only count
@@ -210,7 +233,8 @@ The value of in_flight is 0 when there are no I/Os outstanding that are
 issued by the st driver. Tape statistics do not take into account any
 I/O performed via the sg device.
 
-BSD AND SYS V SEMANTICS
+BSD and Sys V Semantics
+=======================
 
 The user can choose between these two behaviours of the tape driver by
 defining the value of the symbol ST_SYSV. The semantics differ when a
@@ -221,13 +245,15 @@ filemark unless the filemark has just been crossed.
 The default is BSD semantics.
 
 
-BUFFERING
+Buffering
+=========
 
 The driver tries to do transfers directly to/from user space. If this
 is not possible, a driver buffer allocated at run-time is used. If
 direct i/o is not possible for the whole transfer, the driver buffer
 is used (i.e., bounce buffers for individual pages are not
 used). Direct i/o can be impossible because of several reasons, e.g.:
+
 - one or more pages are at addresses not reachable by the HBA
 - the number of pages in the transfer exceeds the number of
   scatter/gather segments permitted by the HBA
@@ -269,28 +295,30 @@ in the physical memory) are used if contiguous buffers can't be
 allocated. To support all SCSI adapters (including those not
 supporting scatter/gather), buffer allocation is using the following
 three kinds of chunks:
+
 1. The initial segment that is used for all SCSI adapters including
-those not supporting scatter/gather. The size of this buffer will be
-(PAGE_SIZE << ST_FIRST_ORDER) bytes if the system can give a chunk of
-this size (and it is not larger than the buffer size specified by
-ST_BUFFER_BLOCKS). If this size is not available, the driver halves
-the size and tries again until the size of one page. The default
-settings in st_options.h make the driver to try to allocate all of the
-buffer as one chunk.
+   those not supporting scatter/gather. The size of this buffer will be
+   (PAGE_SIZE << ST_FIRST_ORDER) bytes if the system can give a chunk of
+   this size (and it is not larger than the buffer size specified by
+   ST_BUFFER_BLOCKS). If this size is not available, the driver halves
+   the size and tries again until the size of one page. The default
+   settings in st_options.h make the driver to try to allocate all of the
+   buffer as one chunk.
 2. The scatter/gather segments to fill the specified buffer size are
-allocated so that as many segments as possible are used but the number
-of segments does not exceed ST_FIRST_SG.
+   allocated so that as many segments as possible are used but the number
+   of segments does not exceed ST_FIRST_SG.
 3. The remaining segments between ST_MAX_SG (or the module parameter
-max_sg_segs) and the number of segments used in phases 1 and 2
-are used to extend the buffer at run-time if this is necessary. The
-number of scatter/gather segments allowed for the SCSI adapter is not
-exceeded if it is smaller than the maximum number of scatter/gather
-segments specified. If the maximum number allowed for the SCSI adapter
-is smaller than the number of segments used in phases 1 and 2,
-extending the buffer will always fail.
+   max_sg_segs) and the number of segments used in phases 1 and 2
+   are used to extend the buffer at run-time if this is necessary. The
+   number of scatter/gather segments allowed for the SCSI adapter is not
+   exceeded if it is smaller than the maximum number of scatter/gather
+   segments specified. If the maximum number allowed for the SCSI adapter
+   is smaller than the number of segments used in phases 1 and 2,
+   extending the buffer will always fail.
 
 
-EOM BEHAVIOUR WHEN WRITING
+EOM Behaviour When Writing
+==========================
 
 When the end of medium early warning is encountered, the current write
 is finished and the number of bytes is returned. The next write
@@ -300,12 +328,13 @@ bytes is returned. After this, -1 and the number of bytes are
 alternately returned until the physical end of medium (or some other
 error) is encountered.
 
-
-MODULE PARAMETERS
+Module Parameters
+=================
 
 The buffer size, write threshold, and the maximum number of allocated buffers
 are configurable when the driver is loaded as a module. The keywords are:
 
+========================== ===========================================
 buffer_kbs=xxx             the buffer size for fixed block mode is set
 			   to xxx kilobytes
 write_threshold_kbs=xxx    the write threshold in kilobytes set to xxx
@@ -313,12 +342,14 @@ max_sg_segs=xxx		   the maximum number of scatter/gather
 			   segments
 try_direct_io=x		   try direct transfer between user buffer and
 			   tape drive if this is non-zero
+========================== ===========================================
 
 Note that if the buffer size is changed but the write threshold is not
 set, the write threshold is set to the new buffer size - 2 kB.
 
 
-BOOT TIME CONFIGURATION
+Boot Time Configuration
+=======================
 
 If the driver is compiled into the kernel, the same parameters can be
 also set using, e.g., the LILO command line. The preferred syntax is
@@ -332,21 +363,23 @@ versions is supported. The same keywords can be used as when loading
 the driver as module. If several parameters are set, the keyword-value
 pairs are separated with a comma (no spaces allowed). A colon can be
 used instead of the equal mark. The definition is prepended by the
-string st=. Here is an example:
+string st=. Here is an example::
 
 	st=buffer_kbs:64,write_threshold_kbs:60
 
-The following syntax used by the old kernel versions is also supported:
+The following syntax used by the old kernel versions is also supported::
 
            st=aa[,bb[,dd]]
 
-where
-  aa is the buffer size for fixed block mode in 1024 byte units
-  bb is the write threshold in 1024 byte units
-  dd is the maximum number of scatter/gather segments
+where:
 
+  - aa is the buffer size for fixed block mode in 1024 byte units
+  - bb is the write threshold in 1024 byte units
+  - dd is the maximum number of scatter/gather segments
 
-IOCTLS
+
+IOCTLs
+======
 
 The tape is positioned and the drive parameters are set with ioctls
 defined in mtio.h The tape control program 'mt' uses these ioctls. Try
@@ -359,55 +392,80 @@ The supported ioctls are:
 
 The following use the structure mtop:
 
-MTFSF   Space forward over count filemarks. Tape positioned after filemark.
-MTFSFM  As above but tape positioned before filemark.
-MTBSF	Space backward over count filemarks. Tape positioned before
+MTFSF
+	Space forward over count filemarks. Tape positioned after filemark.
+MTFSFM
+	As above but tape positioned before filemark.
+MTBSF
+	Space backward over count filemarks. Tape positioned before
         filemark.
-MTBSFM  As above but ape positioned after filemark.
-MTFSR   Space forward over count records.
-MTBSR   Space backward over count records.
-MTFSS   Space forward over count setmarks.
-MTBSS   Space backward over count setmarks.
-MTWEOF  Write count filemarks.
-MTWEOFI	Write count filemarks with immediate bit set (i.e., does not
+MTBSFM
+	As above but ape positioned after filemark.
+MTFSR
+	Space forward over count records.
+MTBSR
+	Space backward over count records.
+MTFSS
+	Space forward over count setmarks.
+MTBSS
+	Space backward over count setmarks.
+MTWEOF
+	Write count filemarks.
+MTWEOFI
+	Write count filemarks with immediate bit set (i.e., does not
 	wait until data is on tape)
-MTWSM   Write count setmarks.
-MTREW   Rewind tape.
-MTOFFL  Set device off line (often rewind plus eject).
-MTNOP   Do nothing except flush the buffers.
-MTRETEN Re-tension tape.
-MTEOM   Space to end of recorded data.
-MTERASE Erase tape. If the argument is zero, the short erase command
+MTWSM
+	Write count setmarks.
+MTREW
+	Rewind tape.
+MTOFFL
+	Set device off line (often rewind plus eject).
+MTNOP
+	Do nothing except flush the buffers.
+MTRETEN
+	Re-tension tape.
+MTEOM
+	Space to end of recorded data.
+MTERASE
+	Erase tape. If the argument is zero, the short erase command
 	is used. The long erase command is used with all other values
 	of the argument.
-MTSEEK	Seek to tape block count. Uses Tandberg-compatible seek (QFA)
+MTSEEK
+	Seek to tape block count. Uses Tandberg-compatible seek (QFA)
         for SCSI-1 drives and SCSI-2 seek for SCSI-2 drives. The file and
 	block numbers in the status are not valid after a seek.
-MTSETBLK Set the drive block size. Setting to zero sets the drive into
+MTSETBLK
+	Set the drive block size. Setting to zero sets the drive into
         variable block mode (if applicable).
-MTSETDENSITY Sets the drive density code to arg. See drive
+MTSETDENSITY
+	Sets the drive density code to arg. See drive
         documentation for available codes.
-MTLOCK and MTUNLOCK Explicitly lock/unlock the tape drive door.
-MTLOAD and MTUNLOAD Explicitly load and unload the tape. If the
+MTLOCK and MTUNLOCK
+	Explicitly lock/unlock the tape drive door.
+MTLOAD and MTUNLOAD
+	Explicitly load and unload the tape. If the
 	command argument x is between MT_ST_HPLOADER_OFFSET + 1 and
 	MT_ST_HPLOADER_OFFSET + 6, the number x is used sent to the
 	drive with the command and it selects the tape slot to use of
 	HP C1553A changer.
-MTCOMPRESSION Sets compressing or uncompressing drive mode using the
+MTCOMPRESSION
+	Sets compressing or uncompressing drive mode using the
 	SCSI mode page 15. Note that some drives other methods for
 	control of compression. Some drives (like the Exabytes) use
 	density codes for compression control. Some drives use another
 	mode page but this page has not been implemented in the
 	driver. Some drives without compression capability will accept
 	any compression mode without error.
-MTSETPART Moves the tape to the partition given by the argument at the
+MTSETPART
+	Moves the tape to the partition given by the argument at the
 	next tape operation. The block at which the tape is positioned
 	is the block where the tape was previously positioned in the
 	new active partition unless the next tape operation is
 	MTSEEK. In this case the tape is moved directly to the block
 	specified by MTSEEK. MTSETPART is inactive unless
 	MT_ST_CAN_PARTITIONS set.
-MTMKPART Formats the tape with one partition (argument zero) or two
+MTMKPART
+	Formats the tape with one partition (argument zero) or two
 	partitions (argument non-zero). If the argument is positive,
 	it specifies the size of partition 1 in megabytes. For DDS
 	drives and several early drives this is the physically first
@@ -422,64 +480,81 @@ MTSETDRVBUFFER
         with mask MT_SET_OPTIONS, the low order bits are used as argument.
 	This command is only allowed for the superuser (root). The
 	subcommands are:
-	0
+
+	* 0
            The drive buffer option is set to the argument. Zero means
            no buffering.
-        MT_ST_BOOLEANS
+        * MT_ST_BOOLEANS
            Sets the buffering options. The bits are the new states
            (enabled/disabled) the following options (in the
 	   parenthesis is specified whether the option is global or
 	   can be specified differently for each mode):
-	     MT_ST_BUFFER_WRITES write buffering (mode)
-	     MT_ST_ASYNC_WRITES asynchronous writes (mode)
-             MT_ST_READ_AHEAD  read ahead (mode)
-             MT_ST_TWO_FM writing of two filemarks (global)
-	     MT_ST_FAST_EOM using the SCSI spacing to EOD (global)
-	     MT_ST_AUTO_LOCK automatic locking of the drive door (global)
-             MT_ST_DEF_WRITES the defaults are meant only for writes (mode)
-	     MT_ST_CAN_BSR backspacing over more than one records can
+
+	     MT_ST_BUFFER_WRITES
+		write buffering (mode)
+	     MT_ST_ASYNC_WRITES
+		asynchronous writes (mode)
+             MT_ST_READ_AHEAD
+		read ahead (mode)
+             MT_ST_TWO_FM
+		writing of two filemarks (global)
+	     MT_ST_FAST_EOM
+		using the SCSI spacing to EOD (global)
+	     MT_ST_AUTO_LOCK
+		automatic locking of the drive door (global)
+             MT_ST_DEF_WRITES
+		the defaults are meant only for writes (mode)
+	     MT_ST_CAN_BSR
+		backspacing over more than one records can
 		be used for repositioning the tape (global)
-	     MT_ST_NO_BLKLIMS the driver does not ask the block limits
+	     MT_ST_NO_BLKLIMS
+		the driver does not ask the block limits
 		from the drive (block size can be changed only to
 		variable) (global)
-	     MT_ST_CAN_PARTITIONS enables support for partitioned
+	     MT_ST_CAN_PARTITIONS
+		enables support for partitioned
 		tapes (global)
-	     MT_ST_SCSI2LOGICAL the logical block number is used in
+	     MT_ST_SCSI2LOGICAL
+		the logical block number is used in
 		the MTSEEK and MTIOCPOS for SCSI-2 drives instead of
 		the device dependent address. It is recommended to set
 		this flag unless there are tapes using the device
 		dependent (from the old times) (global)
-	     MT_ST_SYSV sets the SYSV semantics (mode)
-	     MT_ST_NOWAIT enables immediate mode (i.e., don't wait for
+	     MT_ST_SYSV
+		sets the SYSV semantics (mode)
+	     MT_ST_NOWAIT
+		enables immediate mode (i.e., don't wait for
 	        the command to finish) for some commands (e.g., rewind)
-	     MT_ST_NOWAIT_EOF enables immediate filemark mode (i.e. when
+	     MT_ST_NOWAIT_EOF
+		enables immediate filemark mode (i.e. when
 	        writing a filemark, don't wait for it to complete). Please
 		see the BASICS note about MTWEOFI with respect to the
 		possible dangers of writing immediate filemarks.
-	     MT_ST_SILI enables setting the SILI bit in SCSI commands when
+	     MT_ST_SILI
+		enables setting the SILI bit in SCSI commands when
 		reading in variable block mode to enhance performance when
 		reading blocks shorter than the byte count; set this only
 		if you are sure that the drive supports SILI and the HBA
 		correctly returns transfer residuals
-	     MT_ST_DEBUGGING debugging (global; debugging must be
+	     MT_ST_DEBUGGING
+		debugging (global; debugging must be
 		compiled into the driver)
-	MT_ST_SETBOOLEANS
-	MT_ST_CLEARBOOLEANS
+
+	* MT_ST_SETBOOLEANS, MT_ST_CLEARBOOLEANS
 	   Sets or clears the option bits.
-        MT_ST_WRITE_THRESHOLD
+        * MT_ST_WRITE_THRESHOLD
            Sets the write threshold for this device to kilobytes
            specified by the lowest bits.
-	MT_ST_DEF_BLKSIZE
+	* MT_ST_DEF_BLKSIZE
 	   Defines the default block size set automatically. Value
 	   0xffffff means that the default is not used any more.
-	MT_ST_DEF_DENSITY
-	MT_ST_DEF_DRVBUFFER
+	* MT_ST_DEF_DENSITY, MT_ST_DEF_DRVBUFFER
 	   Used to set or clear the density (8 bits), and drive buffer
 	   state (3 bits). If the value is MT_ST_CLEAR_DEFAULT
 	   (0xfffff) the default will not be used any more. Otherwise
 	   the lowermost bits of the value contain the new value of
 	   the parameter.
-	MT_ST_DEF_COMPRESSION
+	* MT_ST_DEF_COMPRESSION
 	   The compression default will not be used if the value of
 	   the lowermost byte is 0xff. Otherwise the lowermost bit
 	   contains the new default. If the bits 8-15 are set to a
@@ -487,17 +562,17 @@ MTSETDRVBUFFER
 	   used as the compression algorithm. The value
 	   MT_ST_CLEAR_DEFAULT can be used to clear the compression
 	   default.
-	MT_ST_SET_TIMEOUT
+	* MT_ST_SET_TIMEOUT
 	   Set the normal timeout in seconds for this device. The
 	   default is 900 seconds (15 minutes). The timeout should be
 	   long enough for the retries done by the device while
 	   reading/writing.
-	MT_ST_SET_LONG_TIMEOUT
+	* MT_ST_SET_LONG_TIMEOUT
 	   Set the long timeout that is used for operations that are
 	   known to take a long time. The default is 14000 seconds
 	   (3.9 hours). For erase this value is further multiplied by
 	   eight.
-	MT_ST_SET_CLN
+	* MT_ST_SET_CLN
 	   Set the cleaning request interpretation parameters using
 	   the lowest 24 bits of the argument. The driver can set the
 	   generic status bit GMT_CLN if a cleaning request bit pattern
@@ -506,7 +581,7 @@ MTSETDRVBUFFER
 	   cleaning. The bits are device-dependent. The driver is
 	   given the number of the sense data byte (the lowest eight
 	   bits of the argument; must be >= 18 (values 1 - 17
-	   reserved) and <= the maximum requested sense data sixe), 
+	   reserved) and <= the maximum requested sense data sixe),
 	   a mask to select the relevant bits (the bits 9-16), and the
 	   bit pattern (bits 17-23). If the bit pattern is zero, one
 	   or more bits under the mask indicate cleaning request. If
@@ -518,12 +593,16 @@ MTSETDRVBUFFER
 	   MT_ST_SET_CLN.)
 
 The following ioctl uses the structure mtpos:
-MTIOCPOS Reads the current position from the drive. Uses
+
+MTIOCPOS
+	Reads the current position from the drive. Uses
         Tandberg-compatible QFA for SCSI-1 drives and the SCSI-2
         command for the SCSI-2 drives.
 
 The following ioctl uses the structure mtget to return the status:
-MTIOCGET Returns some status information.
+
+MTIOCGET
+	Returns some status information.
         The file number and block number within file are returned. The
         block is -1 when it can't be determined (e.g., after MTBSF).
         The drive type is either MTISSCSI1 or MTISSCSI2.
@@ -537,7 +616,8 @@ MTIOCGET Returns some status information.
 	end of recorded data or end of tape. GMT_EOT means end of tape.
 
 
-MISCELLANEOUS COMPILE OPTIONS
+Miscellaneous Compile Options
+=============================
 
 The recovered write errors are considered fatal if ST_RECOVERED_WRITE_FATAL
 is defined.
@@ -568,7 +648,8 @@ time or the MT_ST_CAN_BSR bit is set for the drive with an ioctl.
 user does not request data that far.)
 
 
-DEBUGGING HINTS
+Debugging Hints
+===============
 
 Debugging code is now compiled in by default but debugging is turned off
 with the kernel module parameter debug_flag defaulting to 0.  Debugging
diff --git a/MAINTAINERS b/MAINTAINERS
index f27c24d82c0f..a3bfe6813e5e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14877,7 +14877,7 @@ SCSI TAPE DRIVER
 M:	Kai Mäkisara <Kai.Makisara@kolumbus.fi>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-F:	Documentation/scsi/st.txt
+F:	Documentation/scsi/st.rst
 F:	drivers/scsi/st.*
 F:	drivers/scsi/st_*.h
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c705e2b951a4..5bde34020b3a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -94,7 +94,7 @@ config CHR_DEV_ST
 	  If you want to use a SCSI tape drive under Linux, say Y and read the
 	  SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>, and
-	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT
+	  <file:Documentation/scsi/st.rst> in the kernel source.  This is NOT
 	  for SCSI CD-ROMs.
 
 	  To compile this driver as a module, choose M here and read
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 393f3019ccac..2cff8a7349a7 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
    SCSI Tape Driver for Linux version 1.1 and newer. See the accompanying
-   file Documentation/scsi/st.txt for more information.
+   file Documentation/scsi/st.rst for more information.
 
    History:
    Rewritten from Dwayne Forsyth's SCSI tape driver by Kai Makisara.
-- 
2.21.1

