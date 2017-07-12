From: Song Liu <songliubraving@fb.com>
Subject: [RFC v3 0/2] generate uevent for SCSI sense code
Date: Wed, 12 Jul 2017 15:35:33 -0700
Message-ID: <20170712223535.2609814-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53601 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751036AbdGLWfm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Jul 2017 18:35:42 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6CMWktG016310
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2017 15:35:41 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2bnu86r9ay-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2017 15:35:41 -0700
Received: from facebook.com (2401:db00:2120:20f2:face:0:9:0)    by
 mx-out.facebook.com (2401:db00:2050:5102:face:0000:003b:0000) with ESMTP       id
 6e4a97d0675211e79a1f6f8865c8440f-6becf150 for <linux-scsi@vger.kernel.org>;
        Wed, 12 Jul 2017 15:35:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, James.Bottomley@HansenPartnership.com, axboe@fb.com, axboe@kernel.dk, bblock@linux.vnet.ibm.com, emilne@redhat.com, Song Liu <songliubraving@fb.com>

This change is to follow up our discussion on event log for media
management during LSF/MM 2017.

Changes from RFC v2:
1. change rate limit of events from per device to per SCSI host
2. fix bugs from feedbacks

Please kindly let me know your thoughts on this.

Thanks,
Song

Song Liu (2):
  scsi: generate uevent for SCSI sense code
  scsi: add rate limit to scsi sense code uevent

 drivers/scsi/Kconfig       | 14 +++++++++++
 drivers/scsi/hosts.c       |  4 ++++
 drivers/scsi/scsi_error.c  | 59 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c    | 58 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c  | 51 +++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_common.h |  6 +++++
 include/scsi/scsi_device.h | 27 ++++++++++++++++++++-
 include/scsi/scsi_host.h   | 13 ++++++++++
 8 files changed, 230 insertions(+), 2 deletions(-)

--
2.9.3
