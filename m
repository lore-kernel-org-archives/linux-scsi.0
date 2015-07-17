From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] [RESEND] ipr: Fix locking for unit attention handling
Date: Thu, 16 Jul 2015 21:57:58 -0400
Message-ID: <yq1lhefmtp5.fsf@sermon.lab.mkp.net>
References: <201507141641.t6EGfUKf005602@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33544 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbGQB6G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2015 21:58:06 -0400
In-Reply-To: <201507141641.t6EGfUKf005602@d03av03.boulder.ibm.com> (Brian
	King's message of "Tue, 14 Jul 2015 11:41:29 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> Make sure we have the host lock held when calling
Brian> scsi_report_bus_reset. Fixes a crash seen as the __devices list
Brian> in the scsi host was changing as we were iterating through it.

Nit: I take it that renaming lock_flags to hrrq_flags makes sense. But
it muddles what is supposed to be a bugfix patch.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
