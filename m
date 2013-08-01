From: Jan Vesely <jvesely@redhat.com>
Subject: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology change
Date: Thu,  1 Aug 2013 12:01:29 +0200
Message-ID: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Vesely <jvesely@redhat.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Jan Vesely <jvesely@redhat.com>

These two patches add phy removal on link loss. This change keeps sysfs
up-to-date with actually connected phys. Without these patches,
 disconnected phys remain listed under their former ports.

tested on both mpt2sas and mpt3sas hw.

CC: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
CC: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
CC: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Jan Vesely <jvesely@redhat.com>

Jan Vesely (2):
  mpt2sas: Remove phys on topology change.
  mpt3sas: Remove phys on topology change

 drivers/scsi/mpt2sas/mpt2sas_transport.c |    5 ++++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)
