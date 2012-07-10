From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH RESUBMIT 0/3] remove unnecessary read of PCI_CAP_ID_EXP
Date: Tue, 10 Jul 2012 14:57:54 -0700
Message-ID: <1341957477-30946-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2GJV5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jul 2012 17:57:30 -0400
Received: by pbbrp8 with SMTP id rp8so887639pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jul 2012 14:57:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

This is a resubmission of 3 of 19 patches from ~1 year ago.  The rest were
integrated by the other subsystem maintainers at the time.  I believe the
hiccup was some confusion as to whether this would cause an issue on PPC
(http://www.spinics.net/lists/linux-scsi/msg53079.html).  However, this was
later refuted (https://patchwork.kernel.org/patch/937012/) and was ack'ed
(http://www.spinics.net/lists/linux-scsi/msg53169.html).

I recently found these collecting dust and would appreciate them being included.

Thanks,
Jon

