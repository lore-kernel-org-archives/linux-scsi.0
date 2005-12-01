From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [patch 0/4] zfcp bug fixes
Date: Thu, 1 Dec 2005 02:42:03 +0100
Message-ID: <20051201014203.GA13023@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:30141 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751614AbVLABnQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 20:43:16 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id jB11hKec214012
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 01:43:20 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jB11hF9Z232670
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:43:15 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id jB11hE55004348
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:43:15 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

I have a couple of bug fixes for zfcp.
Don't know whether it is too late to get them into 2.6.15.

In any case they are built against 2.6.15-rc3.

Regards,

Andreas
