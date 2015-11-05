From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 0/2] megaraid_sas: couple of fixes
Date: Thu,  5 Nov 2015 21:17:36 +0530
Message-ID: <1446738458-12425-1-git-send-email-Sumit.Saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33090 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030685AbbKEPr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 10:47:59 -0500
Received: by pabfh17 with SMTP id fh17so90877170pab.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2015 07:47:59 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@odin.com, martin.petersen@oracle.com, thenzl@redhat.com
Cc: kashyap.desai@avagotech.com

Sumit Saxena (2):
  megaraid_sas: Fix TAPE drive not exposed attached to PERC5 controller
  megaraid_sas: Fix sparse warning

 drivers/scsi/megaraid/megaraid_sas.h        |    1 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |   20 +++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
 3 files changed, 19 insertions(+), 4 deletions(-)

