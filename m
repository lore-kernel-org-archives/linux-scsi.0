From: James.Smart@Emulex.Com
Subject: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Mon, 20 Sep 2004 21:34:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F1C6@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:15266 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267452AbUIUBed convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 21:34:33 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i8L1YSgI014790
	for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2004 18:34:28 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com

Christoph,

FYI - the 8.0.12 lpfc driver has been posted to SourceForge.

The driver contains the following changes (refer to the ChangeLog for more detail):
- Incorporated the ~9 patches received from you.
- The discovery code was reworked for better organization. Came about as part of supporting the block/unblock patch.
- Started to add management interfaces (used to be ioctls) to sysfs. This is a WIP and quite a few things are expected to ultimately be moved to the fc transport under a separate RFC/patch.

Thanks.

-- James S


The tarball is here:
http://prdownloads.sourceforge.net/lpfcxxxx/lpfcdriver-2.6-8.0.12.tar.gz?download

The full ChangeLog is on SourceForge:
http://sourceforge.net/forum/forum.php?forum_id=408568

