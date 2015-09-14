From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: [Bugfix 0/3] Convert eata driver to a normal PCI device driver
Date: Mon, 14 Sep 2015 11:08:56 +0800
Message-ID: <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Authur,
	As suggested by Bjorn, patch 1-2 set implement a PCI device
driver to manage eata PCI devices. And patch 3 tries to support PCI
device hot-removal for eata, but I have no change to test due to 
limited knowledge about scsi subsystem and lacking of hardware for
tests.
	So you could please help to test patch 1-2? Patch 3 is just
for comments.
Thanks!
Gerry

Jiang Liu (3):
  eata: Use IDA to manage eata board IDs
  eata: Implement PCI driver to manage eata PCI devices
  eata: Enhance eata driver to support PCI device hot-removal

 drivers/scsi/eata.c |  232 +++++++++++++++++++++++++++------------------------
 1 file changed, 125 insertions(+), 107 deletions(-)

-- 
1.7.10.4
