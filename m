From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH 0/3] block layer runtime pm
Date: Tue, 15 May 2012 16:48:14 +0800
Message-ID: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

In August 2010, Jens and Alan discussed about "Runtime PM and the block
layer". http://marc.info/?t=128259108400001&r=1&w=2

Here are the very draft, compile tested only patches that try to
implement the ideas discussed.

I throw it out early to get feedbacks and see if I'm on the right
direction.

Lin Ming (3):
      block: add a flag to identify PM request
      block: add queue runtime pm callback
      block: add queue idle timer

 block/blk-core.c           |   25 +++++++++++++++++++++++
 block/blk-settings.c       |    6 +++++
 block/elevator.c           |   10 +++++++++
 drivers/scsi/scsi_lib.c    |   25 ++++++++++++++++++++--
 drivers/scsi/sd.c          |   47 +++++++++++++++++++++++++++++++++++++------
 include/linux/blk_types.h  |    2 +
 include/linux/blkdev.h     |    8 +++++++
 include/scsi/scsi_device.h |    4 +++
 8 files changed, 117 insertions(+), 10 deletions(-)
