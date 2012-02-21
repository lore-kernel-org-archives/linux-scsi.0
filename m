From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: T10 PI bugfixes
Date: Mon, 20 Feb 2012 20:20:42 -0500
Message-ID: <1329787245-1899-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43257 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2BUBU4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 20:20:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com


This is a repost of the DIF patches I sent out a while back. The only
change is converting to from simple_stroul() to kstrouint() in patch 2.

-- 
Martin K. Petersen	Oracle Linux Engineering

