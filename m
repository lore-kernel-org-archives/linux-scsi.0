From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 0/4] constify scsi/tty parisc_device_id
Date: Sat, 19 Aug 2017 23:24:19 +0530
Message-ID: <1503165261-31741-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-parisc-owner@vger.kernel.org>
Sender: linux-parisc-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, deller@gmx.de, gregkh@linuxfoundation.org, jslaby@suse.com
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

parisc_device_id are not supposed to change at runtime. All functions
working with parisc_device_id provided by <asm/parisc-device.h> work with
const parisc_device_id. So mark the non-const structs as const.

Arvind Yadav (4):
  [PATCH 1/4] scsi: lasi700: constify parisc_device_id
  [PATCH 2/4] scsi: zalon: constify parisc_device_id
  [PATCH 3/4] tty: 8250: constify parisc_device_id
  [PATCH 4/4] tty: mux: constify parisc_device_id

 drivers/scsi/lasi700.c             | 2 +-
 drivers/scsi/zalon.c               | 2 +-
 drivers/tty/serial/8250/8250_gsc.c | 4 ++--
 drivers/tty/serial/mux.c           | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.7.4

