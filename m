From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/22] [PATCH] mpt2sas, mpt3sas: Fail the host reset initiated due to discovery related I/O timeouts at driver load time
Date: Wed, 03 Dec 2014 21:57:45 -0500
Message-ID: <yq1r3wgi0k6.fsf@sermon.lab.mkp.net>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-4-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416467155-16869-4-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:36 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> When a flaky disk is there in a topology then during driver
Sreekanth> load, discovery related I/O times out; which results in SCSI
Sreekanth> error recovery initiating host reset and then the controller
Sreekanth> won't see any disk.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
