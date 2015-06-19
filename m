From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 13/20] [SCSI] mpt3sas: MPI 2.5 Rev K (2.5.6) specifications
Date: Fri, 19 Jun 2015 16:36:42 -0400
Message-ID: <yq1wpyza10l.fsf@sermon.lab.mkp.net>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-14-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434102153-38581-14-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 12 Jun 2015 15:12:25 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

> Below are the new changes to MPI 2.5 Rev K(2.5.6) specification and
> 2.00.35 header files 1) Added a minimum size requirement for target
> mode command buffers.  2) Added MinMSIxIndex and MaxMSIxIndex fields
> to CommandBufferPostBase Request.  3) For BIOS Page 1, added
> SSUTimeout field, and added Product Name String Format bits to the
> BiosOptions field

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
