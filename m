From: Song Liu <songliubraving@fb.com>
Subject: [RFC] generate uevent for SCSI sense code
Date: Wed, 3 May 2017 17:50:12 -0700
Message-ID: <20170504005013.2865393-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58007 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752477AbdEDAu3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 20:50:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v440nN98016032
        for <linux-scsi@vger.kernel.org>; Wed, 3 May 2017 17:50:28 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2a7s5785ar-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 03 May 2017 17:50:28 -0700
Received: from facebook.com (2401:db00:2120:20f2:face:0:9:0)    by
 mx-out.facebook.com (10.212.232.59) with ESMTP id
 aa32d8c8306311e7b6860002c991e86a-4bfef9a0 for <linux-scsi@vger.kernel.org>;
        Wed, 03 May 2017 17:50:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, James.Bottomley@HansenPartnership.com, axboe@fb.com, Song Liu <songliubraving@fb.com>, axboe@kernel.dk

This change is to follow up our discussion on event log for media
management during LSF/MM 2017.

Please kindly let me know your thoughts on this.

Thanks,
Song


Song Liu (1):
  scsi: generate uevent for SCSI sense code

 drivers/scsi/Kconfig       | 14 +++++++++++
 drivers/scsi/scsi_error.c  | 26 ++++++++++++++++++++
 drivers/scsi/scsi_lib.c    | 27 +++++++++++++++++++--
 drivers/scsi/scsi_sysfs.c  | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h | 26 +++++++++++++++++++-
 5 files changed, 150 insertions(+), 3 deletions(-)

--
2.9.3
