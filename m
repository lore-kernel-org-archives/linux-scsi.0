From: James.Smart@Emulex.Com
Subject: [Announce] Emulex lpfcdriver v8.0.11 available
Date: Wed, 8 Sep 2004 19:34:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F1AC@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64745 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S269212AbUIHXfA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Sep 2004 19:35:00 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i88NYwgI017783
	for <linux-scsi@vger.kernel.org>; Wed, 8 Sep 2004 16:34:58 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Christoph,

FYI - the 8.0.11 lpfc driver has been posted to SourceForge.

Per your last comments:
- The clock/timer handling should be finally resolved.
- Much rework on the parameters has been done. Should be far more in line with your expectations.
- Removed the manipulation of the mid-layer's i/o timer. Cleared out heartbeat i/o timer logic.
- Removed all vestiges of persistent bindings.  FC transport patch for consistent bindings coming w/ next driver drop.
- Corrected decode of scsi lun value for Level 1 VSA support.

Todos:
- Sync with midlayer block/unblock patch
- Add calls to scan functions on new device detection, remove_device on device loss.
- Add interfaces to support managability. Will be building upon James B's last patches on creating scsi_target, and putting transport attributes on the scsi_target. Will also be adding Emulex-specific sysfs functions.
- streamline I/O submission path
- sort out memory allocation issues

Thanks

-- James S


The tarball is here:
http://prdownloads.sourceforge.net/lpfcxxxx/lpfcdriver-2.6-8.0.11.tar.gz?download

The full ChangeLog is on SourceForge:
https://sourceforge.net/forum/forum.php?forum_id=405703

