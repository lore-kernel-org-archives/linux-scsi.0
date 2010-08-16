From: realrichardsharpe@gmail.com
Subject: (unknown)
Date: Sun, 15 Aug 2010 17:08:32 -0700
Message-ID: <1281917313-1855-1-git-send-email-realrichardsharpe@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53275 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0HPAIv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Aug 2010 20:08:51 -0400
Received: by pzk26 with SMTP id 26so1679671pzk.19
        for <linux-scsi@vger.kernel.org>; Sun, 15 Aug 2010 17:08:51 -0700 (PDT)
Subject: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch is being sent for feedback and review.

When I got AEN working in scst_local I noticed that deleting LUNs on 
the target (Linux SCSI) so I tracked it down to what looks like failure 
to take into account that LUNs might have been deleted in 
drivers/scsi/scsi_scan.c, in particular in scsi_report_lun_scan.

The changes work in the sense that if I delete LUNs in a variety of 
orders (starting at 0 and working up, starting at the largest and 
working backward, starting in the middle), but I wonder if I have 
missed anything.
