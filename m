From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 0/4] megaraid_sas: Bug fixes and improvements for 4.11-rc
Date: Fri, 10 Mar 2017 03:22:11 -0800
Message-ID: <1489144935-26567-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:34619 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933765AbdCJLWp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2017 06:22:45 -0500
Received: by mail-pg0-f49.google.com with SMTP id 77so37968404pgc.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2017 03:22:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

This patchset fixes few issues introduced during previous set of
patch submissions for 4.11

Shivasharan S (4):
  megaraid_sas: enable intx only if msix request fails
  megaraid_sas: add correct return type check for ldio hint logic for
    raid1
  megaraid_sas: raid6 also require cpuSel check same as raid5
  megaraid_sas: Driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        |  4 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 17 ++++++++++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  4 ++--
 3 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.8.3
