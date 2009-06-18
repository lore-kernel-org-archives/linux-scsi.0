From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] sd: Physical block size and alignment support
Date: Thu, 18 Jun 2009 17:02:57 +0000
Message-ID: <1245344577.7586.14.camel@mulgrave.site>
References: <1243093419-14371-1-git-send-email-martin.petersen@oracle.com>
	 <1243093419-14371-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41907 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbZFRXFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 19:05:36 -0400
In-Reply-To: <1243093419-14371-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 2009-05-23 at 11:43 -0400, Martin K. Petersen wrote:
> Extract physical block size and lowest aligned LBA from READ
> CAPACITY(16) response and adjust queue parameters.
> 
> Report physical block size and alignment when applicable.

Checkpatch reports one trailing whitespace (I fixed it up):

ERROR: trailing whitespace
#40: FILE: drivers/scsi/sd.c:1369:
+^I^Isd_printk(KERN_NOTICE, sdkp, $

total: 1 errors, 0 warnings, 63 lines checked

James


