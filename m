From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] [RESEND] ipr: Fix locking for unit attention handling
Date: Fri, 17 Jul 2015 08:02:18 -0500
Message-ID: <55A8FCDA.9030209@linux.vnet.ibm.com>
References: <201507141641.t6EGfUKf005602@d03av03.boulder.ibm.com> <yq1lhefmtp5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:55551 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbbGQNCZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2015 09:02:25 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 17 Jul 2015 09:02:24 -0400
In-Reply-To: <yq1lhefmtp5.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com

On 07/16/2015 08:57 PM, Martin K. Petersen wrote:
>>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:
> 
> Brian> Make sure we have the host lock held when calling
> Brian> scsi_report_bus_reset. Fixes a crash seen as the __devices list
> Brian> in the scsi host was changing as we were iterating through it.
> 
> Nit: I take it that renaming lock_flags to hrrq_flags makes sense. But
> it muddles what is supposed to be a bugfix patch.
> 
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> 

Correct. Thanks for the review.

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


