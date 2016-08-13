From: Joe Perches <joe@perches.com>
Subject: [PATCH 0/2] be2iscsi: Logging neatening
Date: Sat, 13 Aug 2016 13:42:38 -0700
Message-ID: <cover.1471119911.git.joe@perches.com>
References: <1471107782.3467.28.camel@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471107782.3467.28.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Joe Perches (2):
  be2iscsi: Coalesce split strings and formats
  be2iscsi: Use a standard logging style

 drivers/scsi/be2iscsi/be_cmds.c  |  61 +++---
 drivers/scsi/be2iscsi/be_iscsi.c | 115 ++++++-----
 drivers/scsi/be2iscsi/be_main.c  | 398 +++++++++++++++++----------------------
 drivers/scsi/be2iscsi/be_main.h  |  19 +-
 drivers/scsi/be2iscsi/be_mgmt.c  |  99 +++++-----
 5 files changed, 314 insertions(+), 378 deletions(-)

-- 
2.8.0.rc4.16.g56331f8
