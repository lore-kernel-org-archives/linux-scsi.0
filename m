From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/8] megaraid_sas : Reserve commands for IOCTLs and internal DCMDs
Date: Tue, 06 Jan 2015 19:39:21 -0500
Message-ID: <yq1y4pf5squ.fsf@sermon.lab.mkp.net>
References: <201501051440.t05EeP9Q030054@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34041 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbbAGAjy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 19:39:54 -0500
In-Reply-To: <201501051440.t05EeP9Q030054@palmhbs0.lsi.com> (Sumit Saxena's
	message of "Mon, 5 Jan 2015 20:06:23 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

>>>>> "Sumit" ==   <Sumit.Saxena@avagotech.com> writes:

Sumit> 1)For fusion adapters, limited reserved frames for non SCSI
Sumit> commands to 8(3 for parallel IOCTLs + 5 for driver's internal
Sumit> DCMDs).  Earlier reserved commands for non SCSI IO frames was set
Sumit> to 32, so with this implementation, increased per controller
Sumit> "can_queue". Behavior of MFI controllers will remain unchanged.

This whole reserved commands business seems a bit brittle to me. But I
don't have any particular objections to the code.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
