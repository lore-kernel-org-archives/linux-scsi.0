From: Benjamin Rood <benjaminjrood@gmail.com>
Subject: [PATCH 0/8] pm80xx: Add ATTO 12Gb HBA support and fix various issues
Date: Fri, 30 Oct 2015 10:53:23 -0400
Message-ID: <1446216811-2248-1-git-send-email-brood@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35334 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbbJ3Oxe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 10:53:34 -0400
Received: by qkbl190 with SMTP id l190so31575737qkb.2
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 07:53:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com

The following series of patches are primarily aimed at adding support for
ATTO's 12Gb SAS adapters, which are based off of the PMC-Sierra 8070/8072
series chips.  I have also addressed other various issues that were
discovered during our testing and verification phase, mainly with
resume-from-sleep, configuring PHY profiles, and using legacy interrupts.

Diffstat:
drivers/scsi/pm8001/pm8001_defs.h |   2 ++
drivers/scsi/pm8001/pm8001_init.c | 212 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
drivers/scsi/pm8001/pm8001_sas.h  |   6 +++-
drivers/scsi/pm8001/pm80xx_hwi.c  |  34 ++++++++++++++++++++++
4 files changed, 241 insertions(+), 13 deletions(-)

