From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] [RESEND] ipr: Fix invalid array indexing for HRRQ
Date: Thu, 16 Jul 2015 22:00:32 -0400
Message-ID: <yq1d1zrmtkv.fsf@sermon.lab.mkp.net>
References: <201507141641.t6EGfXmA021616@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <201507141641.t6EGfXmA021616@d01av05.pok.ibm.com> (Brian King's
	message of "Tue, 14 Jul 2015 11:41:33 -0500")
Sender: stable-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> Fixes another signed / unsigned array indexing bug in the ipr
Brian> driver.  Currently, when hrrq_index wraps, it becomes a negative
Brian> number. We do the modulo, but still have a negative number, so we
Brian> end up indexing backwards in the array. Given where the hrrq
Brian> array is located in memory, we probably won't actually reference
Brian> memory we don't own, but nonetheless ipr is still looking at data
Brian> within struct ipr_ioa_cfg and interpreting it as struct
Brian> ipr_hrr_queue data, so bad things could certainly happen.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
