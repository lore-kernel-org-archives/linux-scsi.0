From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/3] scsi: Some miscellaneous fixes
Date: Thu, 17 Sep 2015 15:28:58 -0700
Message-ID: <1442528938-3252-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Some miscellaneous fixes.

K. Y. Srinivasan (1):
  storvsc: Don't set the SRB_FLAGS_QUEUE_ACTION_ENABLE flag

Vitaly Kuznetsov (2):
  scsi_scan: don't dump trace when scsi_prep_async_scan() is called
    twice
  scsi: introduce short_inquiry flag for broken host adapters

 drivers/scsi/scsi_scan.c   |   10 +++++-----
 drivers/scsi/storvsc_drv.c |    4 ++--
 include/scsi/scsi_host.h   |    6 ++++++
 3 files changed, 13 insertions(+), 7 deletions(-)

-- 
1.7.4.1
