From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 07/22] [SCSI] mpt2sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
Date: Wed, 03 Dec 2014 22:06:46 -0500
Message-ID: <yq1a934i055.fsf@sermon.lab.mkp.net>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-8-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416467155-16869-8-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:40 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> For any SCSI command, if the driver receives IOC status =
Sreekanth> SCSI_IOC_TERMINATED and log info = 0x32010081 then that
Sreekanth> command will be completed with DID_RESET host status.

What does that log info value mean?

-- 
Martin K. Petersen	Oracle Linux Engineering
