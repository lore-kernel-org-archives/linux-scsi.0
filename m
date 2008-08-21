From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 17/18] scsi: select CRC_T10DIF only when necessary
Date: Thu, 21 Aug 2008 10:01:21 -0400
Message-ID: <yq1vdxuzcum.fsf@sermon.lab.mkp.net>
References: <200808202355.m7KNtaxo006233@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:34855 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYHUODN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 10:03:13 -0400
In-Reply-To: <200808202355.m7KNtaxo006233@imap1.linux-foundation.org> (akpm@linux-foundation.org's message of "Wed\, 20 Aug 2008 16\:55\:36 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, stefanr@s5r6.in-berlin.de, martin.petersen@oracle.com


-	select CRC_T10DIF
+	select CRC_T10DIF if BLK_DEV_INTEGRITY

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
