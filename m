From: Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v4 0/3] ibmvscsi parameter cleanup
Date: Mon,  9 Nov 2015 15:47:42 +0100
Message-ID: <1447080465-17858-1-git-send-email-lvivier@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: hare@suse.de, brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lvivier@redhat.com
List-Id: linux-scsi@vger.kernel.org

v4 udpates 3/3 description
   max_lun can be less or equal to 32

v3 checks that max_lun is less or equal to 31

v2 of this series only fix the format type of max_lun:

drivers/scsi/ibmvscsi/ibmvscsi.c:2298:4:
warning: format '%d' expects argument of type 'int',
but argument 4 has type 'u64 {aka long long unsigned int}' [-Wformat=]
       "Maximum ID: %d Maximum LUN: %d Maximum Channel: %d\n",

Laurent Vivier (3):
  ibmvscsi: make parameters max_id and max_channel read-only
  ibmvscsi: display default value for max_id, max_lun and max_channel.
  ibmvscsi: Allow to configure maximum LUN

 drivers/scsi/ibmvscsi/ibmvscsi.c | 21 ++++++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvscsi.h |  1 +
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.1.0
