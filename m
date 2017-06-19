From: Christoph Hellwig <hch@lst.de>
Subject: TCG Opal support for sd.c
Date: Mon, 19 Jun 2017 14:26:45 +0200
Message-ID: <20170619122646.32666-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

this patch adds TCG Opal support to the scsi disk driver.  As far as I know
only SATA disks actually support OPAL, and as Martin fears RSOC-related
regressions the support is conditional in a flag in struct scsi_device,
which so far only libata sets.

Because of that we should merge the patch through the libata tree with ACKs
from the SCSI side.

Changes from the previous version:
  - add the new security_supported flag
  - add a call to opal_unlock_from_suspend
