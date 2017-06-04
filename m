From: Christoph Hellwig <hch@lst.de>
Subject: TCG Opal support for libata
Date: Sun,  4 Jun 2017 14:42:19 +0200
Message-ID: <20170604124225.27032-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

this series adds support for using our new generic TCG OPAL code with
SATA disks, and as side effect for SCSI disks (although so far it doesn't
seem like none of those actually exist).
