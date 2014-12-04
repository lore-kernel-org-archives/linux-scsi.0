From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
Date: Wed, 03 Dec 2014 22:05:49 -0500
Message-ID: <yq1egsgi06q.fsf@sermon.lab.mkp.net>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-7-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416467155-16869-7-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:39 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> 1. Removed the upper boundary restriction for the module
Sreekanth> parameter max_sgl_entries. Earlier, the max_sgl_entries was
Sreekanth> capped at the SCSI_MAX_SG_SEGMENTS kernel definition. With
Sreekanth> this change, the user would be able to set the
Sreekanth> max_sgl_entries to any value.

Shouldn't you be capping at SCSI_MAX_SG_CHAIN_SEGMENTS (or the actual hw
limit)?

-- 
Martin K. Petersen	Oracle Linux Engineering
