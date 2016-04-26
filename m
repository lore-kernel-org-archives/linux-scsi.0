From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 00/10] aacraid: Patchset for aacraid driver version 41066
Date: Mon, 25 Apr 2016 23:30:48 -0700
Message-ID: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0077.outbound.protection.outlook.com ([65.55.169.77]:56453
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752429AbcDZGTk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:19:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

This patchset contains the following changes(bug fixes, features and
code refactors) specific to the aacraid driver

---

Raghava Aditya Renukunta (10):
  [SCSI] aacraid: Removed unnecessary checks for NULL
  [SCSI] aacraid: Fix incorrectly named MACRO
  [SCSI] aacraid: Start adapter after updating number of MSIX vectors
  [SCSI] aacraid: Relinquish CPU during timeout wait
  [SCSI] aacraid: Disable MSI mode for series 6, 7, 8 cards
  [SCSI] aacraid: Fix for aac_command_thread hang
  [SCSI] aacraid: Log firmware AIF messages
  [SCSI] aacraid: Remove code to needlessly complete fib
  [SCSI] aacraid: Fix for KDUMP driver hang
  [SCSI] aacraid: Update driver version


 drivers/scsi/aacraid/aachba.c   |   22 --------------------
 drivers/scsi/aacraid/aacraid.h  |    9 ++++++--
 drivers/scsi/aacraid/comminit.c |   43 ++++++++++++++++++++++++---------------
 drivers/scsi/aacraid/commsup.c  |   39 ++++++++++++++++++++++++++++++++---
 drivers/scsi/aacraid/dpcsup.c   |    7 ++++--
 drivers/scsi/aacraid/linit.c    |    4 +++-
 drivers/scsi/aacraid/src.c      |    3 ++-
 7 files changed, 78 insertions(+), 49 deletions(-)

--
Signature
