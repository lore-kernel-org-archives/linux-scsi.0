From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V4 0/4] scsi: storvsc: Properly support FC hosts
Date: Wed, 23 Dec 2015 13:15:27 -0800
Message-ID: <1450905327-9497-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Properly support FC hosts. Additional cleanup patches are also
included.

        V2: Comments from Dan Carpenter <dan.carpenter@oracle.com> and
                from Johannes Thumshirn <jthumshirn@suse.de> addressed.

        V3: Fixed build issues reported by kbuild test robot <lkp@intel.com>
	V4: Addressed comments from Hannes and James.

K. Y. Srinivasan (4):
  scsi: storvsc: Fix a bug in the layout of the hv_fc_wwn_packet
  scsi: storvsc: Properly support Fibre Channel devices
  scsi: storvsc: Refactor the code in storvsc_channel_init()
  scsi: storvsc: Tighten up the interrupt path

 drivers/scsi/storvsc_drv.c |  275 +++++++++++++++++++++++++------------------
 1 files changed, 160 insertions(+), 115 deletions(-)

-- 
1.7.4.1
