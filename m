From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 0/6] zfcp: driver update
Date: Mon, 18 Sep 2006 22:27:25 +0200
Message-ID: <20060918202725.GA10470@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:14035 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S964918AbWIRUcL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 16:32:11 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.8/8.13.8) with ESMTP id k8IKWAxN056042
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 20:32:10 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8IKasp02588744
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:36:54 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8IKW9It013477
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:32:09 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

this is probably the last patch series for zfcp that I send out.
Mostly bug fixes and cleanups.
Patches are against current linux-2.6 git tree and should be
added to the next kernel release.


Regards,

Andreas
