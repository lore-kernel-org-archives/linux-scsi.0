From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 0/4] scsi: ufs: TM, fatal-error handling and other fixes
Date: Wed, 14 Aug 2013 22:40:08 +0530
Message-ID: <1376500212-29572-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33689 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760064Ab3HNRKi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2013 13:10:38 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo5so9484317pbc.23
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2013 10:10:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Hi James,

Please merge the following patches to 'misc' branch.
The patches depend on http://thread.gmane.org/gmane.linux.scsi/83565
patch series.

Thanks,
Santosh


Sujit Reddy Thumma (4):
  scsi: ufs: Fix broken task management command implementation
  scsi: ufs: Fix hardware race conditions while aborting a command
  scsi: ufs: Fix device and host reset methods
  scsi: ufs: Improve UFS fatal error handling

 drivers/scsi/ufs/ufshcd.c | 684 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |  20 +-
 2 files changed, 501 insertions(+), 203 deletions(-)

-- 
1.8.3.4

