From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: Fix max transfer length for 4k disks
Date: Thu, 29 Jan 2015 19:43:51 -0500
Message-ID: <yq1h9v9gks8.fsf@sermon.lab.mkp.net>
References: <201501292155.t0TLt4qF025739@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <201501292155.t0TLt4qF025739@d01av05.pok.ibm.com> (Brian King's
	message of "Thu, 29 Jan 2015 15:54:40 -0600")
Sender: stable-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> on a 4k sector disk, every time we went through
Brian> sd_revalidate_disk, we were taking the current value of
Brian> queue_max_hw_sectors and increasing it by a factor of 8. Fix this
Brian> by only shifting sdkp->max_xfer_blocks.

*blush*

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
