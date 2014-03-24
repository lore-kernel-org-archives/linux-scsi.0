From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 0/4] be2iscsi: Update to 10.2.214.0
Date: Sun, 23 Mar 2014 23:28:17 -0400
Message-ID: <1395631697-26116-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46984 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaCXD23 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Mar 2014 23:28:29 -0400
Received: by mail-pb0-f51.google.com with SMTP id uo5so4871336pbc.10
        for <linux-scsi@vger.kernel.org>; Sun, 23 Mar 2014 20:28:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>

 This patchset updates be2iscsi to 10.2.214.0

These patches are based on pending branch of scit.git 

0001 - Fix retreving MCCQ_WRB in non-embedded Mbox
0002 - Relinquishing control after 512 CQE
0003 - Fix MCCQ posting for Mbx Cmd after driver init
0004 - Bump the driver version 

Thanks
Jay

Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
