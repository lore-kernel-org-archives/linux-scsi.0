From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V3 0/4] scsi: storvsc: Properly support FC hosts
Date: Sun, 13 Dec 2015 12:28:06 -0800
Message-ID: <1450038486-19211-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Properly support FC hosts. Additional cleanup patches are also
included.

	V2: Comments from Dan Carpenter <dan.carpenter@oracle.com> and
		from Johannes Thumshirn <jthumshirn@suse.de> addressed.

	V3: Fixed build issues reported by kbuild test robot <lkp@intel.com>

K. Y. Srinivasan (4):
  scsi: storvsc: Fix a bug in the layout of the hv_fc_wwn_packet
  scsi: storvsc: Properly support Fibre Channel devices
  scsi: storvsc: Refactor the code in storvsc_channel_init()
  scsi: storvsc: Tighten up the interrupt path

 drivers/scsi/storvsc_drv.c |  275 +++++++++++++++++++++++++------------------
 1 files changed, 160 insertions(+), 115 deletions(-)

-- 
1.7.4.1
