From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 0/5] Feature enhancements for ses module
Date: Mon, 25 Aug 2014 17:34:36 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBC4ABA5@PRN-MBX02-4.TheFacebook.com>
References: <1408987546-2418-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31591 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756289AbaHYRem convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 13:34:42 -0400
In-Reply-To: <1408987546-2418-1-git-send-email-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@fb.com>

From: Song Liu [mailto:songliubraving@fb.com] 
Sent: Monday, August 25, 2014 10:26 AM
To: Song Liu
Subject: [PATCH 0/5] Feature enhancements for ses module

These patches include a few enhancements to ses module:

1: close potential race condition by at enclosure race condition

2,3,4: add enclosure id and device slot, so we can create symlink
       in /dev/disk/by-slot:
  # ls -d /dev/disk/by-slot/*
    /dev/disk/by-slot/enclosure-0x5000ae41fc1310ff-slot0

5: add ability to power on/off device with power_status file in
   sysfs.

Dan Williams (4):
  SES: close potential registration race
  SES: generate KOBJ_CHANGE on enclosure attach
  SES: add enclosure logical id
  SES: add reliable slot attribute

Song Liu (1):
  SES: Add power_status to SES enclosure component

 drivers/misc/enclosure.c  |  98 +++++++++++++++++++++++++++----
 drivers/scsi/ses.c        | 145 +++++++++++++++++++++++++++++++++++++++-------
 include/linux/enclosure.h |  13 ++++-
 3 files changed, 220 insertions(+), 36 deletions(-)

-- 
1.8.1

