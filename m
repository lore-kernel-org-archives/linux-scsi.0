From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] [4.9-rc] ipr: Fix async error WARN_ON
Date: Fri, 14 Oct 2016 16:27:08 -0400
Message-ID: <yq1oa2mk76r.fsf@sermon.lab.mkp.net>
References: <20161013194524.EA0286A03C@b03ledav003.gho.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36189 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751985AbcJNU1T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 16:27:19 -0400
In-Reply-To: <20161013194524.EA0286A03C@b03ledav003.gho.boulder.ibm.com>
        (Brian King's message of "Thu, 13 Oct 2016 14:45:24 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> Commit afc3f83cb4a5 ("scsi: ipr: Add asynchronous error
Brian> notification") introduced the warn on shown below. To fix this,
Brian> rather than attempting to send the KOBJ_CHANGE uevent from
Brian> interrupt context, which is what is causing the WARN_ON, just
Brian> wake the ipr worker thread which will send a KOBJ_CHANGE uevent.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
