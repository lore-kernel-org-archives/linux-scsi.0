From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: DIF/DIX updates for 2.6.32
Date: Fri, 11 Sep 2009 15:20:47 -0400
Message-ID: <1252696852-17091-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:19524 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZIKTUz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 15:20:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Updates since last post:

 - The CDB allocation has been moved to sd.c and the Type 2 support collapsed
   into a single patch.

The first three patches constitute fixes.  The last two contain new features.

--  
Martin K. Petersen	Oracle Linux Engineering


