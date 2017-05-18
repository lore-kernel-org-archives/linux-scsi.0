From: Song Liu <songliubraving@fb.com>
Subject: [RFC v2 0/2] generate uevent for SCSI sense code
Date: Thu, 18 May 2017 11:14:54 -0700
Message-ID: <20170518181456.1955523-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52183 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754641AbdERSPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 14:15:07 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4IIDEhu014950
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 11:15:06 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ahf2t0djb-3
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 11:15:06 -0700
Received: from facebook.com (2401:db00:2120:20f2:face:0:9:0)    by
 mx-out.facebook.com (10.103.99.97) with ESMTP  id
 ea95937c3bf511e7a2e40002c9931860-3493b8f0 for <linux-scsi@vger.kernel.org>;
        Thu, 18 May 2017 11:15:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, James.Bottomley@HansenPartnership.com, axboe@fb.com, axboe@kernel.dk, bblock@linux.vnet.ibm.com, emilne@redhat.com, Song Liu <songliubraving@fb.com>

This change is to follow up our discussion on event log for media
management during LSF/MM 2017.

I have included feedbacks from Hannes Reinecke, Ewan D. Milne, and
Benjamin Block.

Please kindly let me know your thoughts on this.

Thanks,
Song

Song Liu (2):
  scsi: generate uevent for SCSI sense code
  scsi: add rate limit to scsi sense code uevent

 drivers/scsi/Kconfig       | 14 +++++++++++
 drivers/scsi/scsi_error.c  | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_scan.c   |  4 ++++
 drivers/scsi/scsi_sysfs.c  | 51 ++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_common.h |  6 +++++
 include/scsi/scsi_device.h | 37 ++++++++++++++++++++++++++++-
 7 files changed, 226 insertions(+), 2 deletions(-)

--
2.9.3
