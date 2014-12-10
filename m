From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 07/22] [SCSI] mpt2sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
Date: Wed, 10 Dec 2014 15:40:38 -0500
Message-ID: <yq161djdyrd.fsf@sermon.lab.mkp.net>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-8-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1a934i055.fsf@sermon.lab.mkp.net>
	<CAK=zhgr-+MaT6UeXR96G-nMGfo8RdmHVRN1wkUKjz7h6gwLNhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgr-+MaT6UeXR96G-nMGfo8RdmHVRN1wkUKjz7h6gwLNhg@mail.gmail.com>
	(Sreekanth Reddy's message of "Tue, 9 Dec 2014 17:38:32 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> For any SCSI command, if the driver receives IOC status =
Sreekanth> SCSI_IOC_TERMINATED and log info = 0x32010081 then that
Sreekanth> command will be completed with DID_RESET host status.
>> 
>> What does that log info value mean?

Sreekanth> The meaning of this log info value is "Virtual IO has failed
Sreekanth> and has to be retried".

OK, I'd prefer to see that documented in the patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
