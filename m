From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/2] scsi: storvsc: Miscellaneous fixes
Date: Wed, 27 Jan 2016 18:22:19 -0800
Message-ID: <1453947739-28725-1-git-send-email-kys@microsoft.com>
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

Some miscellaneous fixes.

V2: addressed comments from Hannes Reinecke <hare@suse.de>

K. Y. Srinivasan (2):
  scsi: storvsc: Install the storvsc specific timeout handler for FC
    devices
  scsi: storvsc: Use the specified target ID in device lookup

 drivers/scsi/storvsc_drv.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

-- 
1.7.4.1
