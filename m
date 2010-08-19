From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Discard/trim/thin provisioning update
Date: Thu, 19 Aug 2010 11:48:55 -0400
Message-ID: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

This patchkit updates a few things in the discard/trim/thin provisioning
department.  First of all we add support for the newly minted Thin
Provisioning VPD.  The other main feature is support for bigger TRIM
payloads on ATA devices that support it.  And finally there's a few
bugfixes for our SCSI VPD wrapper (will we ever get this right?).

[PATCH 1/6] libata: Signal that our SATL supports WRITE SAME(16) with UNMAP
[PATCH 2/6] libata: Report supported TRIM payload size
[PATCH 3/6] block: Make max_discard_sectors sector_t
[PATCH 4/6] scsi: Fix VPD page wrapper
[PATCH 5/6] scsi_debug: Update thin provisioning support
[PATCH 6/6] sd: Update thin provisioning support

-- 
Martin K. Petersen	Oracle Linux Engineering

