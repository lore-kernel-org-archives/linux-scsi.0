From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Various T10 PI bug fixes
Date: Fri, 13 Jan 2012 17:43:00 -0500
Message-ID: <1326494586-17360-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:40260 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2AMWnX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2012 17:43:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com

This patch series fixes various issues with T10 PI (DIF) we discovered
in the field. The 3 first patches apply to the mpt2sas driver. The
remaining 3 are core SCSI patches.

-- 
Martin K. Petersen	Oracle Linux Engineering

