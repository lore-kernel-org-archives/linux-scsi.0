From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [SCSI] mpt2sas T10 DIF fixes
Date: Mon, 20 Feb 2012 20:36:21 -0500
Message-ID: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33285 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab2BUBgd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 20:36:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com


This is a repost of the T10 DIF patches against mpt2sas that I posted a
while back:

 - Patch 1 fixes a bug where the driver reports the wrong error code to
   the SCSI layer when a T10 DIF error is detected.

 - Patch 2 adds a module parameter that allows the host protection mask
   to be specified at runtime so DIF can be disabled for mpt2sas if
   needed.

 - Patch 3 fixes the use of mpt2sas in combination with drives formatted
   with protecton information. This is the bug reported by Doug Gilbert
   here:   

   	http://marc.info/?l=linux-scsi&m=132154754616596

   The patch is required due to a change in default behavior with latest
   LSI firmware versions.

-- 
Martin K. Petersen	Oracle Linux Engineering

