From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 14/20 v1] [SCSI] mpt3sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
Date: Fri, 19 Jun 2015 16:38:48 -0400
Message-ID: <yq1si9na0x3.fsf@sermon.lab.mkp.net>
References: <1434432924-40632-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434432924-40632-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Tue, 16 Jun 2015 11:05:24 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, jthumshirn@suse.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

> For any SCSI command, if the driver receives IOC status =
> SCSI_IOC_TERMINATED and log info = 0x32010081 then that command will
> be completed with DID_RESET host status.

> The definition of this log info value is "Virtual IO has failed and
> has to be retried".

> Firmware will provide this log info value with IOC Status
> "SCSI_IOC_TERMINATED", whenever a drive (with is a part of a volume)
> is pulled and pushed back within some minimal delay.  With this log
> info value, firmware informs the driver to retry the failed IO command
> infinite times, so to provide some time for the firmware to discover
> the reinserted drive successfully instated of just retrying failed
> command for five times(doesn't giving enough time for firmware to
> complete the drive discovery) and failing the IO permanently even
> though drive came back successfully.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
