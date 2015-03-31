From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] libata: ZAC SATL implementation
Date: Tue, 31 Mar 2015 10:52:40 +0200
Message-ID: <1427791963-90832-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

this patchset implements support for the new ZAC commands
'ZBC IN' and 'ZBC OUT', aka 'REPORT ZONES' and 'RESET WRITE POINTER'.
And some additional support bits for host-aware ZAC drives.

Hannes Reinecke (3):
  libata: implement ZBC IN translation
  libata: Implement ZBC OUT translation
  libata: support host-aware ZAC devices

 drivers/ata/libata-core.c     |  17 +++
 drivers/ata/libata-eh.c       |   2 +
 drivers/ata/libata-scsi.c     | 252 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/ata.h           |  16 +++
 include/linux/libata.h        |   1 +
 include/scsi/scsi.h           |   9 ++
 include/trace/events/libata.h |   2 +
 7 files changed, 293 insertions(+), 6 deletions(-)

-- 
1.8.5.2

