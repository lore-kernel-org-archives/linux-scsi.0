From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  0/2] qla2xxx: Patches for 4.3.0-rc5+ scsi "misc" branch.
Date: Wed, 14 Oct 2015 11:57:39 -0400
Message-ID: <1444838261-20990-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:10419 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbbJNQgL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 12:36:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@lst.de
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James, Christoph,

Please apply the following patches to the scsi tree, misc branch  at your
earliest convenience.

Thanks,
-Himanshu

Himanshu Madhani (2):
  qla2xxx: Remove unavailable firmware files
  qla2xxx: fix rwlock recursion

 drivers/scsi/qla2xxx/qla_nx.c |   58 ++++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_os.c |   29 --------------------
 2 files changed, 29 insertions(+), 58 deletions(-)

-- 
1.7.7

