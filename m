From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/2] generate uevent for SCSI sense code
Date: Fri, 21 Jul 2017 15:57:30 -0700
Message-ID: <20170721225732.311745-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49960 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754899AbdGUW5k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jul 2017 18:57:40 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6LMvdMH000566
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2017 15:57:40 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2burpbrdtt-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2017 15:57:40 -0700
Received: from facebook.com (2401:db00:2120:20f2:face:0:9:0)    by
 mx-out.facebook.com (10.103.99.99) with ESMTP  id
 fe2534486e6711e7a5c10002c9dfb610-3ad08150 for <linux-scsi@vger.kernel.org>;
        Fri, 21 Jul 2017 15:57:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, James.Bottomley@HansenPartnership.com, axboe@fb.com, axboe@kernel.dk, bblock@linux.vnet.ibm.com, emilne@redhat.com, jthumshirn@suse.de, Song Liu <songliubraving@fb.com>

This change is to follow up our discussion on event log for media
management during LSF/MM 2017.

Changes from RFC v3:
  Incorporate feedback by Johannes Thumshirn

Thanks,
Song

Song Liu (2):
  scsi: generate uevent for SCSI sense code
  scsi: add rate limit to scsi sense code uevent

 drivers/scsi/Kconfig       | 14 +++++++++++
 drivers/scsi/hosts.c       |  4 ++++
 drivers/scsi/scsi_error.c  | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c  | 51 ++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_common.h |  6 +++++
 include/scsi/scsi_device.h | 27 ++++++++++++++++++++-
 include/scsi/scsi_host.h   | 13 +++++++++++
 8 files changed, 229 insertions(+), 2 deletions(-)

--
2.9.3
