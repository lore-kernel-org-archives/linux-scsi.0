From: Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2 0/3] ibmvscsi parameter cleanup
Date: Wed,  4 Nov 2015 11:20:48 +0100
Message-ID: <1446632451-22365-1-git-send-email-lvivier@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lvivier@redhat.com
List-Id: linux-scsi@vger.kernel.org

v2 of this series only fix the format type of max_lun:

drivers/scsi/ibmvscsi/ibmvscsi.c:2298:4: 
warning: format '%d' expects argument of type 'int',
but argument 4 has type 'u64 {aka long long unsigned int}' [-Wformat=]
       "Maximum ID: %d Maximum LUN: %d Maximum Channel: %d\n",
       ^

Laurent Vivier (3):
  ibmvscsi: make parameters max_id and max_channel read-only
  ibmvscsi: display default value for max_id, max_lun and max_channel.
  ibmvscsi: Allow to configure maximum LUN

 drivers/scsi/ibmvscsi/ibmvscsi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

-- 
2.1.0
