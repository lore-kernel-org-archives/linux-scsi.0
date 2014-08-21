From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
Date: Thu, 21 Aug 2014 16:35:59 -0400
Message-ID: <yq1wqa1r368.fsf@sermon.lab.mkp.net>
References: <1407835482-37919-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407835482-37919-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 12 Aug 2014 14:54:42 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> Sending the this patch once agin using git send-email.  Up to
Sreekanth> now, Driver allocates a single contiguous block of memory
Sreekanth> pool for all reply queues and passes down a single address in
Sreekanth> the ReplyDescriptorPostQueueAddress field of the IOC Init
Sreekanth> Request Message to the firmware.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
