From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Increase cmd_per_lun for higher speed devices
Date: Tue, 30 Jan 2018 22:06:15 -0500
Message-ID: <yq1po5qenh4.fsf@oracle.com>
References: <1516834132-26273-1-git-send-email-mikelley@ntdev.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516834132-26273-1-git-send-email-mikelley@ntdev.microsoft.com>
        (Michael Kelley's message of "Wed, 24 Jan 2018 22:49:57 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Long Li <longli@microsoft.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> Increase cmd_per_lun to allow more I/Os in progress per device,
> particularly for NVMe's.  The Hyper-V host side can handle the
> higher count with no issues.

Long/KY/Cathy/Stephen: Please ack/review Michael's patches.

-- 
Martin K. Petersen	Oracle Linux Engineering
