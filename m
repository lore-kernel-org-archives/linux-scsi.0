From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/2] UFS driver fixes for v3.18
Date: Tue, 18 Nov 2014 23:02:44 +0900
Message-ID: <1416319366-11539-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53745 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaKRODJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Nov 2014 09:03:09 -0500
Received: by mail-pd0-f175.google.com with SMTP id y10so4636690pdj.6
        for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2014 06:03:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

This patch series includes two fixes for UFS driver.

The first patch already got reviewed and it was a part of Dolev's various
fixes for UFS-PM series (http://marc.info/?l=linux-scsi&m=141405993104015),
but they are not merged scsi-queue yet.  So this series also includes it.

The second one is a fix which I have already reported and Dolev agreed
with that in http://marc.info/?l=linux-scsi&m=141164131404767

Akinobu Mita (2):
  scsi: ufs: fix reference counting of W-LUs
  scsi: ufs: fix NULL dereference when no regulators are defined

 drivers/scsi/ufs/ufshcd.c | 80 +++++++++++++++++++++++++----------------------
 drivers/scsi/ufs/ufshcd.h |  2 --
 2 files changed, 42 insertions(+), 40 deletions(-)

Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
-- 
1.9.1

