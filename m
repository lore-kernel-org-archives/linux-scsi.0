From: Ondrej Zary <linux@zary.sk>
Subject: [PATCH v2 0/3] fdomain: Resurrect driver
Date: Tue, 14 May 2019 19:23:06 +0200
Message-ID: <20190514172309.12874-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Resurrect previously removed fdomain driver, in modern style.
Initialization is rewritten completely, with support for multiple cards,
no more global state variables.
Most of the code from interrupt handler is moved to a workqueue.

This is a modularized version with core separated from bus-specific drivers
(PCI, ISA and PCMCIA). Only PCI and ISA drivers are submitted for now.

Changes in v2:
 - BIOS-related code moved to ISA driver and simplified
 - fixed (un)locking in fdomain_host_reset

-- 
Ondrej Zary
