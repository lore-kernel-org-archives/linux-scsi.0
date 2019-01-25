From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 0/2] scsi: trivial header search path fixups
Date: Fri, 25 Jan 2019 16:09:02 +0900
Message-ID: <1548400144-22513-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com, Hannes Reinecke <hare@suse.com>, linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

My main motivation is to get rid of crappy header search path manipulation
from Kbuild core.

Before that, I want to do as many treewide cleanups as possible.

The full work of this is available at:
git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git build-test



Masahiro Yamada (2):
  scsi: remove unneeded header search paths
  scsi: prefix header search paths with $(srctree)/

 drivers/scsi/aacraid/Makefile  | 2 --
 drivers/scsi/aic7xxx/Makefile  | 1 -
 drivers/scsi/cxgbi/Makefile    | 2 +-
 drivers/scsi/pcmcia/Makefile   | 2 +-
 drivers/scsi/smartpqi/Makefile | 1 -
 5 files changed, 2 insertions(+), 6 deletions(-)

-- 
2.7.4
