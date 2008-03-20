From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.25-rc6
Date: Thu, 20 Mar 2008 12:01:39 -0500
Message-ID: <1206032499.3038.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757929AbYCTRB4@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is basically a round of small bug fixes.  The patch is available
here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Akinobu Mita (1):
      a100u2w: fix bitmap lookup routine

Boaz Harrosh (1):
      isd200: Allocate sense_buffer for hacked up scsi_cmnd

James Bottomley (1):
      Fix dependency problems in SCSI drivers

Kay Sievers (2):
      fix media change events for polled devices
      sd, sr: do not emit change event at device add

Matthew Wilcox (1):
      advansys: Fix bug in AdvLoadMicrocode

Mike Christie (1):
      fix bsg queue oops with iscsi logout

Prakash, Sathya (1):
      mpt fusion: Power Management fixes for MPT SAS PCI-E controllers

Sven Schnelle (1):
      gdth: Allocate sense_buffer to prevent NULL pointer dereference

nickcheng (1):
      arcmsr: fix iounmap error for Type B adapter


And the diffstat:

 drivers/message/fusion/mptbase.c  |  276 +++++++++++++++++++++-----------------
 drivers/message/fusion/mptscsih.c |   11 +
 drivers/scsi/Kconfig              |    2 
 drivers/scsi/a100u2w.c            |    9 -
 drivers/scsi/advansys.c           |    2 
 drivers/scsi/arcmsr/arcmsr.h      |   14 -
 drivers/scsi/gdth.c               |    7 
 drivers/scsi/scsi_lib.c           |    5 
 drivers/scsi/scsi_sysfs.c         |    2 
 drivers/scsi/sd.c                 |    1 
 drivers/scsi/sr.c                 |    1 
 drivers/usb/storage/isd200.c      |    5 
 12 files changed, 199 insertions(+), 136 deletions(-)

James
