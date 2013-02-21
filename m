From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/4] Drivers: scsi: storvsc
Date: Thu, 21 Feb 2013 12:04:20 -0800
Message-ID: <1361477060-17505-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

This patch set (two of the patches are being resent) fixes and enhances
the functionality of the Hyper-V storage driver

K. Y. Srinivasan (3):
  Drivers: scsi: storvsc: Initialize the sglist
  Drivers: scsi: storvsc: Restructure error handling code on command
    completion
  Drivers: scsi: storvsc: Handle dynamic resizing of the device

Olaf Hering (1):
  scsi: storvsc: avoid usage of WRITE_SAME

 drivers/scsi/storvsc_drv.c |  137 ++++++++++++++++++++++++++++++-------------
 1 files changed, 95 insertions(+), 42 deletions(-)

-- 
1.7.4.1
