From: James.Smart@Emulex.Com
Subject: [Announce] Emulex lpfcdriver v8.0.9 available
Date: Mon, 16 Aug 2004 16:07:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F164@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:2521 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S267934AbUHPUHx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 16:07:53 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i7GK7qgI016967
	for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2004 13:07:52 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Christoph,

We posted the 8.0.9 lpfc driver on SourceForge last week. 

Of the more notable changes that have occurred over the last few drops:
- Applied Christoph's patches for proc info, memory allocation routines, and bld_scsi_cmd dead code.
- Removed lun handling. Removed code that replicated midlayer functions, issued report luns, did partial VSA, had unnecessary data structures, etc.
- Reworked the clock/timer handling per Christoph's comments.
- Reworked driver parameters per Christoph's comments.
- Use the SCSI host lock instead of our own adapter lock
- Fixed the reset_bus and reset_device routines. Send "Reset LUN" for reset_device requests.
- More cleanup: condensing routines, removing casts and dead code, etc.

The ChangeLogs have more detail.

To date, the known todos are:
- Use mid-layer I/O timers
- No Peeking into timer structures
- Need to get approvals on all the clock changes, parameter changes, etc.
- Add calls to scan functions on new device detection, remove_device on device loss.
- Add interfaces to support managability.

Thanks

-- James S


The tarball is here:
http://prdownloads.sourceforge.net/lpfcxxxx/lpfcdriver-2.6-8.0.9.tar.gz?download

The full ChangeLog is on SourceForge:
http://sourceforge.net/forum/forum.php?forum_id=398596

