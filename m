From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: storvsc: Add ability to change scsi queue depth
Date: Tue, 18 Jun 2019 21:08:59 -0400
Message-ID: <yq1fto6xtxw.fsf@oracle.com>
References: <20190614234822.5193-1-brandonbonaby94@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190614234822.5193-1-brandonbonaby94@gmail.com> (Branden
        Bonaby's message of "Fri, 14 Jun 2019 19:48:22 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Branden Bonaby <brandonbonaby94@gmail.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Branden,

> Adding functionality to allow the SCSI queue depth to be changed, by
> utilizing the "scsi_change_queue_depth" function.

Applied to 5.3/scsi-queue. Please run checkpatch before submission. I
fixed it up this time.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
