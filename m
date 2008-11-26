From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/6] zfcp fixes for 2.6.28-rc6
Date: Wed, 26 Nov 2008 18:07:34 +0100
Message-ID: <20081126170734.940419000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:40631 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYKZRKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 12:10:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

Busy times...

During stress testing we found some more issues in the zfcp driver.
The patches apply on top of the current linux-2.6 git tree, please
apply.

Thanks,

Christof
