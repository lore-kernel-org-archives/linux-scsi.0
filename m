From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] [RESEND] ipr: Fix incorrect trace indexing
Date: Thu, 16 Jul 2015 21:58:52 -0400
Message-ID: <yq1h9p3mtnn.fsf@sermon.lab.mkp.net>
References: <201507141641.t6EGfWxP005714@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <201507141641.t6EGfWxP005714@d03av03.boulder.ibm.com> (Brian
	King's message of "Tue, 14 Jul 2015 11:41:31 -0500")
Sender: stable-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> When ipr's internal driver trace was changed to an atomic, a
Brian> signed/unsigned bug slipped in which results in us indexing
Brian> backwards in our memory buffer writing on memory that does not
Brian> belong to us. This patch fixes this by removing the modulo and
Brian> instead just mask off the low bits.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
