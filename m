From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/5] zfcp fixes for 2.6.32-rc4
Date: Tue, 13 Oct 2009 10:44:06 +0200
Message-ID: <20091013084406.630890000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:53640 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933801AbZJMIuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 04:50:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

here is the (hopefully) last round of zfcp fixes for the 2.6.32 cycle.
The largest change is a fix for zfcp to handle storage devices that
return a wrong wwpn in the plogi payload. The patches apply on the
current linux-2.6 git tree (-rc4 + )

--
Christof Schmitt
