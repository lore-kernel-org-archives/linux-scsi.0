From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [PATCH v2 0/2] change allow_restart, manage_start_stop to bool in
 sysfs
Date: Thu, 12 Oct 2017 14:56:15 +0800
Message-ID: <cover.1507791207.git.zhangweiping@didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 22.17.110.36.static.bjtelecom.net ([36.110.17.22]:16720 "EHLO
        BJEXCAS003.didichuxing.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750750AbdJLG4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Oct 2017 02:56:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

Changes since V1:
switch kstrtoint to kstrtobool.
add fix for manage_start_stop.

weiping zhang (2):
  scsi: sd: change allow_restart to bool in sysfs interface
  scsi: sd: change manage_start_stop to bool in sysfs interface

 drivers/scsi/sd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
2.9.4
