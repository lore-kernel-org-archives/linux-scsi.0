From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 00/10] zfcp updates for 2.6.36 merge window
Date: Fri, 16 Jul 2010 15:37:33 +0200
Message-ID: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:60627 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965473Ab0GPNnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

here is the series of zfcp updates for the 2.6.36 merge window. The
changes include code simplifications, cleanup, FC transport events,
experimental DIF/DIX support and logging improvements on errors.

The patches apply cleanly on top of the last series of fixes, i sent
last week:
http://marc.info/?l=linux-scsi&m=127857607617662&w=2

The last patch in the series "zfcp: Trigger logging in the FCP channel
on qdio error conditions" depends on the patch "[S390] cio: CHSC SIOSL
Support" that is already part of the linux-next tree:
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=c5a0bc55f25e0002aaed211aef533e86c9aaff2a

Christof
