Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7409217306
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 20:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727901352; cv=none; b=CrWSPaWnZguBUIoZezaREj7q35yqpCLjIayAEhxcC/q2krZtwWVdHVvIGJJN9CsbVO/i+bniIO7sxPnfjoOUn3USLryFag9WYEwmkefeRmqsVgCEcZ43i5/2EgoBromNsfqQgotOCY7nNpDu1lvFmkv2SQmtJkI3839D8zJf1os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727901352; c=relaxed/simple;
	bh=gUJMRrpgsIfjBWGyXH7lY17khB0zLXGRAUVVrJuHot4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pz/4LhaYDSMIBhnZGBcDeeQwPqZKKSASMiKZjKIIqFLoFMxiIZ7sqDAra10dtbUMohdolR7cIL17vfIM8+7FJAc0Mwqo/dvfgr5dQuBCagTXW031+m6vvh4JvDHgOsnWKz3E+xJptv0O00cNJnTyc9FqGyQARUNh0mErEtQTBk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=I7d1A8/f; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="I7d1A8/f"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJmm61MBtzlgMWB;
	Wed,  2 Oct 2024 20:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1727901347; x=1730493348; bh=OaRvv
	NDL9ZHE5oZ9Typot3CJVACz662PkqYVyW+cGdA=; b=I7d1A8/fHJu5e7FLWaO+r
	sARHFh8vjFffi1zSvPq7Y90rvwsJovo7XK7ulPPhczxoWfQNMoGd9FqONL/kvSTA
	6vp2H63iBn3FF/eA2Lp0mLv3xiTPNSwgIoJSMwFhao1zs8djm/bpeK1j0r0P4eeL
	0lCR4DXN+ttqp8RSHuhOtyAFaak3tnjnCQ2WJDUEuZ2LGkBZCw6mlVIfXKS5Cnk3
	qWN33YkpcZOv9/opkkppvAtkIbx0T1VG/h2KyjB7GtbB+KCdBNq7XYT/WzjHwsQ6
	Lp62PRVD9lJNyCoehec2a/dt+Slmi/eVLfWwmm1bgxkldwLgSnCGgZ65k0Fo74EC
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9kxZ05Raqaia; Wed,  2 Oct 2024 20:35:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJmm26yZnzlgMW9;
	Wed,  2 Oct 2024 20:35:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2 02/11] scsi: ips: Remove the changelog
Date: Wed,  2 Oct 2024 13:33:54 -0700
Message-ID: <20241002203528.4104996-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
In-Reply-To: <20241002203528.4104996-1-bvanassche@acm.org>
References: <20241002203528.4104996-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Since we typically do not maintain changelogs as text files in the Linux
kernel, and since the ips changelog has not been updated since 2002, remo=
ve
it.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/ChangeLog.ips | 122 -------------------------------
 1 file changed, 122 deletions(-)
 delete mode 100644 Documentation/scsi/ChangeLog.ips

diff --git a/Documentation/scsi/ChangeLog.ips b/Documentation/scsi/Change=
Log.ips
deleted file mode 100644
index 5019f5182bf4..000000000000
--- a/Documentation/scsi/ChangeLog.ips
+++ /dev/null
@@ -1,122 +0,0 @@
-IBM ServeRAID driver Change Log
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-        5.00.01  - Sarasota ( 5i ) adapters must always be scanned first=
 =20
-                 - Get rid on IOCTL_NEW_COMMAND code =20
-                 - Add Extended DCDB Commands for Tape Support in 5I    =
             =20
-       =20
-        4.90.11  - Don't actually RESET unless it's physically required
-                 - Remove unused compile options
-       =20
-        4.90.08  - Data Corruption if First Scatter Gather Element is > =
64K
-       =20
-        4.90.08  - Increase Delays in Flashing ( Trombone Only - 4H )   =
    =20
-       =20
-        4.90.05  - Use New PCI Architecture to facilitate Hot Plug Devel=
opment
-       =20
-        4.90.01  - Add ServeRAID Version Checking
-
-        4.80.26  - Clean up potential code problems ( Arjan's recommenda=
tions )
-       =20
-        4.80.21  - Change memcpy() to copy_to_user() in NVRAM Page 5 IOC=
TL path  =20
-       =20
-        4.80.20  - Set max_sectors in Scsi_Host structure ( if >=3D 2.4.=
7 kernel )
-                 - 5 second delay needed after resetting an i960 adapter
-       =20
-        4.80.14  - Take all semaphores off stack                   =20
-                 - Clean Up New_IOCTL path
-                  =20
-        4.80.04  - Eliminate calls to strtok() if 2.4.x or greater=20
-                 - Adjustments to Device Queue Depth              =20
-
-        4.80.00  - Make ia64 Safe   =20
-       =20
-        4.72.01  - I/O Mapped Memory release ( so "insmod ips" does not =
Fail )   =20
-                 - Don't Issue Internal FFDC Command if there are Active=
 Commands=20
-                 - Close Window for getting too many IOCTL's active=20
-                  =20
-        4.72.00  - Allow for a Scatter-Gather Element to exceed MAX_XFER=
 Size    =20
-       =20
-        4.71.00  - Change all memory allocations to not use GFP_DMA flag=
=20
-                 - Code Clean-Up for 2.4.x kernel     =20
-       =20
-        4.70.15  - Fix Breakup for very large ( non-SG ) requests
-       =20
-        4.70.13  - Don't release HA Lock in ips_next() until SC taken of=
f queue =20
-                 - Unregister SCSI device in ips_release()              =
         =20
-                 - Don't Send CDB's if we already know the device is not=
 present =20
-                =20
-        4.70.12  - Corrective actions for bad controller ( during initia=
lization )
-       =20
-        4.70.09  - Use a Common ( Large Buffer ) for Flashing from the J=
CRM CD   =20
-                 - Add IPSSEND Flash Support                            =
         =20
-                 - Set Sense Data for Unknown SCSI Command              =
         =20
-                 - Use Slot Number from NVRAM Page 5=20
-                 - Restore caller's DCDB Structure
-                                      =20
-        4.20.14  - Update patch files for kernel 2.4.0-test5
-
-        4.20.13  - Fix some failure cases / reset code
-                 - Hook into the reboot_notifier to flush the controller
-                   cache
-
-        4.20.03 - Rename version to coincide with new release schedules
-                - Performance fixes
-                - Fix truncation of /proc files with cat
-                - Merge in changes through kernel 2.4.0test1ac21
-
-        4.10.13 - Fix for dynamic unload and proc file system
-
-        4.10.00 - Add support for ServeRAID 4M/4L
-
-        4.00.06 - Fix timeout with initial FFDC command
-
-        4.00.05 - Remove wish_block from init routine
-                - Use linux/spinlock.h instead of asm/spinlock.h for ker=
nels
-                  2.3.18 and later
-                - Sync with other changes from the 2.3 kernels
-
-        4.00.04 - Rename structures/constants to be prefixed with IPS_
-
-        4.00.03 - Add alternative passthru interface
-                - Add ability to flash ServeRAID BIOS
-
-        4.00.02 - Fix problem with PT DCDB with no buffer
-
-        4.00.01 - Add support for First Failure Data Capture
-
-        4.00.00 - Add support for ServeRAID 4
-
-        3.60.02 - Make DCDB direction based on lookup table.
-                - Only allow one DCDB command to a SCSI ID at a time.
-
-        3.60.01 - Remove bogus error check in passthru routine.
-
-        3.60.00 - Bump max commands to 128 for use with ServeRAID
-                  firmware 3.60.
-                - Change version to 3.60 to coincide with ServeRAID rele=
ase
-                  numbering.
-
-        1.00.00 - Initial Public Release
-                - Functionally equivalent to 0.99.05
-
-        0.99.05 - Fix an oops on certain passthru commands
-
-        0.99.04 - Fix race condition in the passthru mechanism
-                  -- this required the interface to the utilities to cha=
nge
-                - Fix error recovery code
-
-        0.99.03 - Make interrupt routine handle all completed request on=
 the
-                  adapter not just the first one
-                - Make sure passthru commands get woken up if we run out=
 of
-                  SCBs
-                - Send all of the commands on the queue at once rather t=
han
-                  one at a time since the card will support it.
-
-        0.99.02 - Added some additional debug statements to print out
-                  errors if an error occurs while trying to read/write
-                  to a logical drive (IPS_DEBUG).
-
-                - Fixed read/write errors when the adapter is using an
-                  8K stripe size.
-
