From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 00/16] Replace Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:19:31 -0400
Message-ID: <1310710771.3184.51.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Plenty of older drivers are still using the ugly Scsi_Cmd typedef. The
following patchset removes it and change it for struct scsi_cmnd.

drivers/scsi/NCR5380.c       |   72 +++++++++++++++++-----------------
drivers/scsi/NCR5380.h       |   14 +++---
drivers/scsi/NCR53c406a.c    |    6 +-
drivers/scsi/aha152x.c       |   68 ++++++++++++++++----------------
drivers/scsi/aha1542.c       |   28 ++++++------
drivers/scsi/aha1542.h       |   10 ++--
drivers/scsi/aha1740.c       |    8 ++--
drivers/scsi/aha1740.h       |    4 +-
drivers/scsi/atari_NCR5380.c |   90
+++++++++++++++++++++---------------------
drivers/scsi/atari_scsi.c    |   10 ++--
drivers/scsi/atari_scsi.h    |    2 +-
drivers/scsi/dtc.h           |    4 +-
drivers/scsi/fd_mcs.c        |   10 ++--
drivers/scsi/g_NCR5380.c     |   10 ++--
drivers/scsi/g_NCR5380.h     |    4 +-
drivers/scsi/gdth.c          |   64 +++++++++++++++---------------
drivers/scsi/gdth.h          |   10 ++--
drivers/scsi/gdth_proc.c     |    2 +-
drivers/scsi/ibmmca.c        |   26 ++++++------
drivers/scsi/in2000.c        |   68 ++++++++++++++++----------------
drivers/scsi/in2000.h        |   12 +++---
drivers/scsi/megaraid.c      |   28 ++++++------
drivers/scsi/megaraid.h      |   16 ++++----
drivers/scsi/nsp32_debug.c   |    2 +-
drivers/scsi/pas16.h         |    4 +-
drivers/scsi/scsi.h          |    3 -
drivers/scsi/scsi_typedefs.h |    2 -
drivers/scsi/sym53c416.c     |    6 +-
drivers/scsi/sym53c416.h     |    2 +-
drivers/scsi/wd7000.c        |    2 +-
30 files changed, 291 insertions(+), 296 deletions(-) 
