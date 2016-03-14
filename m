From: Arnd Bergmann <arnd@arndb.de>
Subject: gcc-6.0 warnings for scsi
Date: Mon, 14 Mar 2016 15:29:42 +0100
Message-ID: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:58776 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864AbcCNOaF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 10:30:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

gcc-6 found a couple of bugs in scsi drivers that are not
yet fixed in linux-next.

In all three cases, the code is indented in a rather misleading
way, but actually correct. I think it would be good to have
this fixed in 4.6, but no backports are needed even though
the problems have all been around for a while.

