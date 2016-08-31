From: Joe Perches <joe@perches.com>
Subject: [PATCH 0/2] Remove last use and references to DEFINE_PCI_DEVICE_TABLE
Date: Wed, 31 Aug 2016 09:19:27 -0700
Message-ID: <cover.1472660229.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:34382 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935056AbcHaQTf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 12:19:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jonathan Corbet <corbet@lwn.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Whitcroft <apw@canonical.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Joe Perches (2):
  wd719x: Remove last declaration using DEFINE_PCI_DEVICE_TABLE
  treewide: Remove references to the now unnecessary DEFINE_PCI_DEVICE_TABLE

 Documentation/PCI/pci.txt | 1 -
 drivers/scsi/wd719x.c     | 2 +-
 include/linux/pci.h       | 9 ---------
 scripts/checkpatch.pl     | 9 ---------
 scripts/tags.sh           | 1 -
 5 files changed, 1 insertion(+), 21 deletions(-)

-- 
2.10.0.rc2.1.gb2aa91d

