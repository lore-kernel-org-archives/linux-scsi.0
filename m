From: Joe Perches <joe@perches.com>
Subject: [PATCH 0/7] Neaten logging uses
Date: Mon, 17 Sep 2018 08:01:07 -0700
Message-ID: <cover.1537183087.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Several defects exist in the logging uses

o Missing KERN_<LEVEL>
o Unnecessary KERN_<LEVEL> uses with panic
o Mismatched MPT3SAS_FMT and %s: with name and __func__

Correct these defects and perhaps add some clarity to the logging.

Joe Perches (7):
  mpt3sas: Add ioc_<level> logging macros
  mpt3sas: Convert uses of pr_<level> with MPT3SAS_FMT to ioc_<level>
  mpt3sas: Convert mlsleading uses of pr_<level> with MPT3SAS_FMT
  mpt3sas: Convert logging uses with MPT3SAS_FMT and reply_q_name to %s:
  mpt3sas: Remove KERN_WARNING from panic uses
  mpt3sas: Convert logging uses with MPT3SAS_FMT without logging levels
  mpt3sas: Remove unused macro MPT3SAS_FMT

 drivers/scsi/mpt3sas/mpt3sas_base.c         | 1116 +++++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_base.h         |    9 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |   89 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |  493 ++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 1487 ++++++++++++---------------
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  337 +++---
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |  101 +-
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c    |   70 +-
 8 files changed, 1618 insertions(+), 2084 deletions(-)

-- 
2.15.0
