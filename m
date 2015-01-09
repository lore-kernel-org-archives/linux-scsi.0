From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
Date: Fri, 09 Jan 2015 15:55:05 -0500
Message-ID: <yq1y4pbznbq.fsf@sermon.lab.mkp.net>
References: <1420635235-2222-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420635235-2222-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Wed, 7 Jan 2015 18:23:55 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> 1. Extended the upper boundary restriction for the module
Sreekanth> parameter max_sgl_entries.  Earlier, the max_sgl_entries was
Sreekanth> capped at the SCSI_MAX_SG_SEGMENTS kernel definition.  With
Sreekanth> this change, the user would be able to set the
Sreekanth> max_sgl_entries to any value which is greater than
Sreekanth> SCSI_MAX_SG_SEGMENTS and less than the minimum of
Sreekanth> SCSI_MAX_SG_CHAIN_SEGMENTS & hardware limit(Calculated using
Sreekanth> IOCFacts's MaxChainDepth).

Sreekanth> 2. Added a print for the message log whenever the user sets
Sreekanth> the max_sgl_entries to a value greater than
Sreekanth> SCSI_MAX_SG_SEGMENTS to warn about the kernel definition
Sreekanth> overriding.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
