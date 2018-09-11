From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv3 0/2] String fixups in ibmvscsi
Date: Tue, 11 Sep 2018 12:22:24 -0700
Message-ID: <20180911192226.3620-1-labbott@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

This is (hopefully) the last version of the string fixups found in the
ibmvscsi driver.

Laura Abbott (2):
  scsi: ibmvscsis: Fix a stringop-overflow warning
  scsi: ibmvscsis: Ensure partition name is properly NUL terminated

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.17.1
