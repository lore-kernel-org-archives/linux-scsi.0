From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/4] scsi: storvsc: Properly support FC hosts
Date: Sat, 12 Dec 2015 13:53:11 -0800
Message-ID: <1449957191-9232-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Properly support FC hosts. Additional cleanup patches are also
included.

In this version I have adddressed comments from
Dan Carpenter <dan.carpenter@oracle.com> and
from Johannes Thumshirn <jthumshirn@suse.de>.

K. Y. Srinivasan (4):
  scsi: storvsc: Fix a bug in the layout of the hv_fc_wwn_packet
  scsi: storvsc: Properly support Fibre Channel devices
  scsi: storvsc: Refactor the code in storvsc_channel_init()
  scsi: storvsc: Tighten up the interrupt path

 drivers/scsi/storvsc_drv.c |  256 ++++++++++++++++++++++++--------------------
 1 files changed, 141 insertions(+), 115 deletions(-)

-- 
1.7.4.1
