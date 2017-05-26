From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1 0/4] TCMU Enable Reconfiguration Patches
Date: Fri, 26 May 2017 09:27:19 -0500
Message-ID: <1495808843-40222-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32994 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755466AbdEZO1l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 May 2017 10:27:41 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4QEOCHb133502
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 10:27:40 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2apkxx6jan-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 10:27:40 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Fri, 26 May 2017 10:27:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This patch consists of adding a netlink to allow for reconfiguration
of a device in tcmu.

It also changes and adds some attributes that are reconfigurable:
write_cache, device size, and device path.

Bryant G. Ly (4):
  tcmu: Support emulate_write_cache
  tcmu: Add netlink for device reconfiguration
  tcmu: Make dev_size configurable via userspace
  tcmu: Make dev_config configurable

 drivers/target/target_core_user.c     | 137 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/target_core_user.h |   1 +
 2 files changed, 135 insertions(+), 3 deletions(-)

-- 
2.5.4 (Apple Git-61)
