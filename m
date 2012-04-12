From: Lin Ming <ming.m.lin@intel.com>
Subject: [RESEND PATCH 0/2]: Use correct DMA device in SCSI/libata
Date: Thu, 12 Apr 2012 13:50:37 +0800
Message-ID: <1334209839-21978-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>, Jeff Garzik <jgarzik@redhat.com>, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

RESEND: add Jeff's ACK.

These 2 patches fix bug report at:

http://marc.info/?l=linux-ide&m=133177818318187&w=2

Please see the patches for more detail.

[PATCH 1/2] [SCSI] scsi_lib: use correct DMA device in __scsi_alloc_queue
[PATCH 2/2] libata: Pass correct DMA device to scsi host

 drivers/ata/libata-scsi.c |    3 ++-
 drivers/scsi/scsi_lib.c   |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

Thanks,
Lin Ming
